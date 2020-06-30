#!/usr/bin/env python3

# Papple is based on ApplePy, see LICNSE

# ApplePy - an Apple ][ emulator in Python
# James Tauber / http://jtauber.com/
# originally written 2001, updated 2011

import logging
import io
from pickle import *
from Memory import *
from enum import Enum
import sys


def signed( x ):
    if x > 0x7F:
        x -= 0x100
    return x


RTS = 0x60
JSR = 0x20
BPL = 0x10
BMI = 0x30
BVC = 0x50
BVS = 0x70
BCC = 0x90
BCS = 0xB0
BNE = 0xD0
BEQ = 0xF0
JMP_absolute = 0x4C
JMP_indirect = 0x6C


def verbose_branch( opcode ):
    if opcode == BPL:
        return 'BPL'
    elif opcode == BMI:
        return 'BMI'
    elif opcode == BVC:
        return 'BVC'
    elif opcode == BVS:
        return 'BVS'
    elif opcode == BCC:
        return 'BCC'
    elif opcode == BVS:
        return 'BCS'
    elif opcode == BNE:
        return 'BNE'
    elif opcode == BEQ:
        return 'BEQ'


class CPU:
    STACK_PAGE = 0x100
    RESET_VECTOR = 0xFFFC

    def __init__( self, memory, program_counter ):
        self.memory = memory

        self.A = 0x00
        self.X = 0x00
        self.Y = 0x00

        self.carry_flag = 0
        self.zero_flag = 0
        self.interrupt_disable_flag = 0
        self.decimal_mode_flag = 0
        self.break_flag = 1
        self.overflow_flag = 0
        self.sign_flag = 0

        self.SP = 0xFF

        # flags for last op
        self.branched = False
        self.operand_length = 0

        self.cycles = 0

        self.ops_dispatch = [None] * 0x100
        self.setup_ops_dispatch( )

        self.immediate = False
        self.last_opcode = None
        self.PC = program_counter
        self.last_PC = None

        self.write_hook = None
        self.read_hook = None
        self.op_hook = None


    def reset( self ):
        self.A = 0x00
        self.X = 0x00
        self.Y = 0x00
        self.carry_flag = 0
        self.zero_flag = 0
        self.interrupt_disable_flag = 0
        self.decimal_mode_flag = 0
        self.break_flag = 1
        self.overflow_flag = 0
        self.sign_flag = 0
        self.SP = 0xFF
        self.branched = False
        self.operand_length = 0
        self.cycles = 0
        self.last_opcode = None
        self.PC = self.read_word( self.RESET_VECTOR )
        self.last_PC = None

    def pickle( self, pickler: Pickler ):
        pickler.dump( self.A )
        pickler.dump( self.X )
        pickler.dump( self.Y )
        pickler.dump( self.status_as_byte( ) )
        pickler.dump( self.SP )
        pickler.dump( self.branched )
        pickler.dump( self.operand_length )
        pickler.dump( self.cycles )
        pickler.dump( self.last_opcode )
        pickler.dump( self.PC )
        pickler.dump( self.last_PC )

    def unpickle( self, unpickler: Unpickler ):
        self.A = unpickler.load( )
        self.X = unpickler.load( )
        self.Y = unpickler.load( )
        self.status_from_byte( unpickler.load( ) )
        self.SP = unpickler.load( )
        self.branched = unpickler.load( )
        self.operand_length = unpickler.load( )
        self.cycles = unpickler.load( )
        self.last_opcode = unpickler.load()
        self.PC = unpickler.load( )
        self.last_PC = unpickler.load( )

    def pickle_to_variable(self):
        f = io.BytesIO()
        pickler = Pickler(f)
        self.pickle(pickler)
        pickled_cpu = f.getvalue()
        return pickled_cpu

    def unpickle_from_variable(self, pickled_cpu):
        f = io.BytesIO(pickled_cpu)
        unpickler = Unpickler(f)
        self.unpickle(unpickler)

    def verbose_status(self):
        flags = [
            'C' if self.carry_flag else 'c',
            'Z' if self.zero_flag else 'z',
            'I' if self.interrupt_disable_flag else 'i',
            'D' if self.decimal_mode_flag else 'd',
            'B' if self.break_flag else 'b',
            'O' if self.overflow_flag else 'o',
            'S' if self.sign_flag else 's'
        ]
        return ''.join(flags)

    def __repr__(self):
        return "PC=%s A=%s X=%s Y=%s SP=%s F=%s" % (
            hexaddr(self.PC, show_dollar=False),
            hexbyte(self.A),
            hexbyte(self.X),
            hexbyte(self.Y),
            hexbyte(self.SP),
            self.verbose_status()
        )

    def setup_ops_dispatch( self ):
        self.ops_dispatch[BPL] = lambda: self.BPL( self.relative_mode( ) )
        self.ops_dispatch[BMI] = lambda: self.BMI( self.relative_mode( ) )
        self.ops_dispatch[BVC] = lambda: self.BVC( self.relative_mode( ) )
        self.ops_dispatch[BVS] = lambda: self.BVS( self.relative_mode( ) )
        self.ops_dispatch[BCC] = lambda: self.BCC( self.relative_mode( ) )
        self.ops_dispatch[BCS] = lambda: self.BCS( self.relative_mode( ) )
        self.ops_dispatch[BNE] = lambda: self.BNE( self.relative_mode( ) )
        self.ops_dispatch[BEQ] = lambda: self.BEQ( self.relative_mode( ) )

        self.ops_dispatch[JSR] = lambda: self.JSR( self.absolute_mode( ) )
        self.ops_dispatch[RTS] = lambda: self.RTS( )

        self.ops_dispatch[JMP_absolute] = lambda: self.JMP( self.absolute_mode( ) )
        self.ops_dispatch[JMP_indirect] = lambda: self.JMP( self.indirect_mode( ) )

        self.ops_dispatch[0x00] = lambda: self.BRK( )
        self.ops_dispatch[0x01] = lambda: self.ORA( self.indirect_x_mode( ) )
        self.ops_dispatch[0x05] = lambda: self.ORA( self.zero_page_mode( ) )
        self.ops_dispatch[0x06] = lambda: self.ASL( self.zero_page_mode( ) )
        self.ops_dispatch[0x08] = lambda: self.PHP( )
        self.ops_dispatch[0x09] = lambda: self.ORA( self.immediate_mode( ) )
        self.ops_dispatch[0x0A] = lambda: self.ASL( )
        self.ops_dispatch[0x0D] = lambda: self.ORA( self.absolute_mode( ) )
        self.ops_dispatch[0x0E] = lambda: self.ASL( self.absolute_mode( ) )
        self.ops_dispatch[0x11] = lambda: self.ORA( self.indirect_y_mode( ) )
        self.ops_dispatch[0x15] = lambda: self.ORA( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x16] = lambda: self.ASL( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x18] = lambda: self.CLC( )
        self.ops_dispatch[0x19] = lambda: self.ORA( self.absolute_y_mode( ) )
        self.ops_dispatch[0x1D] = lambda: self.ORA( self.absolute_x_mode( ) )
        self.ops_dispatch[0x1E] = lambda: self.ASL( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0x21] = lambda: self.AND( self.indirect_x_mode( ) )
        self.ops_dispatch[0x24] = lambda: self.BIT( self.zero_page_mode( ) )
        self.ops_dispatch[0x25] = lambda: self.AND( self.zero_page_mode( ) )
        self.ops_dispatch[0x26] = lambda: self.ROL( self.zero_page_mode( ) )
        self.ops_dispatch[0x28] = lambda: self.PLP( )
        self.ops_dispatch[0x29] = lambda: self.AND( self.immediate_mode( ) )
        self.ops_dispatch[0x2A] = lambda: self.ROL( )
        self.ops_dispatch[0x2C] = lambda: self.BIT( self.absolute_mode( ) )
        self.ops_dispatch[0x2D] = lambda: self.AND( self.absolute_mode( ) )
        self.ops_dispatch[0x2E] = lambda: self.ROL( self.absolute_mode( ) )
        self.ops_dispatch[0x31] = lambda: self.AND( self.indirect_y_mode( ) )
        self.ops_dispatch[0x35] = lambda: self.AND( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x36] = lambda: self.ROL( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x38] = lambda: self.SEC( )
        self.ops_dispatch[0x39] = lambda: self.AND( self.absolute_y_mode( ) )
        self.ops_dispatch[0x3D] = lambda: self.AND( self.absolute_x_mode( ) )
        self.ops_dispatch[0x3E] = lambda: self.ROL( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0x40] = lambda: self.RTI( )
        self.ops_dispatch[0x41] = lambda: self.EOR( self.indirect_x_mode( ) )
        self.ops_dispatch[0x45] = lambda: self.EOR( self.zero_page_mode( ) )
        self.ops_dispatch[0x46] = lambda: self.LSR( self.zero_page_mode( ) )
        self.ops_dispatch[0x48] = lambda: self.PHA( )
        self.ops_dispatch[0x49] = lambda: self.EOR( self.immediate_mode( ) )
        self.ops_dispatch[0x4A] = lambda: self.LSR( )
        self.ops_dispatch[0x4D] = lambda: self.EOR( self.absolute_mode( ) )
        self.ops_dispatch[0x4E] = lambda: self.LSR( self.absolute_mode( ) )
        self.ops_dispatch[0x51] = lambda: self.EOR( self.indirect_y_mode( ) )
        self.ops_dispatch[0x55] = lambda: self.EOR( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x56] = lambda: self.LSR( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x58] = lambda: self.CLI( )
        self.ops_dispatch[0x59] = lambda: self.EOR( self.absolute_y_mode( ) )
        self.ops_dispatch[0x5D] = lambda: self.EOR( self.absolute_x_mode( ) )
        self.ops_dispatch[0x5E] = lambda: self.LSR( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0x61] = lambda: self.ADC( self.indirect_x_mode( ) )
        self.ops_dispatch[0x65] = lambda: self.ADC( self.zero_page_mode( ) )
        self.ops_dispatch[0x66] = lambda: self.ROR( self.zero_page_mode( ) )
        self.ops_dispatch[0x68] = lambda: self.PLA( )
        self.ops_dispatch[0x69] = lambda: self.ADC( self.immediate_mode( ) )
        self.ops_dispatch[0x6A] = lambda: self.ROR( )
        self.ops_dispatch[0x6D] = lambda: self.ADC( self.absolute_mode( ) )
        self.ops_dispatch[0x6E] = lambda: self.ROR( self.absolute_mode( ) )
        self.ops_dispatch[0x71] = lambda: self.ADC( self.indirect_y_mode( ) )
        self.ops_dispatch[0x75] = lambda: self.ADC( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x76] = lambda: self.ROR( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x78] = lambda: self.SEI( )
        self.ops_dispatch[0x79] = lambda: self.ADC( self.absolute_y_mode( ) )
        self.ops_dispatch[0x7D] = lambda: self.ADC( self.absolute_x_mode( ) )
        self.ops_dispatch[0x7E] = lambda: self.ROR( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0x81] = lambda: self.STA( self.indirect_x_mode( ) )
        self.ops_dispatch[0x84] = lambda: self.STY( self.zero_page_mode( ) )
        self.ops_dispatch[0x85] = lambda: self.STA( self.zero_page_mode( ) )
        self.ops_dispatch[0x86] = lambda: self.STX( self.zero_page_mode( ) )
        self.ops_dispatch[0x88] = lambda: self.DEY( )
        self.ops_dispatch[0x8A] = lambda: self.TXA( )
        self.ops_dispatch[0x8C] = lambda: self.STY( self.absolute_mode( ) )
        self.ops_dispatch[0x8D] = lambda: self.STA( self.absolute_mode( ) )
        self.ops_dispatch[0x8E] = lambda: self.STX( self.absolute_mode( ) )
        self.ops_dispatch[0x91] = lambda: self.STA( self.indirect_y_mode( rmw=True ) )
        self.ops_dispatch[0x94] = lambda: self.STY( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x95] = lambda: self.STA( self.zero_page_x_mode( ) )
        self.ops_dispatch[0x96] = lambda: self.STX( self.zero_page_y_mode( ) )
        self.ops_dispatch[0x98] = lambda: self.TYA( )
        self.ops_dispatch[0x99] = lambda: self.STA( self.absolute_y_mode( rmw=True ) )
        self.ops_dispatch[0x9A] = lambda: self.TXS( )
        self.ops_dispatch[0x9D] = lambda: self.STA( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0xA0] = lambda: self.LDY( self.immediate_mode( ) )
        self.ops_dispatch[0xA1] = lambda: self.LDA( self.indirect_x_mode( ) )
        self.ops_dispatch[0xA2] = lambda: self.LDX( self.immediate_mode( ) )
        self.ops_dispatch[0xA4] = lambda: self.LDY( self.zero_page_mode( ) )
        self.ops_dispatch[0xA5] = lambda: self.LDA( self.zero_page_mode( ) )
        self.ops_dispatch[0xA6] = lambda: self.LDX( self.zero_page_mode( ) )
        self.ops_dispatch[0xA8] = lambda: self.TAY( )
        self.ops_dispatch[0xA9] = lambda: self.LDA( self.immediate_mode( ) )
        self.ops_dispatch[0xAA] = lambda: self.TAX( )
        self.ops_dispatch[0xAC] = lambda: self.LDY( self.absolute_mode( ) )
        self.ops_dispatch[0xAD] = lambda: self.LDA( self.absolute_mode( ) )
        self.ops_dispatch[0xAE] = lambda: self.LDX( self.absolute_mode( ) )
        self.ops_dispatch[0xB1] = lambda: self.LDA( self.indirect_y_mode( ) )
        self.ops_dispatch[0xB4] = lambda: self.LDY( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xB5] = lambda: self.LDA( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xB6] = lambda: self.LDX( self.zero_page_y_mode( ) )
        self.ops_dispatch[0xB8] = lambda: self.CLV( )
        self.ops_dispatch[0xB9] = lambda: self.LDA( self.absolute_y_mode( ) )
        self.ops_dispatch[0xBA] = lambda: self.TSX( )
        self.ops_dispatch[0xBC] = lambda: self.LDY( self.absolute_x_mode( ) )
        self.ops_dispatch[0xBD] = lambda: self.LDA( self.absolute_x_mode( ) )
        self.ops_dispatch[0xBE] = lambda: self.LDX( self.absolute_y_mode( ) )
        self.ops_dispatch[0xC0] = lambda: self.CPY( self.immediate_mode( ) )
        self.ops_dispatch[0xC1] = lambda: self.CMP( self.indirect_x_mode( ) )
        self.ops_dispatch[0xC4] = lambda: self.CPY( self.zero_page_mode( ) )
        self.ops_dispatch[0xC5] = lambda: self.CMP( self.zero_page_mode( ) )
        self.ops_dispatch[0xC6] = lambda: self.DEC( self.zero_page_mode( ) )
        self.ops_dispatch[0xC8] = lambda: self.INY( )
        self.ops_dispatch[0xC9] = lambda: self.CMP( self.immediate_mode( ) )
        self.ops_dispatch[0xCA] = lambda: self.DEX( )
        self.ops_dispatch[0xCC] = lambda: self.CPY( self.absolute_mode( ) )
        self.ops_dispatch[0xCD] = lambda: self.CMP( self.absolute_mode( ) )
        self.ops_dispatch[0xCE] = lambda: self.DEC( self.absolute_mode( ) )
        self.ops_dispatch[0xD1] = lambda: self.CMP( self.indirect_y_mode( ) )
        self.ops_dispatch[0xD5] = lambda: self.CMP( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xD6] = lambda: self.DEC( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xD8] = lambda: self.CLD( )
        self.ops_dispatch[0xD9] = lambda: self.CMP( self.absolute_y_mode( ) )
        self.ops_dispatch[0xDD] = lambda: self.CMP( self.absolute_x_mode( ) )
        self.ops_dispatch[0xDE] = lambda: self.DEC( self.absolute_x_mode( rmw=True ) )
        self.ops_dispatch[0xE0] = lambda: self.CPX( self.immediate_mode( ) )
        self.ops_dispatch[0xE1] = lambda: self.SBC( self.indirect_x_mode( ) )
        self.ops_dispatch[0xE4] = lambda: self.CPX( self.zero_page_mode( ) )
        self.ops_dispatch[0xE5] = lambda: self.SBC( self.zero_page_mode( ) )
        self.ops_dispatch[0xE6] = lambda: self.INC( self.zero_page_mode( ) )
        self.ops_dispatch[0xE8] = lambda: self.INX( )
        self.ops_dispatch[0xE9] = lambda: self.SBC( self.immediate_mode( ) )
        self.ops_dispatch[0xEA] = lambda: self.NOP( )
        self.ops_dispatch[0xEC] = lambda: self.CPX( self.absolute_mode( ) )
        self.ops_dispatch[0xED] = lambda: self.SBC( self.absolute_mode( ) )
        self.ops_dispatch[0xEE] = lambda: self.INC( self.absolute_mode( ) )
        self.ops_dispatch[0xF1] = lambda: self.SBC( self.indirect_y_mode( ) )
        self.ops_dispatch[0xF5] = lambda: self.SBC( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xF6] = lambda: self.INC( self.zero_page_x_mode( ) )
        self.ops_dispatch[0xF8] = lambda: self.SED( )
        self.ops_dispatch[0xF9] = lambda: self.SBC( self.absolute_y_mode( ) )
        self.ops_dispatch[0xFD] = lambda: self.SBC( self.absolute_x_mode( ) )
        self.ops_dispatch[0xFE] = lambda: self.INC( self.absolute_x_mode( rmw=True ) )


    def do_next_step( self ):
        if self.op_hook and self.op_hook(self):
            return

        # all instructions take 2 cycles as a minimum
        self.cycles += 2

        # reset flags from last op
        self.immediate = False
        self.branched = False
        self.operand_length = 0

        # save pc for this op
        self.last_PC = self.PC

        # read op from pc and advance pc
        self.last_opcode = self.read_pc_byte( )

        # find lambda for op and run it
        op_func = self.ops_dispatch[self.last_opcode]
        if op_func is None:
            logging.error( "unknown op %s at pc=%s", hex( self.last_opcode ), hexaddr( self.PC - 1 ) )
            assert False

        # https://stackoverflow.com/questions/24902258/pycharm-warning-about-not-callable
        assert callable( op_func )
        op_func( )

    # read/write

    def get_and_inc_pc( self, inc=1 ):
        # ((ESHGNSG)) pc is on opcode
        pc = self.PC
        self.PC += inc
        return pc

    def read_byte( self, address, hook=True ):
        value = self.memory.read_byte( address )
        if not self.immediate and hook and self.read_hook:
            self.read_hook(address, value)
        return value

    def read_word( self, address, hook=True ):
        value = self.memory.read_word( address )
        if hook and self.read_hook:
            self.read_hook(address, value)
        return value

    def read_word_bug( self, address ):
        value = self.memory.read_word_bug( address )
        if self.read_hook:
            self.read_hook(address, value)
        return value

    def read_pc_byte( self ):
        return self.read_byte( self.get_and_inc_pc( ), hook=False )

    def read_pc_word( self ):
        return self.read_word( self.get_and_inc_pc( 2 ), hook=False )

    def write_byte( self, address, value ):
        if 0x8600 <= address <= 0x8fff:
            print(hexaddr(self.PC))
            sys.exit(0)
        if self.write_hook:
            if self.write_hook(address, value):
                self.memory.write_byte( address, value )
        else:
            self.memory.write_byte( address, value )

    ####

    def status_from_byte( self, status ):
        self.carry_flag = [0, 1][0 != status & 1]
        self.zero_flag = [0, 1][0 != status & 2]
        self.interrupt_disable_flag = [0, 1][0 != status & 4]
        self.decimal_mode_flag = [0, 1][0 != status & 8]
        self.break_flag = [0, 1][0 != status & 16]
        self.overflow_flag = [0, 1][0 != status & 64]
        self.sign_flag = [0, 1][0 != status & 128]

    def status_as_byte( self ):
        return self.carry_flag | self.zero_flag << 1 | self.interrupt_disable_flag << 2 | self.decimal_mode_flag << 3 | self.break_flag << 4 | 1 << 5 | self.overflow_flag << 6 | self.sign_flag << 7

    ####

    def push_byte( self, byte ):
        self.write_byte( self.STACK_PAGE + self.SP, byte )
        self.SP = (self.SP - 1) % 0x100

    def pull_byte( self ):
        self.SP = (self.SP + 1) % 0x100
        return self.read_byte( self.STACK_PAGE + self.SP )

    def push_word( self, word ):
        hi, lo = divmod( word, 0x100 )
        self.push_byte( hi )
        self.push_byte( lo )

    def pull_word( self ):
        s = self.STACK_PAGE + self.SP + 1
        self.SP += 2
        return self.read_word( s )

    ####

    def immediate_mode( self ):
        self.operand_length = 1
        self.immediate = True
        return self.get_and_inc_pc( )

    def absolute_mode( self ):
        self.operand_length = 2
        self.cycles += 2
        return self.read_pc_word( )

    def absolute_x_mode( self, rmw=False ):
        self.operand_length = 2
        if rmw:
            self.cycles += 1
        return self.absolute_mode( ) + self.X

    def absolute_y_mode( self, rmw=False ):
        self.operand_length = 2
        if rmw:
            self.cycles += 1
        return self.absolute_mode( ) + self.Y

    def zero_page_mode( self ):
        self.operand_length = 1
        self.cycles += 1
        return self.read_pc_byte( )

    def zero_page_x_mode( self ):
        self.operand_length = 1
        self.cycles += 1
        return (self.zero_page_mode( ) + self.X) % 0x100

    def zero_page_y_mode( self ):
        self.operand_length = 1
        self.cycles += 1
        return (self.zero_page_mode( ) + self.Y) % 0x100

    def indirect_mode( self ):
        self.operand_length = 2
        self.cycles += 2
        return self.read_word_bug( self.absolute_mode( ) )

    def indirect_x_mode( self ):
        self.operand_length = 1
        self.cycles += 4
        return self.read_word_bug( (self.read_pc_byte( ) + self.X) % 0x100 )

    def indirect_y_mode( self, rmw=False ):
        self.operand_length = 1
        if rmw:
            self.cycles += 4
        else:
            self.cycles += 3
        return self.read_word_bug( self.read_pc_byte( ) ) + self.Y

    def relative_mode( self ):
        self.operand_length = 1
        pc = self.get_and_inc_pc( )
        return pc + 1 + signed( self.read_byte( pc, hook=False ) )

    ####

    def update_nz( self, value ):
        value = value % 0x100
        self.zero_flag = [0, 1][(value == 0)]
        self.sign_flag = [0, 1][((value & 0x80) != 0)]
        return value

    def update_nzc( self, value ):
        self.carry_flag = [0, 1][(value > 0xFF)]
        return self.update_nz( value )

    ####

    # LOAD / STORE

    def LDA( self, operand_address ):
        self.A = self.update_nz( self.read_byte( operand_address ) )

    def LDX( self, operand_address ):
        self.X = self.update_nz( self.read_byte( operand_address ) )

    def LDY( self, operand_address ):
        self.Y = self.update_nz( self.read_byte( operand_address ) )

    def STA( self, operand_address ):
        self.write_byte( operand_address, self.A )

    def STX( self, operand_address ):
        self.write_byte( operand_address, self.X )

    def STY( self, operand_address ):
        self.write_byte( operand_address, self.Y )

    # TRANSFER

    def TAX( self ):
        self.X = self.update_nz( self.A )

    def TXA( self ):
        self.A = self.update_nz( self.X )

    def TAY( self ):
        self.Y = self.update_nz( self.A )

    def TYA( self ):
        self.A = self.update_nz( self.Y )

    def TSX( self ):
        self.X = self.update_nz( self.SP )

    def TXS( self ):
        self.SP = self.X

    # SHIFTS / ROTATES

    def ASL( self, operand_address=None ):
        if operand_address is None:
            self.A = self.update_nzc( self.A << 1 )
        else:
            self.cycles += 2
            self.write_byte( operand_address, self.update_nzc( self.read_byte( operand_address ) << 1 ) )

    def ROL( self, operand_address=None ):
        if operand_address is None:
            a = self.A << 1
            if self.carry_flag:
                a = a | 0x01
            self.A = self.update_nzc( a )
        else:
            self.cycles += 2
            m = self.read_byte( operand_address ) << 1
            if self.carry_flag:
                m = m | 0x01
            self.write_byte( operand_address, self.update_nzc( m ) )

    def ROR( self, operand_address=None ):
        if operand_address is None:
            if self.carry_flag:
                self.A = self.A | 0x100
            self.carry_flag = self.A % 2
            self.A = self.update_nz( self.A >> 1 )
        else:
            self.cycles += 2
            m = self.read_byte( operand_address )
            if self.carry_flag:
                m = m | 0x100
            self.carry_flag = m % 2
            self.write_byte( operand_address, self.update_nz( m >> 1 ) )

    def LSR( self, operand_address=None ):
        if operand_address is None:
            self.carry_flag = self.A % 2
            self.A = self.update_nz( self.A >> 1 )
        else:
            self.cycles += 2
            self.carry_flag = self.read_byte( operand_address ) % 2
            self.write_byte( operand_address, self.update_nz( self.read_byte( operand_address ) >> 1 ) )

    # JUMPS / RETURNS

    def JMP( self, operand_address ):
        self.cycles -= 1
        self.PC = operand_address

    def JSR( self, operand_address ):
        self.cycles += 2
        self.push_word( self.PC - 1 )
        self.PC = operand_address

    def RTS( self ):
        self.cycles += 4
        target_pc = self.pull_word( ) + 1
        self.PC = target_pc

    # BRANCHES

    def handle_branching( self, operand_address, must_branch ):
        # that's how "branching" is defined...
        # BUT: we cannot test this here, because the nosetests call the Bxx method directly, w/o running actual code
        # assert self.current_opcode in [BCC, BCS, BEQ, BNE, BMI, BPL, BVC, BVS]

        # we might not actually branch at all in this op
        if must_branch:
            self.cycles += 1
            self.PC = operand_address

        self.branched = must_branch

    def BCC( self, operand_address ):
        self.handle_branching( operand_address, not self.carry_flag )

    def BCS( self, operand_address ):
        self.handle_branching( operand_address, self.carry_flag )

    def BEQ( self, operand_address ):
        self.handle_branching( operand_address, self.zero_flag )

    def BNE( self, operand_address ):
        self.handle_branching( operand_address, not self.zero_flag )

    def BMI( self, operand_address ):
        self.handle_branching( operand_address, self.sign_flag )

    def BPL( self, operand_address ):
        self.handle_branching( operand_address, not self.sign_flag )

    def BVC( self, operand_address ):
        self.handle_branching( operand_address, not self.overflow_flag )

    def BVS( self, operand_address ):
        self.handle_branching( operand_address, self.overflow_flag )

    # SET / CLEAR FLAGS

    def CLC( self ):
        self.carry_flag = 0

    def CLD( self ):
        self.decimal_mode_flag = 0

    def CLI( self ):
        self.interrupt_disable_flag = 0

    def CLV( self ):
        self.overflow_flag = 0

    def SEC( self ):
        self.carry_flag = 1

    def SED( self ):
        self.decimal_mode_flag = 1

    def SEI( self ):
        self.interrupt_disable_flag = 1

    # INCREMENT / DECREMENT

    def DEC( self, operand_address ):
        self.cycles += 2
        self.write_byte( operand_address, self.update_nz( self.read_byte( operand_address ) - 1 ) )

    def DEX( self ):
        self.X = self.update_nz( self.X - 1 )

    def DEY( self ):
        self.Y = self.update_nz( self.Y - 1 )

    def INC( self, operand_address ):
        self.cycles += 2
        self.write_byte( operand_address, self.update_nz( self.read_byte( operand_address ) + 1 ) )

    def INX( self ):
        self.X = self.update_nz( self.X + 1 )

    def INY( self ):
        self.Y = self.update_nz( self.Y + 1 )

    # PUSH / PULL

    def PHA( self ):
        self.cycles += 1
        self.push_byte( self.A )

    def PHP( self ):
        self.cycles += 1
        self.push_byte( self.status_as_byte( ) )

    def PLA( self ):
        self.cycles += 2
        self.A = self.update_nz( self.pull_byte( ) )

    def PLP( self ):
        self.cycles += 2
        self.status_from_byte( self.pull_byte( ) )

    # LOGIC

    def AND( self, operand_address ):
        self.A = self.update_nz( self.A & self.read_byte( operand_address ) )

    def ORA( self, operand_address ):
        self.A = self.update_nz( self.A | self.read_byte( operand_address ) )

    def EOR( self, operand_address ):
        self.A = self.update_nz( self.A ^ self.read_byte( operand_address ) )

    # ARITHMETIC

    def ADC( self, operand_address ):
        # @@@ doesn't handle BCD yet
        assert not self.decimal_mode_flag

        a2 = self.A
        a1 = signed( a2 )
        m2 = self.read_byte( operand_address )
        m1 = signed( m2 )

        # twos complement addition
        result1 = a1 + m1 + self.carry_flag

        # unsigned addition
        result2 = a2 + m2 + self.carry_flag

        self.A = self.update_nzc( result2 )

        # perhaps this could be calculated from result2 but result1 is more intuitive
        self.overflow_flag = [0, 1][(result1 > 127) | (result1 < -128)]

    def SBC( self, operand_address ):
        # @@@ doesn't handle BCD yet
        assert not self.decimal_mode_flag

        a2 = self.A
        a1 = signed( a2 )
        m2 = self.read_byte( operand_address )
        m1 = signed( m2 )

        # twos complement subtraction
        result1 = a1 - m1 - [1, 0][self.carry_flag]

        # unsigned subtraction
        result2 = a2 - m2 - [1, 0][self.carry_flag]

        self.A = self.update_nz( result2 )
        self.carry_flag = [0, 1][(result2 >= 0)]

        # perhaps this could be calculated from result2 but result1 is more intuitive
        self.overflow_flag = [0, 1][(result1 > 127) | (result1 < -128)]

    # BIT

    def BIT( self, operand_address ):
        value = self.read_byte( operand_address )
        self.sign_flag = ((value >> 7) % 2)  # bit 7
        self.overflow_flag = ((value >> 6) % 2)  # bit 6
        self.zero_flag = [0, 1][((self.A & value) == 0)]

    # COMPARISON

    def CMP( self, operand_address ):
        result = self.A - self.read_byte( operand_address )
        self.carry_flag = [0, 1][(result >= 0)]
        self.update_nz( result )

    def CPX( self, operand_address ):
        result = self.X - self.read_byte( operand_address )
        self.carry_flag = [0, 1][(result >= 0)]
        self.update_nz( result )

    def CPY( self, operand_address ):
        result = self.Y - self.read_byte( operand_address )
        self.carry_flag = [0, 1][(result >= 0)]
        self.update_nz( result )

    # SYSTEM

    def NOP( self ):
        pass

    def BRK( self ):
        self.cycles += 5
        self.push_word( self.PC + 1 )
        self.push_byte( self.status_as_byte( ) )
        self.PC = self.read_word( 0xFFFE )
        self.break_flag = 1

    def RTI( self ):
        self.cycles += 4
        self.status_from_byte( self.pull_byte( ) )
        self.PC = self.pull_word( )

        # @@@ IRQ
        # @@@ NMI
