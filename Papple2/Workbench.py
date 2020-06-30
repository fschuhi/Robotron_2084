#!/usr/bin/env python3

import sys
from Labels import *
from Disassembler import *
from Emulator import *
from Annotations import *
from Tiles import *
from MemLogDlg import *


class Workbench:
    def __init__( self, path=None, show_window=True, time_machine=False, mem_access=False ):
        if path is not None:
            import os
            os.chdir( path )

        sys.setrecursionlimit( 3000 )

        self.emulator = Emulator( no_display=not show_window, quiet=True, time_machine=time_machine, mem_access=mem_access )
        self.emulator.load_image( 0x2dfd, r'bin\ROBOTRON.BIN' )
        # self.emulator.load_image( 0x2dfd, r"tmp\ROBOTRON#062DFD.BIN" )

        self.apple2 = self.emulator.apple2
        self.display = self.apple2.display
        self.cpu = self.emulator.cpu
        self.mem = self.emulator.mem
        self.map = self.emulator.map

        self.labels = Labels( )
        self.dis = Disassembler( self.cpu, self.map, self.labels )  # type: Disassembler

        self.tile_factory = TileFactory( self.emulator.map )
        self.annotations = Annotations( )  # type: Annotations

        self.memlog_dialog = None  # type: MemLogDialog

    def pickle( self, pickler ):
        self.emulator.pickle( pickler )
        pickler.dump( self.labels )
        pickler.dump( self.annotations )

    def unpickle( self, unpickler ):
        self.emulator.unpickle( unpickler )
        self.labels = unpickler.load( )
        self.annotations = unpickler.load( )

        self.tile_factory = TileFactory( self.map )
        self.dis = Disassembler( self.cpu, self.map, self.labels )  # type: Disassembler

    def assign_labels( self ):
        labels = self.labels
        for leap_to_info in self.map.infos:  # type: OpInfo
            if leap_to_info is not None:
                if leap_to_info.leaps_from.count( ) > 0:
                    for leap_from_info in leap_to_info.leaps_from.infos:
                        leap_to_info.label = labels.add_address( leap_from_info.opcode, leap_to_info.address )
                        break

    def add_string_stash( self, address_jsr ):
        info = self.map.get_info( address_jsr )  # type: OpInfo
        if info is None:
            return

        assert info.opcode == JSR

        # string stash starts immediately after the JSR
        byte_block_start = address_jsr + 3
        byte_block_end = byte_block_start
        while self.mem[byte_block_end] != 0x00:
            byte_block_end += 1

        # include 0x00 which concludes the jsr params
        bytes = self.mem[byte_block_start:byte_block_end + 1]
        assert bytes[-1] == 0x00

        # note the type
        types = self.map.types
        types[byte_block_start:byte_block_end + 1] = [MEM_DATA] * len( bytes )
        assert types[address_jsr] == MEM_OPCODE
        assert types[byte_block_start - 1] == MEM_OPERAND
        assert types[byte_block_start] == MEM_DATA
        assert types[byte_block_end] == MEM_DATA
        assert types[byte_block_end + 1] != MEM_DATA

        # OpInfo knows that it has data
        info.data_after_op = bytes

    def link_string_stash_tiles( self, address_jsr, address_after_stash ):
        if self.map.get_info( address_jsr ) is not None:
            self.add_string_stash( address_jsr )
            self.tile_factory.link_tiles_manually( address_jsr, address_after_stash, TYPE_SHOWTEXT )

    def determine_stretches( self ):
        # TODO: move determine_stretches from Emulator to somewhere above
        tf = self.tile_factory
        ann = self.annotations

        tf.init( 0x0000, 0xFFFF )

        # TODO: find algorithm for branching over RTS/JMP (currently link_tiles_manually)
        tf.link_tiles_manually( 0x454b, 0x454c, TYPE_BRANCH_OVER_RTS )  # in waitKbd
        tf.link_tiles_manually( 0x4552, 0x4553, TYPE_BRANCH_OVER_RTS )  # in waitKbd
        tf.link_tiles_manually( 0x5143, 0x5144, TYPE_BRANCH_OVER_RTS )  # in init01
        tf.link_tiles_manually( 0x51ca, 0x51cb, TYPE_BRANCH_OVER_RTS )  # in showText
        tf.link_tiles_manually( 0x4557, 0x455a, TYPE_BRANCH_OVER_JMP )  # in waitKbd
        tf.link_tiles_manually( 0x455a, 0x455d, TYPE_BRANCH_OVER_JMP )  # in waitKbd
        tf.link_tiles_manually( 0x51d9, 0x51dc, TYPE_BRANCH_OVER_JMP )  # in showText

        self.link_string_stash_tiles( 0x456c, 0x4582 )
        self.link_string_stash_tiles( 0x4b6a, 0x4bce )

        tf.update_heads_and_tails( )

        for tile in tf.all_tiles:
            address = tile.first_info( ).address
            for info in tile.infos:
                ann.add( info.address, "tile", hexaddr( address ) )

        # start w/ all tiles marked as being a head of an ensemble of linked (consecutive) tiles
        heads = tf.collect_heads( )  # type: [Tile]

        # dump info on all stretches
        for head in heads:
            tiles = tf.pull_tiles( head )
            stretch = Stretch( tf, tiles )
            address = stretch.first_info( ).address
            for info in stretch.all_infos( ):
                ann.add( info.address, "stretch", hexaddr( address ) )
                ann.add( info.address, "compact", stretch.is_compact( ) )

    """
    dumping MemoryMap, dot call tree
    """

    def collect_map_infos( self ):
        infos = []
        for address, info in enumerate( self.map.infos ):  # type: int, OpInfo
            if info is not None:
                leaping_info = ""
                if info.has_label( ):
                    leaping_info += "%s:" % info.label
                if info.leaps_from.exist( ):
                    leaping_info += " < {0}".format( info.leaps_from.verbose( self.dis ) )
                if info.is_leap( ):
                    leaping_info += " > {0}".format( info.leaps_to.verbose( self.dis ) )

                (_, mnemonic, _) = self.dis.ops[info.opcode]
                if mnemonic == 'RTS' and not info.has_matched_JSR:
                    mnemonic += '*'

                infos.append( [
                    hexaddr( address ),
                    str( info.execution_count ),
                    str( info.first_cycles ),
                    str( info.last_cycles ) if info.last_cycles != info.first_cycles else '',
                    mnemonic,
                    leaping_info,
                ] )
        return infos

    def save_map( self, fn ):
        with open( fn, "w" ) as text_file:
            map_infos = self.collect_map_infos( )
            for map_info in map_infos:
                [address, touch_count, first_cycles, last_cycles, mnemonic, leaping_info] = map_info
                print( "{0} {1} {2} {3}  {4}{5}".format(
                    address,
                    touch_count.ljust( 7 ),
                    first_cycles.ljust( 8 ),
                    last_cycles.ljust( 8 ),
                    mnemonic.ljust( 7 ),
                    leaping_info,
                ), file=text_file )

    def save_dot( self, fn, format, cycles_ruler ):
        call_tree = DotCallTree( self.tile_factory )
        heads = self.tile_factory.collect_heads( )
        fnRendered = call_tree.save_dot( heads, fn, format, cycles_ruler )
        return fnRendered

    """
    disassembling
    """

    def collect_disassembly_ranges( self ):
        # collect uniform memory ranges
        ranges = []

        start_address = None
        end_address = None
        last_type = None
        for address, type in enumerate( self.map.types ):

            # we treat opcode and operand as one operation
            # otherwise we would end up w/ as many blocks as we have operations (not counting unknown + data)
            t = MEM_OPCODE if type == MEM_OPERAND else type
            if t != last_type:
                # type change
                if start_address is not None:
                    # save the uniform block
                    ranges.append( (start_address, end_address, last_type) )

                # start new block
                start_address = address
                last_type = t

            end_address = address

        # add the last block
        if end_address > start_address:
            ranges.append( (start_address, end_address, last_type) )

        return ranges

    def save_asm( self, fn ):
        with open( fn, "w" ) as text_file:

            # TODO: unify
            ranges = self.collect_disassembly_ranges( )
            for (start_address, end_address, type) in ranges:
                range_len = end_address - start_address + 1
                # print(hexaddr(start_address), hexaddr(end_address), type, range_len)

                # suppress byte blocks which would be too long in the listing
                if type == MEM_UNKNOWN and range_len > 2048:
                    continue

                lines = self.dis.disassemble_formatted( start_address, end_address )
                for line in lines:
                    print( line, file=text_file )

    """
    simulated execution
    """

    def simulate_execution( self, start_info: OpInfo ) -> [(int, [str], str, str)]:  # simulated
        """

        :param start_info:
        :return:
        """
        simulated = []
        visited = set( )

        dis = self.dis  # type: Disassembler

        def simulate_path( simulated_pc, prev_info: OpInfo ):

            # spidering can be stopped as soon as we arrive at something already spidered before
            while not simulated_pc in visited:
                visited.add( simulated_pc )

                # add instruction to returned list (regardless of mnemonic)
                # NOTE: we collect more info than necessary for simulating execution, needed for debugging
                instruction, length = dis.collect_op_info( simulated_pc )
                operand_length = length - 1
                mnemonic = instruction['mnemonic']
                bytes = instruction['bytes']
                operand = instruction['operand'] if 'operand' in instruction else ''
                operand_address = instruction['operand_address'] if 'operand_address' in instruction else None

                # not used in production, just for debugging purposes
                simulated.append( [simulated_pc, bytes, mnemonic, operand] )

                # do not continue if we encountered an unknown mnemonic
                # we have probably spidered into a data area
                # TODO: roll-back (but we could also let the end dangle in the wind)
                if mnemonic == '???':
                    break

                info = mm.post_op( simulated_pc, operand_length, 0, prev_info )
                assert info is not None

                if not info.is_leap( ):
                    # normal (non-leaping) instruction, added in post_op()
                    # continue w/ sequentially next
                    simulated_pc += length

                else:
                    if info.is_branch( ):
                        self.map.register_branch( info, operand_address, branched=None )
                        # first follow the branch as if it was taken...
                        simulate_path( operand_address, info )
                        # ... then continue after the branch instruction as if it was ignored
                        simulated_pc += length
                        self.map.register_branch( info, simulated_pc, branched=None )

                    elif info.opcode == RTS:
                        # mm.register_rts(info, leap_to_address=None, matched_jsr=None)
                        self.map.register_rts( info, leap_to_address=None, matched_jsr=None )
                        # that's it
                        # we cannot use an RTS here because we don't know the nature of the RTS
                        # might need to add register_rtsfake
                        break

                    elif info.opcode == JMP_indirect:
                        # TODO: fake register_jmp with 'None' address
                        break

                    elif info.opcode == JMP_absolute:
                        self.map.register_jmp( info, operand_address )
                        simulated_pc = operand_address
                        # might not follow the jump into known OpInfo territory

                    elif info.opcode == JSR:
                        self.map.register_jsr( info, operand_address )
                        # even if the JSR went to a stretch known to be compact, we don't know from which of the possibly
                        #   multiple RTS in the compact stretch we return
                        simulate_path( operand_address, info )
                        break

                # make sure all of the if/elif/else above break if they do not change (or advance) the virtual PC
                assert simulated_pc != info.address

                prev_info = info

                # no need to enter known territory
                if self.map.is_op( simulated_pc ):
                    # before we break we need to link the op in the known territory with the previous one (spidered)
                    next_info = self.map.get_info(simulated_pc)
                    self.map.post_op( simulated_pc, next_info.operand_length, 0, prev_info )
                    break

                # IMPORTANT: don't have anything after while b/o the body uses return to leave this function

        # always start from an instruction which was encountered on the real execution path
        # => you cannot use simulation on .byte blocks, although the simulated execution might enter or leap into one
        assert start_info is not None

        # only simulate once
        # TODO: multiple simulated executions possible for the same starting info?
        assert start_info.execution_count > 0

        # passed (existing) starting point of spidering didn't have to be sequentially executed
        # if it is, it will be linked as if we continued execution along the path we spider
        simulate_path( start_info.address, start_info.prev_sequential_info )

        return sorted( simulated, key=lambda instruction: instruction[0] )


    def add_simulated_execution_paths( self ):

        for info in self.map.infos:  # type: OpInfo
            if info is not None and info.is_branch( ) and info.branched in ['-', '+']:
                if info.address in [0x51b6]:
                    # 0x51b6: SEC/BCS
                    # TODO: have a central place to manage excemptions from connecting tiles to stretches
                    pass
                else:
                    self.simulate_execution( info )
                    # or w/ debugging:
                    # spidered = self.simulate_execution( info )
                    # for line in spidered:
                    #     [address, bytes, mnemonic, operand] = line
                    #     print( hexaddr( address ), hexbytes( bytes ), mnemonic, operand )
                    # print( )
