#!/usr/bin/env python3

# http://rogerdudler.github.io/git-guide/

# snippets
# http://www.obelisk.me.uk/6502/maclib.inc

# http://wilsonminesco.com/StructureMacros/
# http://wilsonminesco.com/6502primer/PgmWrite.html
# http://wilsonminesco.com/6502primer/PgmTips.html
# http://wilsonminesco.com/stacks/index.html

# https://www.lysator.liu.se/~nisse/misc/6502-mul.html
# http://nparker.llx.com/a2/mult.html

# https://news.ycombinator.com/item?id=11661313
# http://www.capstone-engine.org/documentation.html
# https://bitbucket.org/mihaila/bindead/wiki/Home
# https://www.hopperapp.com
# https://www.hex-rays.com/products/ida/

import time
from Apple import *
from MemoryMap import *
from Hooks import *
from Checkpoints import *
import io
import pygame
import sys
from pysm import State, StateMachine, Event

class EmulatorExecutingState( StateMachine ):
    def __init__(self, emulator_states):
        super().__init__('Executing')
        self.emulator_states = emulator_states  # type: EmulatorStates
        self.emulator = self.emulator_states.emulator
        self.apple2 = self.emulator.apple2
        self.cpu = self.emulator.cpu
        self.display = self.emulator.display

    def register_handlers(self):
        self.handlers = {
            'enter': self.on_enter,
            'exit': self.on_exit,
            'breakpoint': self.on_breakpoint,
            'key': self.on_key,
        }

    def on_enter(self, state, event):
        self.emulator.executing = True

    def on_exit(self, state, event):
        self.emulator.executing = False

    def on_breakpoint( self, state, event ):
        self.display.show_status("execution stopped (breakpoint), %s" % str(self.cpu))

    def action(self, state, event):
        print("action!!!! we are in state '%s', handling event '%s'" % (state.name, event.name))

    def on_key(self, state, event):
        # high bit always set
        key = event.cargo['key']
        apple2key = Ascii2Apple2Ascii(key)
        self.apple2.softswitches.kbd = Ascii2Apple2Ascii(apple2key)
        print(self.cpu.cycles, "pressed (pygame)", hexbyte(Apple2Ascii2Ascii(apple2key)))


class EmulatorNotExecutingState( StateMachine ):
    def __init__(self, emulator_states):
        super().__init__('NotExecuting')
        self.emulator_states = emulator_states  # type: EmulatorStates
        self.emulator = self.emulator_states.emulator
        self.display = self.emulator_states.display
        self.cpu = self.emulator_states.cpu
        self.mem = self.emulator_states.mem

    def register_handlers(self):
        self.handlers = {
            'enter': self.on_enter,
            'exit': self.on_exit,
            'left': self.on_left,
            'right': self.on_right,
            'd': self.on_d,
            'l': self.on_l,
        }

    def on_enter(self, state, event):
        # formerly known as suspend_execution()
        self.emulator.executing = False
        print("on_exit")
        self.display.show_status("execution stopped, %s" % str(self.cpu))
        self.emulator.time_machine.enable_restoring( )

    def on_exit(self, state, event):
        # formerly known as resume_execution()
        self.emulator.executing = True
        print("on_enter")
        self.emulator.time_machine.disable_restoring( )
        self.display.show_status("execution resumed, %s" % str(self.cpu))

    def on_left(self, state, event):
        kbd_states = determine_states_from_kmods()
        print("restore")
        self.emulator.time_machine.restore_prev_state(kbd_states)

    def on_right(self, state, event):
        kdb_states = determine_states_from_kmods()
        self.emulator.time_machine.restore_next_state(kdb_states)

    def on_d(self, state, event):
        self.display.show_status(str(self.cpu))

    def on_l(self, state, event):
        print("$00=%s" % hexbyte(self.mem[0x00]))
        print("$01=%s" % hexbyte(self.mem[0x01]))
        print("$02=%s" % hexbyte(self.mem[0x02]))
        print("$03=%s" % hexbyte(self.mem[0x03]))
        print("$04=%s" % hexbyte(self.mem[0x04]))
        print("$05=%s" % hexbyte(self.mem[0x05]))
        print("$150a=%s" % hexbyte(self.mem[0x150a]))
        print("$150b=%s" % hexbyte(self.mem[0x150b]))
        print("$150c=%s" % hexbyte(self.mem[0x150c]))
        print("$1407=%s" % hexbyte(self.mem[0x1407]))


