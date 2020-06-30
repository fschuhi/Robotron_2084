#!/usr/bin/env python3

from util import *
from Emulator import *
import math


class CPUHook:
    def __init__( self, emulator ):
        self.emulator = emulator  # type: Emulator
        self.apple2 = emulator.apple2  # type: Apple2
        self.cpu = emulator.cpu  # type: CPU
        self.mem = emulator.mem

        self.other_write_hook = None
        self.other_read_hook = None
        self.write_hooked = False
        self.read_hooked = False
        self.hooked = False

    def reset( self ):
        pass

    def post_op( self ):
        pass

    def write_hook( self, address, newvalue ):
        # make sure the other hook receives the write
        return self.other_write_hook( address, newvalue ) if self.other_write_hook else True

    def read_hook( self, address, value ):
        # make sure the other hook receives the write
        return self.other_read_hook( address, value ) if self.other_read_hook else True

    def enable_hooks( self ):
        self.enable_write_hook( )
        self.enable_read_hook( )

    def disable_hooks( self ):
        self.disable_write_hook( )
        self.disable_read_hook( )
        self.hooked = False

    def enable_write_hook( self ):
        # reinstall write hook we encountered when hooking
        if not self.write_hooked:
            self.other_write_hook = self.cpu.write_hook
            self.cpu.write_hook = self.write_hook
            self.write_hooked = True
            self.hooked = True
            self.reset( )

    def enable_read_hook( self ):
        # reinstall write hook we encountered when hooking
        if not self.read_hooked:
            self.other_read_hook = self.cpu.read_hook
            self.cpu.read_hook = self.read_hook
            self.read_hooked = True
            self.hooked = True
            self.reset( )

    def disable_write_hook( self ):
        if self.write_hooked:
            self.cpu.write_hook = self.other_write_hook
            self.other_write_hook = None
            self.write_hooked = False
            self.hooked = self.read_hooked

    def disable_read_hook( self ):
        if self.read_hooked:
            self.cpu.read_hook = self.other_read_hook
            self.other_read_hook = None
            self.read_hooked = False
            self.hooked = self.write_hooked


class TimeMachine( CPUHook ):
    def __init__( self, emulator ):
        super( ).__init__( emulator )
        self.last_write = None
        self.state_index = 0
        self.write_states = []
        self.cpu_states = []

    def reset( self ):
        self.last_write = None
        self.state_index = 0
        self.write_states = []
        self.cpu_states = []

    def post_op( self ):
        self.store_write_data( )
        super( ).post_op( )

    def write_hook( self, address, newvalue ):
        # IMPORTANT: we must not add to writes[] and cpus[] in the hook method.
        # This method is called somewhere during execution. instruction has not yet run to completion in the CPU.
        oldvalue = self.mem[address]
        self.last_write = (address, oldvalue, newvalue)
        return super( ).write_hook( address, newvalue )

    def store_write_data( self ):
        if not self.write_hooked: return
        if not self.last_write: return
        self.write_states.append( self.last_write )
        pickled_cpu = self.cpu.pickle_to_variable( )
        self.cpu_states.append( pickled_cpu )
        self.last_write = None

    def enable_restoring( self ):
        if not self.write_hooked: return
        assert len( self.write_states ) == len( self.cpu_states )
        self.state_index = len( self.write_states ) - 2
        self.restore_next_state( 1 )

    def disable_restoring( self ):
        if not self.write_hooked: return
        del self.write_states[self.state_index:]
        del self.cpu_states[self.state_index:]

    def restore_cpu( self ):
        if not self.write_hooked: return
        pickled_cpu = self.cpu_states[self.state_index]
        self.cpu.unpickle_from_variable( pickled_cpu )

    def restore_next_state( self, states ):
        if not self.write_hooked: return 0
        restored_states = 0
        while self.state_index < len( self.write_states ) - 1:
            self.state_index += 1
            address, oldvalue, newvalue = self.write_states[self.state_index]
            self.mem[address] = newvalue
            self.restore_cpu( )
            restored_states += 1
            if restored_states == states:
                break
        self.apple2.display.refresh_hires( )
        return restored_states

    def restore_prev_state( self, states ):
        if not self.write_hooked: return 0
        restored_states = 0
        while self.state_index > 1:
            address, oldvalue, newvalue = self.write_states[self.state_index]
            self.mem[address] = oldvalue
            self.state_index -= 1
            self.restore_cpu( )
            restored_states += 1
            if restored_states == states:
                break
        self.apple2.display.refresh_hires( )
        return restored_states


