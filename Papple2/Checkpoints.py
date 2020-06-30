#!/usr/bin/env python3

from util import *
from Emulator import *


class RecordedKeys:
    def __init__( self ):
        self.keys = [
            (5026414, ' ', 'switch to choose controls'),
            (5347664, 0x1b, 'switch back to intro noise'),
            (5769011, 0x00, 'exit'),
        ]

    def press_keys( self, emulator ) -> (bool, bool):  # (active, execute)
        active = True
        execute = True

        (cycles, key, comment) = self.keys[0]
        if emulator.cpu.cycles < cycles:
            pass
        else:
            del self.keys[0]
            if key == 0x00:
                print( "signal break at breakpoint" )
                execute = False
            else:
                apple2key = Ascii2Apple2Ascii( key )
                emulator.apple2.softswitches.kbd = apple2key
                print( emulator.cpu.cycles, "pressed (recorded)", hexbyte( Apple2Ascii2Ascii( apple2key ) ), comment )
                emulator.display.save_hires_bytes( str( cycles ) + '.dat' )

        return active, execute


class PrintCharTester:
    def __init__( self ):
        self.mem09_1 = None

    def LDA_indirect( self, emulator ) -> (bool, bool):  # (active, execute)
        cpu = emulator.apple2.cpu  # type: CPU
        if cpu.PC == 0x5118:
            print( "yes_1" )
            self.mem09_1 = emulator.mem[0x09]
        if cpu.PC == 0x5126:
            print( "yes_2" )
            mem08_2 = emulator.mem[0x08]
            mem09_2 = emulator.mem[0x09]
            print( hexbyte( self.mem09_1 ), hexbyte( mem08_2 ), hexbyte( mem09_2 ) )
        if cpu.PC == 0x512e:
            return False, False
        return True, True


class RandomTesterCheckpoint:
    def __init__( self, emulator ):
        self.emulator = emulator
        self.cpu = self.emulator.cpu

    def checkpoint( self, emulator ) -> (bool, bool):
        if self.cpu.PC == 0x4c36:
            # in/out: 0x4e, 0x4f
            # in: 0xfc, 0x150a
            pass
        elif self.cpu.PC == 0x4c4a:
            print( ';'.join( [
                str( self.cpu.cycles ),
                hexbyte( self.emulator.mem[0x4e] ),
                hexbyte( self.emulator.mem[0x4f] ),
                hexbyte( self.emulator.mem[0xfc] ),
                hexbyte( self.emulator.mem[0x150a] ),
            ] ) )
            # self.emulator.mem[0x4e] = 1
            # self.emulator.mem[0x4f] = 1
            pass
        return True, True