class EmulatorStates(StateMachine):

    def __init__(self, emulator):
        super().__init__('emulator')
        self.emulator = emulator
        self.apple2 = self.emulator.apple2
        self.display = self.apple2.display
        self.screen = self.display.screen
        self.cpu = self.apple2.cpu  # type: CPU
        self.mem = self.apple2.memory._mem   # type: [int]
        self.map = self.emulator.map

        executing = EmulatorExecutingState(self)
        not_executing = EmulatorNotExecutingState(self)

        self.add_state(executing, initial=True)
        self.add_state(not_executing)

        halt = State('halt')
        self.add_state(halt)

        self.add_transition(executing, not_executing, events=['ctrlx'])
        self.add_transition(not_executing, executing, events=['ctrlx'])
        self.add_transition(executing, not_executing, events=['breakpoint'])

        # TODO: EmulatorStates sollte selbst keine StateMachine mehr sein, sondern eine enthalten
        self.add_transition(executing, halt, events=['halt'])
        self.add_transition(not_executing, halt, events=['halt'])

        self.initialize()


    def register_handlers(self):
        self.handlers = {
            'stop': self.on_stop,
        }

    def on_stop(self, state, event):
        pass


class Emulator:

    def __init__(self, no_display=False, quiet=True, frame_rate=20, time_machine=False, mem_access=False):
        self.apple2 = Apple2( no_display, quiet, frame_rate )  # type: Apple2
        self.display = self.apple2.display
        self.screen = self.display.screen
        self.cpu = self.apple2.cpu  # type: CPU
        self.mem = self.apple2.memory._mem   # type: [int]
        self.map = MemoryMap( self.cpu.memory )  # type: MemoryMap

        self.states = EmulatorStates( self )

        # Emulator is not stateless => Timemachine would need to save these
        # TODO: disallow tiling and further analysis w/ the memory map if we have used the TimeMachine
        self.jsr_stack = []
        self.prev_info = None

        self.elapsed_frame = 1 / int(frame_rate) * 1000
        self.last_ticks = pygame.time.get_ticks()

        self.checkpoints = []
        # self.add_checkpoint( RandomTesterCheckpoint(self).checkpoint)
        # self.add_checkpoint( RecordedKeys( ).press_keys )
        # self.add_checkpoint( PrintCharTester( ).LDA_indirect )

        # self.cpu.write_hook = self.write_hook
        self.write_hook_enabled = False

        # TODO: time machine cannot work together w/ tiling (not reliably at least)
        self.time_machine = TimeMachine(self)
        if time_machine:
            self.time_machine.enable_write_hook( )

        self.mem_access = MemAccessCollector(self)
        if mem_access:
            self.mem_access.enable_hooks()

        self.executing = False
        self.instructions = 0
        self.stepsize = 10000

        # TODO: change logic of no_display (to show_window)
        self.show_window = not no_display


    def pickle(self, pickler):
        # pickle apple2, including all parts of Apple2 (e.g. Memory, CPU)
        self.apple2.pickle( pickler )

        # MemoryMap is the static execution trace capture, not part of the Apple2
        self.map.pickle( pickler )

        pickler.dump(self.elapsed_frame)
        pickler.dump(self.last_ticks)
        pickler.dump(self.jsr_stack)
        pickler.dump(self.prev_info)

    def unpickle(self, unpickler):
        self.apple2.unpickle( unpickler )
        self.map.unpickle( unpickler )
        self.elapsed_frame = unpickler.load()
        self.last_ticks = unpickler.load()
        self.jsr_stack = unpickler.load()
        self.prev_info = unpickler.load()

    """
    BIN loading
    """

    def load_image(self, start_address: int, fn: str):
        self.apple2.memory.load_image(start_address, fn)
        if self.apple2.cpu.PC is None:
            self.apple2.cpu.PC = start_address

        # TODO: add exceptions from connecting tiles to stretches in Emulator.load_image(), i.e. before entering the event_loop

        if False:
            self.mem[0x4572] = ord( 'F' )
            self.mem[0x4573] = ord( 'R' )
            self.mem[0x4574] = ord( 'A' )
            self.mem[0x4575] = ord( 'N' )
            self.mem[0x4576] = ord( 'K' )

    """
    event loop
    """

    def write_hook(self, address, newvalue):
        if not self.write_hook_enabled: return True
        #if address != 0x1407: return True
        #print("PC=%s" % hexaddr(self.cpu.PC))
        #return False
        return True


    def add_checkpoint( self, func ):
        active = True
        self.checkpoints.append( (active, func) )


    def update_display(self):
        elapsed_time = pygame.time.get_ticks() - self.last_ticks
        if elapsed_time > self.elapsed_frame:
            if self.show_window:
                self.apple2.display.flash( )
                pygame.display.flip()
            # if self.speaker:
            #    self.speaker.update(cycle)  # wo kommt das cycle her? check ApplePy
            self.last_ticks = pygame.time.get_ticks( )


    def is_executing(self):
        return self.states.leaf_state.name == 'Executing'


    def event_loop(self):

        self.instructions = 0
        self.stepsize = 10000
        self.executing = True

        # exit event loop via setting exit_while, to do cleanup afterwards
        exit_while = False
        while not exit_while:

            if self.is_executing():
                for index, (active, func) in enumerate(self.checkpoints):
                    if active:
                        (continue_active, execute) = func(self)
                        if not execute:
                            print("break from breakpoint")
                            return
                        else:
                            if not continue_active:
                                self.checkpoints[index] = False, func

                # IMPORTANT: we first execute the current opcode (i.e. where pc points to)...
                self.cpu.do_next_step()
                self.post_op()

                self.instructions += 1

                # breakpoint events
                if False:
                    if self.cpu.PC in [0x4ec4, 0x4f65, 0x4f68]:
                        self.states.dispatch(Event('breakpoint'))

                # do things at certain PCs
                if False:
                    if self.cpu.PC == 0x4066:
                        self.mem[0x1407] = 20

            # empty pygame event queue
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return

                if event.type == pygame.KEYDOWN:
                    key = ord(event.unicode.upper()) if event.unicode != '' else 0

                    if event.key == pygame.K_x and (pygame.key.get_mods() & pygame.KMOD_CTRL):
                        self.states.dispatch(Event('ctrlx'))
                        continue

                    elif event.key == pygame.K_LEFT:  # A2 0x08
                        self.states.dispatch(Event('left'))
                        continue

                    elif event.key == pygame.K_RIGHT:  # A2 0x15
                        self.states.dispatch(Event('right'))
                        continue

                    elif event.key == pygame.K_PRINT:
                        self.states.dispatch(Event('halt'))
                        exit_while = True
                        break

                    elif event.key == pygame.K_d:
                        self.states.dispatch(Event('d'))
                        continue

                    elif event.key == pygame.K_l:
                        self.states.dispatch(Event('l'))
                        continue

                    if key != 0:
                        self.states.dispatch(Event('key', key=key ))
                        continue

            # after we've emptied the event queue we can update the screen
            self.update_display()

        # do some cleanup here
        print(self.states.leaf_state.name)


    def post_op(self):
        # ASSUMPTION: we are emulating on the execution path, i.e. there CPU is running
        op_address = self.cpu.last_PC
        operand_length = self.cpu.operand_length
        cycles = self.cpu.cycles
        info = self.map.post_op( op_address, operand_length, cycles, self.prev_info )

        # execution_count can be increased because we are executing (see comment above)
        if info.execution_count is None:
            info.execution_count = 1
        else:
            info.execution_count += 1

        opcode = info.opcode
        if opcode == JMP_indirect:
            print("yes", hexaddr(op_address))
        if info.is_leap():
            if info.is_branch():
                self.handle_branching(info)
            elif opcode == RTS:
                self.handle_rts(info)
            elif opcode == JSR:
                self.handle_jsr(info)
            elif opcode == JMP_absolute or opcode == JMP_indirect:
                self.handle_jmp(info)

        # save info about which path we have taken
        # currently only the last op, but could be reasonably expanded to trap e.g. SEC/BCS
        # TODO: maybe store prev_info in timemachine state, so that we can do tiling even if using the timemachine
        self.prev_info = info

        if self.time_machine:
            self.time_machine.post_op()

        if self.mem_access:
            self.mem_access.post_op()

        return info


    """
    register leaps with MemoryMap
    """

    def handle_branching(self, leap_from_info):
        branched = self.cpu.branched
        self.map.register_branch( leap_from_info, self.cpu.PC, branched )

    def handle_jmp(self, leap_from_info):
        # TODO: add indirect JMP
        assert self.cpu.last_opcode != JMP_indirect
        self.map.register_jmp( leap_from_info, self.cpu.PC )

    def handle_jsr(self, leap_from_info):
        self.jsr_stack.append( self.cpu.last_PC )
        self.map.register_jsr( leap_from_info, self.cpu.PC )

    def handle_rts(self, leap_from_info):
        pc = self.cpu.PC
        assumed_jsr = pc - 3

        # we need an address on the stack
        # no address would happen if we had an RTS w/o having a pending JSR on the stack
        # this is possible but not happening in Robotron - possible but not happening in Robotron
        assert len(self.jsr_stack) > 0

        jsr_on_stack = self.jsr_stack[-1]
        if assumed_jsr == jsr_on_stack:
            # normal case: return to calling JSR (i.e. op after it)
            matched_jsr = jsr_on_stack
            self.jsr_stack.pop()
        else:
            matched_jsr = None
        self.map.register_rts( leap_from_info, self.cpu.PC, matched_jsr )  # caller can be None

