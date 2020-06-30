#!/usr/bin/env python3

import re
from CPU import *
from MemoryMap import *
from util import *
from Labels import *
from Annotations import *

class Disassembler:
    def __init__(self, cpu, map, labels):
        self.cpu = cpu  # type: CPU
        self.memory_map = map  # type: MemoryMap
        self.memory = self.cpu.memory  # type: Memory
        self.labels = labels  # type: Labels

        self.ops = [(1, "???")] * 0x100
        self.setup_ops()

    def setup_ops(self):
        self.ops[0x00] = (1, "BRK", None)
        self.ops[0x01] = (2, "ORA", self.indirect_x_mode)
        self.ops[0x05] = (2, "ORA", self.zero_page_mode)
        self.ops[0x06] = (2, "ASL", self.zero_page_mode)
        self.ops[0x08] = (1, "PHP", None)
        self.ops[0x09] = (2, "ORA", self.immediate_mode)
        self.ops[0x0A] = (1, "ASL", None)
        self.ops[0x0D] = (3, "ORA", self.absolute_mode)
        self.ops[0x0E] = (3, "ASL", self.absolute_mode)
        self.ops[0x10] = (2, "BPL", self.relative_mode)
        self.ops[0x11] = (2, "ORA", self.indirect_y_mode)
        self.ops[0x15] = (2, "ORA", self.zero_page_x_mode)
        self.ops[0x16] = (2, "ASL", self.zero_page_x_mode)
        self.ops[0x18] = (1, "CLC", None)
        self.ops[0x19] = (3, "ORA", self.absolute_y_mode)
        self.ops[0x1D] = (3, "ORA", self.absolute_x_mode)
        self.ops[0x1E] = (3, "ASL", self.absolute_x_mode)
        self.ops[0x20] = (3, "JSR", self.absolute_mode)
        self.ops[0x21] = (2, "AND", self.indirect_x_mode)
        self.ops[0x24] = (2, "BIT", self.zero_page_mode)
        self.ops[0x25] = (2, "AND", self.zero_page_mode)
        self.ops[0x26] = (2, "ROL", self.zero_page_mode)
        self.ops[0x28] = (1, "PLP", None)
        self.ops[0x29] = (2, "AND", self.immediate_mode)
        self.ops[0x2A] = (1, "ROL", None)
        self.ops[0x2C] = (3, "BIT", self.absolute_mode)
        self.ops[0x2D] = (3, "AND", self.absolute_mode)
        self.ops[0x2E] = (3, "ROL", self.absolute_mode)
        self.ops[0x30] = (2, "BMI", self.relative_mode)
        self.ops[0x31] = (2, "AND", self.indirect_y_mode)
        self.ops[0x35] = (2, "AND", self.zero_page_x_mode)
        self.ops[0x36] = (2, "ROL", self.zero_page_x_mode)
        self.ops[0x38] = (1, "SEC", None)
        self.ops[0x39] = (3, "AND", self.absolute_y_mode)
        self.ops[0x3D] = (3, "AND", self.absolute_x_mode)
        self.ops[0x3E] = (3, "ROL", self.absolute_x_mode)
        self.ops[0x40] = (1, "RTI", None)
        self.ops[0x41] = (2, "EOR", self.indirect_x_mode)
        self.ops[0x45] = (2, "EOR", self.zero_page_mode)
        self.ops[0x46] = (2, "LSR", self.zero_page_mode)
        self.ops[0x48] = (1, "PHA", None)
        self.ops[0x49] = (2, "EOR", self.immediate_mode)
        self.ops[0x4A] = (1, "LSR", None)
        self.ops[0x4C] = (3, "JMP", self.absolute_mode)
        self.ops[0x4D] = (3, "EOR", self.absolute_mode)
        self.ops[0x4E] = (3, "LSR", self.absolute_mode)
        self.ops[0x50] = (2, "BVC", self.relative_mode)
        self.ops[0x51] = (2, "EOR", self.indirect_y_mode)
        self.ops[0x55] = (2, "EOR", self.zero_page_x_mode)
        self.ops[0x56] = (2, "LSR", self.zero_page_x_mode)
        self.ops[0x58] = (1, "CLI", None)
        self.ops[0x59] = (3, "EOR", self.absolute_y_mode)
        self.ops[0x5D] = (3, "EOR", self.absolute_x_mode)
        self.ops[0x5E] = (3, "LSR", self.absolute_x_mode)
        self.ops[0x60] = (1, "RTS", None)
        self.ops[0x61] = (2, "ADC", self.indirect_x_mode)
        self.ops[0x65] = (2, "ADC", self.zero_page_mode)
        self.ops[0x66] = (2, "ROR", self.zero_page_mode)
        self.ops[0x68] = (1, "PLA", None)
        self.ops[0x69] = (2, "ADC", self.immediate_mode)
        self.ops[0x6A] = (1, "ROR", None)
        self.ops[0x6C] = (3, "JMP", self.indirect_mode)
        self.ops[0x6D] = (3, "ADC", self.absolute_mode)
        self.ops[0x6E] = (3, "ROR", self.absolute_mode)
        self.ops[0x70] = (2, "BVS", self.relative_mode)
        self.ops[0x71] = (2, "ADC", self.indirect_y_mode)
        self.ops[0x75] = (2, "ADC", self.zero_page_x_mode)
        self.ops[0x76] = (2, "ROR", self.zero_page_x_mode)
        self.ops[0x78] = (1, "SEI", None)
        self.ops[0x79] = (3, "ADC", self.absolute_y_mode)
        self.ops[0x7D] = (3, "ADC", self.absolute_x_mode)
        self.ops[0x7E] = (3, "ROR", self.absolute_x_mode)
        self.ops[0x81] = (2, "STA", self.indirect_x_mode)
        self.ops[0x84] = (2, "STY", self.zero_page_mode)
        self.ops[0x85] = (2, "STA", self.zero_page_mode)
        self.ops[0x86] = (2, "STX", self.zero_page_mode)
        self.ops[0x88] = (1, "DEY", None)
        self.ops[0x8A] = (1, "TXA", None)
        self.ops[0x8C] = (3, "STY", self.absolute_mode)
        self.ops[0x8D] = (3, "STA", self.absolute_mode)
        self.ops[0x8E] = (3, "STX", self.absolute_mode)
        self.ops[0x90] = (2, "BCC", self.relative_mode)
        self.ops[0x91] = (2, "STA", self.indirect_y_mode)
        self.ops[0x94] = (2, "STY", self.zero_page_x_mode)
        self.ops[0x95] = (2, "STA", self.zero_page_x_mode)
        self.ops[0x96] = (2, "STX", self.zero_page_y_mode)
        self.ops[0x98] = (1, "TYA", None)
        self.ops[0x99] = (3, "STA", self.absolute_y_mode)
        self.ops[0x9A] = (1, "TXS", None)
        self.ops[0x9D] = (3, "STA", self.absolute_x_mode)
        self.ops[0xA0] = (2, "LDY", self.immediate_mode)
        self.ops[0xA1] = (2, "LDA", self.indirect_x_mode)
        self.ops[0xA2] = (2, "LDX", self.immediate_mode)
        self.ops[0xA4] = (2, "LDY", self.zero_page_mode)
        self.ops[0xA5] = (2, "LDA", self.zero_page_mode)
        self.ops[0xA6] = (2, "LDX", self.zero_page_mode)
        self.ops[0xA8] = (1, "TAY", None)
        self.ops[0xA9] = (2, "LDA", self.immediate_mode)
        self.ops[0xAA] = (1, "TAX", None)
        self.ops[0xAC] = (3, "LDY", self.absolute_mode)
        self.ops[0xAD] = (3, "LDA", self.absolute_mode)
        self.ops[0xAE] = (3, "LDX", self.absolute_mode)
        self.ops[0xB0] = (2, "BCS", self.relative_mode)
        self.ops[0xB1] = (2, "LDA", self.indirect_y_mode)
        self.ops[0xB4] = (2, "LDY", self.zero_page_x_mode)
        self.ops[0xB5] = (2, "LDA", self.zero_page_x_mode)
        self.ops[0xB6] = (2, "LDX", self.zero_page_y_mode)
        self.ops[0xB8] = (1, "CLV", None)
        self.ops[0xB9] = (3, "LDA", self.absolute_y_mode)
        self.ops[0xBA] = (1, "TSX", None)
        self.ops[0xBC] = (3, "LDY", self.absolute_x_mode)
        self.ops[0xBD] = (3, "LDA", self.absolute_x_mode)
        self.ops[0xBE] = (3, "LDX", self.absolute_y_mode)
        self.ops[0xC0] = (2, "CPY", self.immediate_mode)
        self.ops[0xC1] = (2, "CMP", self.indirect_x_mode)
        self.ops[0xC4] = (2, "CPY", self.zero_page_mode)
        self.ops[0xC5] = (2, "CMP", self.zero_page_mode)
        self.ops[0xC6] = (2, "DEC", self.zero_page_mode)
        self.ops[0xC8] = (1, "INY", None)
        self.ops[0xC9] = (2, "CMP", self.immediate_mode)
        self.ops[0xCA] = (1, "DEX", None)
        self.ops[0xCC] = (3, "CPY", self.absolute_mode)
        self.ops[0xCD] = (3, "CMP", self.absolute_mode)
        self.ops[0xCE] = (3, "DEC", self.absolute_mode)
        self.ops[0xD0] = (2, "BNE", self.relative_mode)
        self.ops[0xD1] = (2, "CMP", self.indirect_y_mode)
        self.ops[0xD5] = (2, "CMP", self.zero_page_x_mode)
        self.ops[0xD6] = (2, "DEC", self.zero_page_x_mode)
        self.ops[0xD8] = (1, "CLD", None)
        self.ops[0xD9] = (3, "CMP", self.absolute_y_mode)
        self.ops[0xDD] = (3, "CMP", self.absolute_x_mode)
        self.ops[0xDE] = (3, "DEC", self.absolute_x_mode)
        self.ops[0xE0] = (2, "CPX", self.immediate_mode)
        self.ops[0xE1] = (2, "SBC", self.indirect_x_mode)
        self.ops[0xE4] = (2, "CPX", self.zero_page_mode)
        self.ops[0xE5] = (2, "SBC", self.zero_page_mode)
        self.ops[0xE6] = (2, "INC", self.zero_page_mode)
        self.ops[0xE8] = (1, "INX", None)
        self.ops[0xE9] = (2, "SBC", self.immediate_mode)
        self.ops[0xEA] = (1, "NOP", None)
        self.ops[0xEC] = (3, "CPX", self.absolute_mode)
        self.ops[0xED] = (3, "SBC", self.absolute_mode)
        self.ops[0xEE] = (3, "INC", self.absolute_mode)
        self.ops[0xF0] = (2, "BEQ", self.relative_mode)
        self.ops[0xF1] = (2, "SBC", self.indirect_y_mode)
        self.ops[0xF5] = (2, "SBC", self.zero_page_x_mode)
        self.ops[0xF6] = (2, "INC", self.zero_page_x_mode)
        self.ops[0xF8] = (1, "SED", None)
        self.ops[0xF9] = (3, "SBC", self.absolute_y_mode)
        self.ops[0xFD] = (3, "SBC", self.absolute_x_mode)
        self.ops[0xFE] = (3, "INC", self.absolute_x_mode)

    def absolute_mode(self, pc):
        a = self.cpu.read_word(pc + 1)
        return {
            "operand": "$%04x" % a,
            "operand_address": a,
            "memory": [a, 2, self.cpu.read_word(a)],
        }

    def absolute_x_mode(self, pc):
        a = self.cpu.read_word(pc + 1)
        e = a + self.cpu.X
        return {
            "operand": "$%04x,X" % a,
            "operand_address": a,
            "memory": [e, 1, self.cpu.read_byte(e)],
        }

    def absolute_y_mode(self, pc):
        a = self.cpu.read_word(pc + 1)
        e = a + self.cpu.Y
        return {
            "operand": "$%04x,Y" % a,
            "operand_address": a,
            "memory": [e, 1, self.cpu.read_byte(e)],
        }

    def immediate_mode(self, pc):
        v = self.cpu.read_byte(pc + 1)
        return {
            "operand": "#$%02x" % (v),
            "operand_value": v,
        }

    def indirect_mode(self, pc):
        a = self.cpu.read_word(pc + 1)
        return {
            "operand": "($%04x)" % a,
            "operand_address": a,
            "memory": [a, 2, self.cpu.read_word(a)],
        }

    def indirect_x_mode(self, pc):
        z = self.cpu.read_byte(pc + 1)
        a = self.cpu.read_word( (z + self.cpu.X) % 0x100 )
        return {
            "operand": "($%02x,X)" % z,
            "operand_address": z,
            "memory": [a, 1, self.cpu.read_byte(a)],
        }

    def indirect_y_mode(self, pc):
        z = self.cpu.read_byte(pc + 1)
        a = self.cpu.read_word(z) + self.cpu.Y
        return {
            "operand": "($%02x),Y" % z,
            "operand_address": z,
            "memory": [a, 1, self.cpu.read_byte(a)],
        }

    def relative_mode(self, pc):
        a = pc + signed(self.cpu.read_byte(pc + 1) + 2)
        return {
            "operand": "$%04x" % a,
            "operand_address": a,
        }

    def zero_page_mode(self, pc):
        a = self.cpu.read_byte(pc + 1)
        return {
            "operand": "$%02x" % a,
            "operand_address": a,
            "memory": [a, 1, self.cpu.read_byte(a)],
        }

    def zero_page_x_mode(self, pc):
        z = self.cpu.read_byte(pc + 1)
        a = (z + self.cpu.X) % 0x100
        return {
            "operand": "$%02x,X" % z,
            "operand_address": z,
            "memory": [a, 1, self.cpu.read_byte(a)],
        }

    def zero_page_y_mode(self, pc):
        z = self.cpu.read_byte(pc + 1)
        a = (z + self.cpu.Y) % 0x100
        return {
            "operand": "$%02x,Y" % z,
            "operand_address": z,
            "memory": [a, 1, self.cpu.read_byte(a)],
        }

    def collect_op_info( self, pc ):
        op = self.cpu.read_byte(pc)
        op_info = self.ops[op]

        r = {
            "address": pc,
            "bytes": [self.cpu.read_byte(pc + i) for i in range(op_info[0])],
            "mnemonic": op_info[1],
        }

        # some of the operands will access keyb state etc. in page $C0
        # the side effects of such a memory access is not wanted here - - we just need to acccess the memory
        using_softswitches = self.memory.use_apple_softswitches
        self.memory.use_apple_softswitches = False

        # no need to read any argument for immediate addressing mode (has just one entry in the opcode list)
        # if address mode indicates an argument: info[2] is function pointer for the address mode
        if len(op_info) > 2 and op_info[2] is not None:
            specific_instruction_data = op_info[2](pc)
            r.update(specific_instruction_data)

        # self.memory.use_apple_softswitches = using_softswitches

        # returned size of instruction
        return r, op_info[0]


    def __disassemble_byte_blocks( self, byte_block_start, byte_block_end, lines ):

        # convert [start:end] memory to 2-char hexbytes
        hexbytes = list(map(lambda x: hexbyte(x), self.memory._mem[byte_block_start:byte_block_end]))

        # full block lines start at 16-byte boundaries (i.e. 0 as last digit of the 16bit address)
        # first line might have to be padded left
        additional_spaces = byte_block_start % 16
        hexbytes = ['  '] * additional_spaces + hexbytes

        # first address shown must is of course unadjusted
        address = byte_block_start
        for index, chunk in enumerate(list(chunks(hexbytes, 16))):
            line = [
                hexaddr(address),
                '',
                '',
                '.byte',
                ' '.join(chunk),
                '',
            ]
            lines.append(line)

            # first line might be padded
            # next lines start at 16-byte boundaries
            # NOTE: last line in the listing might be padded right (depending on chunking)
            address += 16 if index > 0 else 16 - additional_spaces


    def disassemble( self, start_address, end_address=0xC000, instructions=None ):

        # instructions: number of instructions to disassemble
        assert instructions is None or instructions > 0

        lines = []

        def add_empty_line():
            lines.append(['', '', '', '', '', ''])

        byte_block_start = None
        byte_block_end = None
        address = start_address
        while (address <= end_address) and (instructions is None or instructions > 0):

            if not self.memory_map.is_op(address):
                if byte_block_start is None:
                    byte_block_start = address
                    byte_block_end = address
                byte_block_end += 1

                address += 1
            else:
                if byte_block_start is not None:
                    # flush byte block
                    add_empty_line()
                    self.__disassemble_byte_blocks( byte_block_start, byte_block_end, lines )
                    byte_block_start = None

                info = self.memory_map.infos[address]  # type: OpInfo

                inline_label = ''

                comments = []

                if info.has_label():
                    # for now we show every label
                    # TODO: think about which labels we don't need
                    # IMPORTANT: if we do not show a label but use it in leaps_from/leaps_to then Excel cannot scroll to it
                    inline_label = info.label

                    leaps_from = info.leaps_from.verbose( self )

                    if not info.leaps_from.has_single_leap_from_regular_RTS():
                        # returns from RTS don't need an empty line after the JSR
                        add_empty_line()

                    if info.has_single_leap_from_no_branching():
                        # branch is immediately above, no need to show anything here
                        # this only pertains to branches which actually fall through sequentially at least once
                        # the branch above is marked anways w/ 0 or - in this case
                        pass
                    else:
                        comments.append("< %s" % leaps_from)

                instruction, length = self.collect_op_info( address )
                bytes = instruction['bytes']

                operand = '' if 'operand' not in instruction else instruction['operand']
                if 'operand_address' in instruction:
                    operand_address = instruction['operand_address']
                    operand = self.labels.replace_operand_address(operand, operand_address)

                mnemonic = instruction['mnemonic']

                if info.is_leap():
                    info_leap = info  # type: OpInfo
                    if info_leap.is_branch():
                        # branch encountered in spidered section (i.e. not on real execution path) has branched==None
                        branched = info_leap.branched if info_leap.branched else "?"
                        comments.append(branched)

                    elif mnemonic == "RTS":
                        comments.append("> %s" % info_leap.leaps_to.verbose( self ) )

                str_bytes = hexbyte(bytes[0])
                str_bytes += ' ' + hexbyte(bytes[1]) if len(bytes) > 1 else ''
                str_bytes += ' ' + hexbyte(bytes[2]) if len(bytes) > 2 else ''

                line = [
                    hexaddr(address),
                    str_bytes,
                    inline_label,
                    mnemonic,
                    operand,
                    ', '.join(comments) if len(comments) > 0 else '',
                ]
                lines.append(line)

                address += length
                if instructions is not None:
                    instructions -= 1

        # if we end in the byte block then we have to flush it
        if byte_block_start is not None:
            add_empty_line()
            self.__disassemble_byte_blocks( byte_block_start, byte_block_end, lines )

        return lines


    def disassemble_formatted( self, start_address, end_address=0xC000, instructions=None ):
        d = []
        lines = self.disassemble( start_address, end_address, instructions )
        for l in lines:
            if len(l) == 0:
                d.append('')
            else:
                [address, str_bytes, inline_label, mnemonic, operand, comments] = l
                line = "{0:<5}  {1:<8}    {2:<20} {3:<5} {4:<20} {5}".format(
                    address,
                    str_bytes,
                    inline_label.ljust(15, ' '),
                    mnemonic,
                    operand.ljust(15, ' '),
                    '; ' + comments if len(comments) > 0 else '',
                )
                d.append(line)
        return d