class MemAccessCollector( CPUHook ):
    def __init__( self, emulator ):
        super( ).__init__( emulator )

        self.last_write = None
        self.last_reads = None

        self.memory_states = []

    def reset( self ):
        self.last_write = None
        self.last_reads = None
        # do not clear the memory states
        super( ).reset( )

    def post_op( self ):
        self.store_data( )

    def store_data( self ):
        if not self.hooked: return
        if (not self.last_write) and (not self.last_reads): return
        cpu_state = (self.cpu.cycles, self.cpu.last_PC)
        last_reads = self.last_reads
        last_write = self.last_write if self.last_write else None
        state = (cpu_state, last_reads, last_write)
        self.memory_states.append( state )

        self.last_write = None
        self.last_reads = None

    def write_hook( self, address, newvalue ):
        # This method is called somewhere during execution. instruction has not yet run to completion in the CPU.
        oldvalue = self.mem[address]
        self.last_write = (address, oldvalue, newvalue)
        return super( ).write_hook( address, newvalue )

    def read_hook( self, address, value ):
        # This method is called somewhere during execution. instruction has not yet run to completion in the CPU.
        if self.last_reads:
            self.last_reads.append( (address, value) )
        else:
            self.last_reads = [(address, value)]
        return super( ).read_hook( address, value )

    def access_counts_as_table(self):
        write_accesses = [0] * 0xD000
        read_accesses = [0] * 0xD000
        pc_accesses = [0] * 0xD000
        for (cpu_state, reads, write) in self.memory_states:
            cycles, last_PC = cpu_state
            pc_accesses[last_PC] += 1
            if reads is not None:
                for read in reads:
                    address, value = read
                    if address < 0xD000:
                        read_accesses[address] += 1
            if write is not None:
                address, oldvalue, newvalue = write
                write_accesses[address] += 1

        lines = [['address', 'write', 'read', 'PC']]
        for address in range(0,0xD000):
            write_count = write_accesses[address]
            read_count = read_accesses[address]
            PC_count = pc_accesses[address]
            line = [address, write_count, read_count, PC_count]
            lines.append(line)

        return lines

    def max_cycles(self):
        last = self.memory_states[-1]
        cpu_state, reads, write = last
        cycles, last_PC = cpu_state
        return cycles

    def count_mem_accesses(self):
        return len(self.memory_states)

    def mem_access_log(self, first_cycle, last_cycle):
        log = [['cycles', 'last_PC', 'ind_addr', 'ind_value', 'read', 'read_value', 'write', 'old_value', 'new_value']]
        for (cpu_state, reads, write) in self.memory_states:

            cycles, last_PC = cpu_state

            if (first_cycle is None or cycles >= first_cycle) and (last_cycle is None or cycles <= last_cycle):
                line = [cycles, hexaddr(last_PC)]

                if reads is not None and write is not None:
                    ind_addr, ind_value = reads[0]
                    address, oldvalue, newvalue = write
                    line.extend(["$" + hexbyte(ind_addr), hexaddr(ind_value), '', '', hexaddr(address), hexbyte(oldvalue), hexbyte(newvalue)])
                elif reads is not None:
                    if len(reads) == 1:
                        address, value = reads[0]
                        line.extend(['', '', hexaddr(address), hexbyte(value), '', '', ''])
                    else:
                        assert len(reads) == 2
                        ind_addr, ind_value = reads[0]
                        address, value = reads[1]
                        line.extend(["$" + hexbyte(ind_addr), hexaddr(ind_value), hexaddr(address), hexbyte(value), '', '', ''])
                else:
                    assert write is not None
                    address, oldvalue, newvalue = write
                    line.extend(['', '', '', '', hexaddr(address), hexbyte(oldvalue), hexbyte(newvalue)])

                log.append(line)
        return log

    def mem_access_colors(self, type, first_cycle=None, last_cycle=None, include_stack=True, only_indirect=False):

        def convert_to_colors(accesses):
            color_low = (146, 206, 147)
            color_medium = (255,235,132)
            color_high = (248,105,107)

            colors = []
            m = math.log(max(accesses)+1)
            # m = max(accesses)
            for access in accesses:
                if access == 0:
                    color = 0
                else:
                    scale = math.log(access+1) / m
                    # scale = access / m
                    assert 0 <= scale <= 1.0
                    if scale < 0.5:
                        rgb = lerp_rgb(color_low, color_medium, scale/0.5)
                    else:
                        rgb = lerp_rgb(color_medium, color_high, (scale-0.5)/0.5)
                    col = int(rgb[0]) + int(rgb[1])*256 + int(rgb[2])*65536
                    # color = "%i/%i/%i, %i" % (int(rgb[0]), int(rgb[1]), int(rgb[2]), col)
                    color = col

                colors.append(color)
            return colors

        def include_address(address):
            if not include_stack:
                if 0x100 <= address <= 0x1ff:
                    return False
            return address < 0xD000

        if only_indirect:
            include_stack = False

        type = type.lower()
        assert type in ['reads', 'writes', 'pcs']
        accesses = [0] * 0xD000
        for (cpu_state, reads, write) in self.memory_states:
            cycles, last_PC = cpu_state
            if (first_cycle is None or cycles >= first_cycle) and (last_cycle is None or cycles <= last_cycle):

                if reads is None and only_indirect:
                    continue

                if type == 'reads':
                    if only_indirect and len(reads) == 1:
                        continue
                    if reads is not None:
                        for read in reads:
                            address, value = read
                            if include_address(address):
                                accesses[address] += 1

                elif type == 'writes':
                    if write is not None:
                        address, oldvalue, newvalue = write
                        if include_address(address):
                            accesses[address] += 1

                else:
                    if write is not None:
                        address, _, _ = write
                        if not include_address(address):
                            continue
                    if reads is not None:
                        if only_indirect and len(reads) == 1:
                            continue
                        inc_last_pc = True
                        for read in reads:
                            address, _ = read
                            if not include_address(address):
                                inc_last_pc = False
                                break
                        if inc_last_pc:
                            accesses[last_PC] += 1


        colors = convert_to_colors(accesses)
        return list(chunks(colors, 256))


    def update_hires(self, pixels, start_hires, address, value, ignore_zero):
        base = address - start_hires
        row8, b = divmod(base, 0x400)
        hi, lo = divmod(b, 0x80)
        row_group, column = divmod(lo, 0x28)
        row = 8 * (hi + 8 * row_group) + row8

        if row < 192 and column < 40:

            for b in range(7):
                c = value & (1 << b)
                if ignore_zero and c == 0:
                    continue
                x = (column * 7 + b)
                y = row
                pixels[y][x] += 1

    def screen_writes_as_table(self, first_cycle=None, last_cycle=None, ignore_zero=False):
        apple_width = 280
        apple_height = 192
        pixels = [[0 for x in range(apple_width)] for y in range(apple_height)]
        start_hires = 0x2000
        end_hires = 0x3fff
        for (cpu_state, reads, write) in self.memory_states:
            cycles, last_PC = cpu_state
            if (first_cycle is None or cycles >= first_cycle) and (last_cycle is None or cycles <= last_cycle):
                if write is not None:
                    address, oldvalue, newvalue = write
                    if start_hires <= address <= end_hires:
                        self.update_hires(pixels, start_hires, address, newvalue, ignore_zero)
        return pixels

    def screen_reads_as_table(self, first_cycle=None, last_cycle=None):
        apple_width = 280
        apple_height = 192
        pixels = [[0 for x in range(apple_width)] for y in range(apple_height)]
        start_hires = 0x2000
        end_hires = 0x3fff
        for (cpu_state, reads, write) in self.memory_states:
            cycles, last_PC = cpu_state
            if (first_cycle is None or cycles >= first_cycle) and (last_cycle is None or cycles <= last_cycle):
                if reads is not None:
                    for read in reads:
                        address, value = read
                        if start_hires <= address <= end_hires:
                            self.update_hires(pixels, start_hires, address, value, ignore_zero=False)
        return pixels


