import unittest
from Memory import Memory
from CPU import CPU
from Assembler import *
from Disassembler import *
from Apple import *
import re

class TestMemory(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()

    def test_load(self):
        self.memory.load_test_data(0x1000, [0x01, 0x02, 0x03])
        self.assertEqual(self.memory.read_byte(0x1000), 0x01)
        self.assertEqual(self.memory.read_byte(0x1001), 0x02)
        self.assertEqual(self.memory.read_byte(0x1002), 0x03)

    def test_write(self):
        self.memory.write_byte(0x1000, 0x11)
        self.memory.write_byte(0x1001, 0x12)
        self.memory.write_byte(0x1002, 0x13)
        self.assertEqual(self.memory.read_byte(0x1000), 0x11)
        self.assertEqual(self.memory.read_byte(0x1001), 0x12)
        self.assertEqual(self.memory.read_byte(0x1002), 0x13)


class TestLoadStoreOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU( self.memory, program_counter=0 )
        self.memory.load_test_data(0x1000, [0x00, 0x01, 0x7F, 0x80, 0xFF])

    def test_LDA(self):
        self.cpu.LDA(0x1000)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.LDA(0x1001)
        self.assertEqual( self.cpu.A, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDA(0x1002)
        self.assertEqual( self.cpu.A, 0x7F )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDA(0x1003)
        self.assertEqual( self.cpu.A, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDA(0x1004)
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_LDX(self):
        self.cpu.LDX(0x1000)
        self.assertEqual( self.cpu.X, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.LDX(0x1001)
        self.assertEqual( self.cpu.X, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDX(0x1002)
        self.assertEqual( self.cpu.X, 0x7F )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDX(0x1003)
        self.assertEqual( self.cpu.X, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDX(0x1004)
        self.assertEqual( self.cpu.X, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_LDY(self):
        self.cpu.LDY(0x1000)
        self.assertEqual( self.cpu.Y, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.LDY(0x1001)
        self.assertEqual( self.cpu.Y, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDY(0x1002)
        self.assertEqual( self.cpu.Y, 0x7F )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDY(0x1003)
        self.assertEqual( self.cpu.Y, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.LDY(0x1004)
        self.assertEqual( self.cpu.Y, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_STA(self):
        self.cpu.A = 0x37
        self.cpu.STA(0x2000)
        self.assertEqual(self.memory.read_byte(0x2000), 0x37)

    def test_STX(self):
        self.cpu.X = 0x38
        self.cpu.STX(0x2000)
        self.assertEqual(self.memory.read_byte(0x2000), 0x38)

    def test_STY(self):
        self.cpu.Y = 0x39
        self.cpu.STY(0x2000)
        self.assertEqual(self.memory.read_byte(0x2000), 0x39)


class TestRegisterTransferOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_TAX(self):
        self.cpu.A = 0x00
        self.cpu.TAX()
        self.assertEqual( self.cpu.X, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.A = 0x01
        self.cpu.TAX()
        self.assertEqual( self.cpu.X, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.A = 0xFF
        self.cpu.TAX()
        self.assertEqual( self.cpu.X, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_TAY(self):
        self.cpu.A = 0x00
        self.cpu.TAY()
        self.assertEqual( self.cpu.Y, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.A = 0x01
        self.cpu.TAY()
        self.assertEqual( self.cpu.Y, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.A = 0xFF
        self.cpu.TAY()
        self.assertEqual( self.cpu.Y, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_TXA(self):
        self.cpu.X = 0x00
        self.cpu.TXA()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.X = 0x01
        self.cpu.TXA()
        self.assertEqual( self.cpu.A, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.X = 0xFF
        self.cpu.TXA()
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_TYA(self):
        self.cpu.Y = 0x00
        self.cpu.TYA()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.Y = 0x01
        self.cpu.TYA()
        self.assertEqual( self.cpu.A, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.Y = 0xFF
        self.cpu.TYA()
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)


class TestStackOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_TSX(self):
        s = self.cpu.SP
        self.cpu.TSX()
        self.assertEqual( self.cpu.X, s )
        # @@@ check NZ?

    def test_TXS(self):
        x = self.cpu.X
        self.cpu.TXS()
        self.assertEqual( self.cpu.SP, x )

    def test_PHA_and_PLA(self):
        self.cpu.A = 0x00
        self.cpu.PHA()
        self.cpu.A = 0x01
        self.cpu.PHA()
        self.cpu.A = 0xFF
        self.cpu.PHA()
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.cpu.PLA()
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.cpu.PLA()
        self.assertEqual( self.cpu.A, 0x01 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.cpu.PLA()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 0)

    def test_PHP_and_PLP(self):
        p = self.cpu.status_as_byte()
        self.cpu.PHP()
        self.cpu.status_from_byte(0xFF)
        self.cpu.PLP()
        self.assertEqual(self.cpu.status_as_byte(), p)


class TestLogicalOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_AND(self):
        self.memory.write_byte(0x1000, 0x37)
        self.cpu.A = 0x34
        self.cpu.AND(0x1000)
        self.assertEqual( self.cpu.A, 0x34 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.cpu.A = 0x40
        self.cpu.AND(0x1000)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 0)

    def test_EOR(self):
        self.memory.write_byte(0x1000, 0x37)
        self.cpu.A = 0x34
        self.cpu.EOR(0x1000)
        self.assertEqual( self.cpu.A, 0x03 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.cpu.A = 0x90
        self.cpu.EOR(0x1000)
        self.assertEqual( self.cpu.A, 0xA7 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.cpu.A = 0x37
        self.cpu.EOR(0x1000)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 0)

    def test_ORA(self):
        self.memory.write_byte(0x1000, 0x37)
        self.cpu.A = 0x34
        self.cpu.ORA(0x1000)
        self.assertEqual( self.cpu.A, 0x37 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.cpu.A = 0x90
        self.cpu.ORA(0x1000)
        self.assertEqual( self.cpu.A, 0xB7 )
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.cpu.A = 0x00
        self.cpu.ORA(0x1001)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 0)

    def test_BIT(self):
        self.memory.write_byte(0x1000, 0x00)
        self.cpu.A = 0x00
        self.cpu.BIT(0x1000)
        self.assertEqual(self.cpu.overflow_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.memory.write_byte(0x1000, 0x40)
        self.cpu.A = 0x00
        self.cpu.BIT(0x1000)
        self.assertEqual(self.cpu.overflow_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.memory.write_byte(0x1000, 0x80)
        self.cpu.A = 0x00
        self.cpu.BIT(0x1000)
        self.assertEqual(self.cpu.overflow_flag, 0)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.memory.write_byte(0x1000, 0xC0)
        self.cpu.A = 0x00
        self.cpu.BIT(0x1000)
        self.assertEqual(self.cpu.overflow_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.memory.write_byte(0x1000, 0xC0)
        self.cpu.A = 0xC0
        self.cpu.BIT(0x1000)
        self.assertEqual(self.cpu.overflow_flag, 1)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)


class TestArithmeticOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_ADC_without_BCD(self):

        ## test cases from http://www.6502.org/tutorials/vflag.html

        # 1 + 1 = 2  (C = 0; V = 0)
        self.cpu.carry_flag = 0
        self.cpu.A = 0x01
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.ADC(0x1000)
        self.assertEqual( self.cpu.A, 0x02 )
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 0)

        # 1 + -1 = 0  (C = 1; V = 0)
        self.cpu.carry_flag = 0
        self.cpu.A = 0x01
        self.memory.write_byte(0x1000, 0xFF)
        self.cpu.ADC(0x1000)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.carry_flag, 1)
        self.assertEqual(self.cpu.overflow_flag, 0)

        # 127 + 1 = 128  (C = 0; V = 1)
        self.cpu.carry_flag = 0
        self.cpu.A = 0x7F
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.ADC(0x1000)
        self.assertEqual( self.cpu.A, 0x80 )  # @@@
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 1)

        # -128 + -1 = -129  (C = 1; V = 1)
        self.cpu.carry_flag = 0
        self.cpu.A = 0x80
        self.memory.write_byte(0x1000, 0xFF)
        self.cpu.ADC(0x1000)
        self.assertEqual( self.cpu.A, 0x7F )  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.assertEqual(self.cpu.overflow_flag, 1)

        # 63 + 64 + 1 = 128  (C = 0; V = 1)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x3F
        self.memory.write_byte(0x1000, 0x40)
        self.cpu.ADC(0x1000)
        self.assertEqual( self.cpu.A, 0x80 )
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 1)

    def test_SBC_without_BCD(self):
        self.cpu.A = 0x02
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.carry_flag, 1)
        self.assertEqual(self.cpu.overflow_flag, 0)

        self.cpu.A = 0x01
        self.memory.write_byte(0x1000, 0x02)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 0)  # @@@

        ## test cases from http://www.6502.org/tutorials/vflag.html

        # 0 - 1 = -1  (V = 0)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x00
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0xFF )
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 0)  # @@@

        # -128 - 1 = -129  (V = 1)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x80
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0x7F )
        self.assertEqual(self.cpu.carry_flag, 1)
        self.assertEqual(self.cpu.overflow_flag, 1)

        # 127 - -1 = 128  (V = 1)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x7F
        self.memory.write_byte(0x1000, 0xFF)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0x80 )
        self.assertEqual(self.cpu.carry_flag, 0)
        self.assertEqual(self.cpu.overflow_flag, 1)

        # -64 -64 -1 = -129  (V = 1)
        self.cpu.carry_flag = 0
        self.cpu.A = 0xC0
        self.memory.write_byte(0x1000, 0x40)
        self.cpu.SBC(0x1000)
        self.assertEqual( self.cpu.A, 0x7F )
        self.assertEqual(self.cpu.carry_flag, 1)
        self.assertEqual(self.cpu.overflow_flag, 1)  # @@@

    ## @@@ BCD versions still to do

    def test_CMP(self):
        self.cpu.A = 0x0A
        self.memory.write_byte(0x1000, 0x09)
        self.cpu.CMP(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.A = 0x0A
        self.memory.write_byte(0x1000, 0x0B)
        self.cpu.CMP(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

        self.cpu.A = 0x0A
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CMP(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.A = 0xA0
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CMP(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.A = 0x0A
        self.memory.write_byte(0x1000, 0xA0)
        self.cpu.CMP(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)  # @@@
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

    def test_CPX(self):
        self.cpu.X = 0x0A
        self.memory.write_byte(0x1000, 0x09)
        self.cpu.CPX(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.X = 0x0A
        self.memory.write_byte(0x1000, 0x0B)
        self.cpu.CPX(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

        self.cpu.X = 0x0A
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CPX(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.X = 0xA0
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CPX(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.X = 0x0A
        self.memory.write_byte(0x1000, 0xA0)
        self.cpu.CPX(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)  # @@@
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

    def test_CPY(self):
        self.cpu.Y = 0x0A
        self.memory.write_byte(0x1000, 0x09)
        self.cpu.CPY(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.Y = 0x0A
        self.memory.write_byte(0x1000, 0x0B)
        self.cpu.CPY(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

        self.cpu.Y = 0x0A
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CPY(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.Y = 0xA0
        self.memory.write_byte(0x1000, 0x0A)
        self.cpu.CPY(0x1000)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 1)

        self.cpu.Y = 0x0A
        self.memory.write_byte(0x1000, 0xA0)
        self.cpu.CPY(0x1000)
        self.assertEqual(self.cpu.sign_flag, 0)  # @@@
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)


class TestIncrementDecrementOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_INC(self):
        self.memory.write_byte(0x1000, 0x00)
        self.cpu.INC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x01)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.memory.write_byte(0x1000, 0x7F)
        self.cpu.INC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x80)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.memory.write_byte(0x1000, 0xFF)
        self.cpu.INC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x00)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)

    def test_INX(self):
        self.cpu.X = 0x00
        self.cpu.INX()
        self.assertEqual( self.cpu.X, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.X = 0x7F
        self.cpu.INX()
        self.assertEqual( self.cpu.X, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.X = 0xFF
        self.cpu.INX()
        self.assertEqual( self.cpu.X, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)

    def test_INY(self):
        self.cpu.Y = 0x00
        self.cpu.INY()
        self.assertEqual( self.cpu.Y, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.Y = 0x7F
        self.cpu.INY()
        self.assertEqual( self.cpu.Y, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.Y = 0xFF
        self.cpu.INY()
        self.assertEqual( self.cpu.Y, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)

    def test_DEC(self):
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.DEC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x00)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.memory.write_byte(0x1000, 0x80)
        self.cpu.DEC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x7F)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.memory.write_byte(0x1000, 0x00)
        self.cpu.DEC(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0xFF)
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_DEX(self):
        self.cpu.X = 0x01
        self.cpu.DEX()
        self.assertEqual( self.cpu.X, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.X = 0x80
        self.cpu.DEX()
        self.assertEqual( self.cpu.X, 0x7F )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.X = 0x00
        self.cpu.DEX()
        self.assertEqual( self.cpu.X, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)

    def test_DEY(self):
        self.cpu.Y = 0x01
        self.cpu.DEY()
        self.assertEqual( self.cpu.Y, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.cpu.Y = 0x80
        self.cpu.DEY()
        self.assertEqual( self.cpu.Y, 0x7F )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.cpu.Y = 0x00
        self.cpu.DEY()
        self.assertEqual( self.cpu.Y, 0xFF )
        self.assertEqual(self.cpu.sign_flag, 1)
        self.assertEqual(self.cpu.zero_flag, 0)


class TestShiftOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_ASL(self):
        self.cpu.A = 0x01
        self.cpu.ASL()
        self.assertEqual( self.cpu.A, 0x02 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)
        self.memory.write_byte(0x1000, 0x02)
        self.cpu.ASL(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x04)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)
        self.cpu.A = 0x80
        self.cpu.ASL()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)

    def test_LSR(self):
        self.cpu.A = 0x01
        self.cpu.LSR()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.LSR(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x00)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.A = 0x80
        self.cpu.LSR()
        self.assertEqual( self.cpu.A, 0x40 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)
        self.assertEqual(self.cpu.carry_flag, 0)

    def test_ROL(self):
        self.cpu.carry_flag = 0
        self.cpu.A = 0x80
        self.cpu.ROL()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x80
        self.cpu.ROL()
        self.assertEqual( self.cpu.A, 0x01 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 0
        self.memory.write_byte(0x1000, 0x80)
        self.cpu.ROL(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x00)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 1
        self.memory.write_byte(0x1000, 0x80)
        self.cpu.ROL(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x01)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 0)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)

    def test_ROR(self):
        self.cpu.carry_flag = 0
        self.cpu.A = 0x01
        self.cpu.ROR()
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 1
        self.cpu.A = 0x01
        self.cpu.ROR()
        self.assertEqual( self.cpu.A, 0x80 )
        self.assertEqual(self.cpu.sign_flag, 1)  # @@@
        self.assertEqual(self.cpu.zero_flag, 0)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 0
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.ROR(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x00)
        self.assertEqual(self.cpu.sign_flag, 0)
        self.assertEqual(self.cpu.zero_flag, 1)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)
        self.cpu.carry_flag = 1
        self.memory.write_byte(0x1000, 0x01)
        self.cpu.ROR(0x1000)
        self.assertEqual(self.memory.read_byte(0x1000), 0x80)
        self.assertEqual(self.cpu.sign_flag, 1)  # @@@
        self.assertEqual(self.cpu.zero_flag, 0)  # @@@
        self.assertEqual(self.cpu.carry_flag, 1)


class TestJumpCallOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_JMP(self):
        self.cpu.JMP(0x1000)
        self.assertEqual( self.cpu.PC, 0x1000 )

    def test_JSR(self):
        self.cpu.PC = 0x1000
        self.cpu.JSR(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )
        self.assertEqual( self.memory.read_byte( self.cpu.STACK_PAGE + self.cpu.SP + 1 ), 0xFF )
        self.assertEqual( self.memory.read_byte( self.cpu.STACK_PAGE + self.cpu.SP + 2 ), 0x0F )

    def test_RTS(self):
        self.memory.write_byte(self.cpu.STACK_PAGE + 0xFF, 0x12)
        self.memory.write_byte(self.cpu.STACK_PAGE + 0xFE, 0x33)
        self.cpu.SP = 0xFD
        self.cpu.RTS()
        self.assertEqual( self.cpu.PC, 0x1234 )

    def test_JSR_and_RTS(self):
        self.cpu.PC = 0x1000
        self.cpu.JSR(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )
        self.cpu.RTS()
        self.assertEqual( self.cpu.PC, 0x1000 )  # @@@


class TestBranchOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_BCC(self):
        self.cpu.PC = 0x1000
        self.cpu.carry_flag = 1
        self.cpu.BCC(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.carry_flag = 0
        self.cpu.BCC(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BCS(self):
        self.cpu.PC = 0x1000
        self.cpu.carry_flag = 0
        self.cpu.BCS(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.carry_flag = 1
        self.cpu.BCS(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BEQ(self):
        self.cpu.PC = 0x1000
        self.cpu.zero_flag = 0
        self.cpu.BEQ(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.zero_flag = 1
        self.cpu.BEQ(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BMI(self):
        self.cpu.PC = 0x1000
        self.cpu.sign_flag = 0
        self.cpu.BMI(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.sign_flag = 1
        self.cpu.BMI(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BNE(self):
        self.cpu.PC = 0x1000
        self.cpu.zero_flag = 1
        self.cpu.BNE(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.zero_flag = 0
        self.cpu.BNE(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BPL(self):
        self.cpu.PC = 0x1000
        self.cpu.sign_flag = 1
        self.cpu.BPL(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.sign_flag = 0
        self.cpu.BPL(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BVC(self):
        self.cpu.PC = 0x1000
        self.cpu.overflow_flag = 1
        self.cpu.BVC(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.overflow_flag = 0
        self.cpu.BVC(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )

    def test_BVS(self):
        self.cpu.PC = 0x1000
        self.cpu.overflow_flag = 0
        self.cpu.BVS(0x2000)
        self.assertEqual( self.cpu.PC, 0x1000 )
        self.cpu.PC = 0x1000
        self.cpu.overflow_flag = 1
        self.cpu.BVS(0x2000)
        self.assertEqual( self.cpu.PC, 0x2000 )


class TestStatusFlagOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_CLC(self):
        self.cpu.carry_flag = 1
        self.cpu.CLC()
        self.assertEqual(self.cpu.carry_flag, 0)

    def test_CLD(self):
        self.cpu.decimal_mode_flag = 1
        self.cpu.CLD()
        self.assertEqual(self.cpu.decimal_mode_flag, 0)

    def test_CLI(self):
        self.cpu.interrupt_disable_flag = 1
        self.cpu.CLI()
        self.assertEqual(self.cpu.interrupt_disable_flag, 0)

    def test_CLV(self):
        self.cpu.overflow_flag = 1
        self.cpu.CLV()
        self.assertEqual(self.cpu.overflow_flag, 0)

    def test_SEC(self):
        self.cpu.carry_flag = 0
        self.cpu.SEC()
        self.assertEqual(self.cpu.carry_flag, 1)

    def test_SED(self):
        self.cpu.decimal_mode_flag = 0
        self.cpu.SED()
        self.assertEqual(self.cpu.decimal_mode_flag, 1)

    def test_SEI(self):
        self.cpu.interrupt_disable_flag = 0
        self.cpu.SEI()
        self.assertEqual(self.cpu.interrupt_disable_flag, 1)


class TestSystemFunctionOperations(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_BRK(self):
        self.cpu.PC = 0x1000
        self.memory.load_test_data(0xFFFE, [0x00, 0x20])
        status = self.cpu.status_as_byte()
        self.cpu.BRK()
        self.assertEqual( self.cpu.PC, 0x2000 )
        self.assertEqual(self.cpu.break_flag, 1)
        self.assertEqual( self.memory.read_byte( self.cpu.STACK_PAGE + self.cpu.SP + 1 ), status )
        self.assertEqual( self.memory.read_byte( self.cpu.STACK_PAGE + self.cpu.SP + 2 ), 0x01 )
        self.assertEqual( self.memory.read_byte( self.cpu.STACK_PAGE + self.cpu.SP + 3 ), 0x10 )

    def test_RTI(self):
        self.memory.write_byte(self.cpu.STACK_PAGE + 0xFF, 0x12)
        self.memory.write_byte(self.cpu.STACK_PAGE + 0xFE, 0x33)
        self.memory.write_byte(self.cpu.STACK_PAGE + 0xFD, 0x20)
        self.cpu.SP = 0xFC
        self.cpu.RTI()
        self.assertEqual( self.cpu.PC, 0x1233 )
        self.assertEqual(self.cpu.status_as_byte(), 0x20)

    def test_NOP(self):
        self.cpu.NOP()


class Test6502Bugs(unittest.TestCase):

    def setUp(self):
        self.memory = Memory()
        self.cpu = CPU(self.memory, None)

    def test_zero_page_x(self):
        self.cpu.X = 0x01
        self.memory.load_test_data(0x1000, [0x00, 0x7F, 0xFF])
        self.cpu.PC = 0x1000
        self.assertEqual(self.cpu.zero_page_x_mode(), 0x01)
        self.assertEqual(self.cpu.zero_page_x_mode(), 0x80)
        self.assertEqual(self.cpu.zero_page_x_mode(), 0x00)

    def test_indirect(self):
        self.memory.load_test_data(0x20, [0x00, 0x20])
        self.memory.load_test_data(0x00, [0x12])
        self.memory.load_test_data(0xFF, [0x34])
        self.memory.load_test_data(0x100, [0x56])
        self.memory.load_test_data(0x1000, [0x20, 0x20, 0xFF, 0xFF, 0x00, 0x45, 0x23])
        self.memory.load_test_data(0x2000, [0x05])
        self.memory.load_test_data(0x1234, [0x05])
        self.memory.load_test_data(0x2345, [0x00, 0xF0])

        self.cpu.PC = 0x1000

        self.cpu.X = 0x00
        self.cpu.LDA(self.cpu.indirect_x_mode())
        self.assertEqual( self.cpu.A, 0x05 )

        self.cpu.Y = 0x00
        self.cpu.LDA(self.cpu.indirect_y_mode())
        self.assertEqual( self.cpu.A, 0x05 )

        self.cpu.Y = 0x00
        self.cpu.LDA(self.cpu.indirect_y_mode())
        self.assertEqual( self.cpu.A, 0x05 )

        self.cpu.X = 0x00
        self.cpu.LDA(self.cpu.indirect_x_mode())
        self.assertEqual( self.cpu.A, 0x05 )

        self.cpu.X = 0xFF
        self.cpu.LDA(self.cpu.indirect_x_mode())
        self.assertEqual( self.cpu.A, 0x05 )

        self.assertEqual(self.cpu.indirect_mode(), 0xF000)


class TestAssembler(unittest.TestCase):

    def setUp(self):
        self.apple2 = Apple2(no_display=True)
        self.cpu = self.apple2.cpu  # type: CPU
        self.asm = Assembler()

    def compile(self, program):
        tokens = self.asm.tokenize( program, verbose=False )
        code = self.asm.generate_code( tokens, verbose=False )
        return self.asm.to_byte_array( code )

    def beautify_byte_array(self, s):
        lines = s.splitlines()
        new = ''
        for index, line in enumerate(lines):
            if index > 0:
                new += '\n'
            new += line.strip()
        return new.strip()

    def run_to_RTS(self, byte_array, pc, max_instructions=1000, dump=None):
        for index, byte in enumerate(byte_array):
            self.cpu.memory._mem[pc+index] = byte
        self.cpu.PC = pc
        i = 0
        # while cpu.memory._mem[cpu.program_counter] != 0x60 and i!= 100:
        while self.cpu.last_opcode != 0x60 and i!= max_instructions:
            if dump is not None:
                dump(self.cpu)
            self.cpu.do_next_step()
            i += 1
        if i == max_instructions:
            print("max instructions reached")

    def dump_chromatix01_state( self ):
        print('%s A=%s X=%s $E0=%s $E1=%s $E2=%s' % (
              hexaddr( self.cpu.PC ),
              hexbyte( self.cpu.A ),
              hexbyte( self.cpu.X ),
              hexbyte(self.cpu.memory._mem[0xe0]),
              hexbyte(self.cpu.memory._mem[0xe1]),
              hexbyte(self.cpu.memory._mem[0xe2]),
              ))

    def test_dump(self, addresses=None, show_stack=False, show_status=False):
        registers = 'AXY'
        res = ['PC=%s' % hexaddr(self.cpu.PC, show_dollar=False)]
        for char in 'AXY':
            res.append('%s=%s' % (char, hexbyte(getattr(self.cpu, char ))))

        if addresses is not None:
            for address in addresses:
                res.append('%s=%s' % (hexaddr(address), hexbyte(self.cpu.memory._mem[address])))

        show_stack = True
        if show_stack:
            res.append('SP=%s' % hexbyte(self.cpu.SP))
            s = self.cpu.STACK_PAGE + self.cpu.SP + 1
            sp_address = self.cpu.memory.read_word(s)
            res.append('(SP)=%s' % hexbyte(self.cpu.memory._mem[sp_address]) if sp_address <= 0xFFFF else '?')

        show_status = True
        if show_status:
            res.append( 'F=%s' % ''.join([
                'C' if self.cpu.carry_flag else '_',
                'Z' if self.cpu.zero_flag else '_',
                'I' if self.cpu.interrupt_disable_flag else '_',
                'D' if self.cpu.decimal_mode_flag else '_',
                'B' if self.cpu.break_flag else '_',
                'O' if self.cpu.overflow_flag else '_',
                'S' if self.cpu.sign_flag else'_'
            ]))
        print(' '.join(res))


    def test_chromatix01(self):
        byte_array = self.compile( """
                ; Levenstein 1, 8-10
                multiplier = $e0
                multiplicand = $e1
                HResult = $e2

                *=$4C4F
                STA multiplier
                STX multiplicand
                LDA #$00            ; L-result
                STA HResult
                LDX #$08            ; go through all 8 bits
        .L8     ASL                 ; A is L-result (for now, finally X), "Product = 2x Product"
                ROL HResult
                ASL multiplier
                BCC .L7             ; "no addition if next bit is zero"
        .L9     CLC                 ; "add multiplicand to product"
                ADC multiplicand
                BCC .L7
                INC HResult         ; "with carry if necessary"
        .L7     DEX
                BNE .L8             ; "loop until 8 bits are multiplied"
        .L10    TAX                 ; L-result in X
                LDA HResult
                RTS
        """)

        test = self.beautify_byte_array("""
            85 e0 86 e1 a9 00 85 e2 a2 08 0a 26 e2 06 e0 90
            07 18 65 e1 90 02 e6 e2 ca d0 ef aa a5 e2 60
        """)
        self.assertEqual(test, self.asm.byte_array_to_text(byte_array))

        self.cpu.A = 6
        self.cpu.X = 3
        # self.run_to_RTS( cpu, byte_array, pc=0x4C4F, dump=self.dump_chromatix01_state )
        self.run_to_RTS( byte_array, pc=0x4C4F )
        self.assertEqual( self.cpu.X, 0x12 )  # decimal 18
        self.assertEqual( self.cpu.A, 0x00 )
        self.assertEqual(self.cpu.cycles, 197)


    def test_8bit_multiply_02(self):
        byte_array = self.compile( """
                ; Scanlon 120
                multiplier = $20
                multiplicand = $21
                LResult = $22

                *=$2000
                STA multiplier
                STX multiplicand
        MLT8    LDA #$00            ; "clear MSBY of product"
                STA LResult
                LDX #$08            ; "multiplier bit count = 8"
        NXTBT   LSR multiplier      ; "get next multiplier bit"
                BCC ALIGN           ; "multiplier = 1?"
                CLC                 ; "yes, add multiplicand"
                ADC multiplicand
        ALIGN   ROR                 ; "shift product right" - - this was LSR, wrong because we need the carry from ADC
                ROR LResult
                DEX                 ; "decrement bit count"
                BNE NXTBT           ; "loop until 8 bits are done"
                LDX LResult         ; L-result, H-result in A
                RTS
        """)

        self.cpu.reset()
        a = 0x02
        x = 0xEA
        self.cpu.A = a
        self.cpu.X = x
        self.run_to_RTS( byte_array, pc=0x2000 )
        # self.run_to_RTS( byte_array, pc=0x2000, dump=self.dump_chromatix01_state )
        self.assertEqual( (self.cpu.A << 8) + self.cpu.X, a * x )
        self.assertEqual(self.cpu.cycles, 185)

    def test_8bit_multiply_03(self):
        byte_array = self.compile( """
                ; https://www.lysator.liu.se/~nisse/misc/6502-mul.html
                ; http://6502org.wikidot.com/software-math-intmul
                ; This is basically Scanlon's version but using A as the LResult which is faster and saves a zp var

                multiplier = $e0
                multiplicand = $e1

                *=$2000
                STA multiplier
                STX multiplicand
                LDA #$00
                LDX #$08
                LSR multiplier
        loop    BCC no_add
                CLC
                ADC multiplicand
        no_add  ROR
                ROR multiplier
                DEX
                BNE loop
                LDX multiplier     ; L-result, H-result in A
                RTS
        """)

        self.cpu.A = 0xFF
        self.cpu.X = 0xFF
        self.run_to_RTS( byte_array, pc=0x2000 )
        ## self.assertEqual(cpu.x_index, 0x12)  # decimal 18

        cycle_counts = []

        x = 0xFF
        for a in range(0x00, 0x100):
            self.cpu.reset()
            self.cpu.A = a
            self.cpu.X = x
            self.run_to_RTS( byte_array, pc=0x2000 )
            # print(a, x, a*x, cpu.accumulator, cpu.accumulator << 8, cpu.x_index, (cpu.accumulator << 4) + cpu.x_index, a * x)
            self.assertEqual( (self.cpu.A << 8) + self.cpu.X, a * x )
            cycle_counts.append(self.cpu.cycles)

        self.assertEqual( sum(cycle_counts) / float(len(cycle_counts)), 159.0 )

    def test_8bit_bitcount(self):
        byte_array = self.compile( """
                    *=$2000
            ;======================================================
            ; Bit Counting Via a Lookup Table
            ;------------------------------------------------------
            ; The fastest way of figuring out how many bits are set
            ; in a byte is to use a precalculated table and index
            ; into it using either X or Y.
            ;
            ; This method is so simple that you don't need to put
            ; the code in a subroutine for reuse.
            ;
            ; The only downside to this is that it needs a whole
            ; 256 byte page to hold the lookup table.
            ;
            ; Time: 6 cycles (+1 if data table crosses page)
            ; Size: 256 bytes (for data)

            ; Look up table of bit counts in the values $00-$FF

            ;------------------------------------------------------

            ByteAtATime:
                ; x contains value to count the bits in
                LDA ByteBitCounts,X     ; A contains it's bit count
                RTS

            ByteBitCounts:
                .BYTE 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4
                .BYTE 1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5
                .BYTE 1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7
                .BYTE 1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7
                .BYTE 2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6
                .BYTE 3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7
                .BYTE 3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7
                .BYTE 4,5,5,6,5,6,6,7,5,6,6,7,6,7,7,8
        """)

        self.cpu.A = 0x01
        self.cpu.X = 0x04
        self.run_to_RTS( byte_array, pc=0x2000 )


class TestWaves(unittest.TestCase):

    def setUp(self):
        self.apple2 = Apple2(no_display=False)
        self.apple2.memory.load_image(0x2dfd, r'bin\ROBOTRON.BIN' )
        self.cpu = self.apple2.cpu  # type: CPU
        self.dis = Disassembler(self.cpu, None, None)
        self.asm = Assembler()

    def store( self, byte_array, target ):
        for index, byte in enumerate(byte_array):
            self.cpu.memory._mem[target + index] = byte

    def compile(self, program):
        tokens = self.asm.tokenize( program, verbose=False )
        code = self.asm.generate_code( tokens, verbose=False )
        return self.asm.to_byte_array( code )

    def run_to_PC( self, end_pc, dump=None ):
        while True:
            if isinstance(end_pc, int):
                if self.cpu.PC == end_pc:
                    break
            else:
                if self.cpu.PC in end_pc:
                    break
            if dump is not None:
                dump(self.cpu)
            self.cpu.do_next_step()

    def run_to_RTS(self, pc, dump=None):
        self.cpu.PC = pc
        while self.cpu.last_opcode != 0x60:
            self.cpu.do_next_step()
            if dump is not None:
                dump(self.cpu)

    def disassemble( self, address):
        instruction, length = self.dis.collect_op_info( address )
        bytes = instruction['bytes']

        operand = '' if 'operand' not in instruction else instruction['operand']

        mnemonic = instruction['mnemonic']
        str_bytes = hexbyte(bytes[0])
        str_bytes += ' ' + hexbyte(bytes[1]) if len(bytes) > 1 else ''
        str_bytes += ' ' + hexbyte(bytes[2]) if len(bytes) > 2 else ''

        return (length, "{0:<5}  {1:<8}    {2:<5} {3:<10}".format(
            hexaddr(address),
            str_bytes,
            mnemonic,
            operand
        ))

    def disassemble_instructions( self, address, instructions=1 ):
        i = 0
        pc = address
        while i != instructions:
            length, disassembled = self.disassemble(pc)
            print(disassembled)
            i += 1
            pc += length

    def label_2byte_address(self, label):
        address = self.asm.labels[label.upper()]
        hi = address >> 8
        lo = address & 0x00ff
        return lo, hi

    def test_input_wave(self):
        byte_array = self.compile( """
                *=$8600

        ; Robotron defines
                prepScreen = $4f25      ; clear screen
                showText = $51b8        ; show text in stash below JSR
                waitKbdControls = $4242 ; wait for key input
                wave_in_game = $1407    ; wave number (zero-based)

        ; zp variables
                state = $50
                event = $51
                first_digit = $52
                second_digit = $53
                wave = $54

        ; keys (high bit 0)
                ch_0 = #$30
                ch_colon = #$3A         ; comes after <9> in Apple, see check_is_number
                ch_left = #$08
                ch_return = #$0d
                ch_escape = #$1b
                ch_space = #$20

        ; state indexes into rts_table
                s_hasNone = #$00
                s_hasOne = #$01
                s_hasTwo = #$02
                s_exit = #$03

        choose_wave:                    ; ENTRY POINT
                LDA s_hasNone
                STA state

                LDA ch_space            ; start w/ empty input field
                STA first_digit
                STA second_digit

                JSR	prepScreen
                JSR	showText

                .byte	0D,09,28
                .byte   "CHOOSE WAVE (1-99): "
                .byte   00

        next_char:                      ; main loop
                JSR show_digits
                JSR	waitKbdControls

                CMP ch_escape           ; <Escape> breaks
                BEQ break

                CMP ch_return           ; <Return> is a valid char, concludes input (if possible)
                BEQ .send_event

                CMP ch_left             ; <Left> removes last digit
                BEQ .send_event

                check_is_number         ; only chars <0> to <9> allowed
                BCC next_char           ; carry cleared if not in <0> to <9>

            .send_event:
                STA event               ; dispatch event
                JSR dispatch_event

                LDA state               ; check if we should exit, i.e. user has entered a number
                CMP s_exit
                BEQ exit

                JMP next_char

        exit:
                DEC wave                ; wave input was 1-99, internally the waves start w/ 0
                LDX wave                ; returned wave is != $ff, i.e. valid
        halt0:  RTS

        break:
                LDA wave_in_game        ; sync internal wave zp var w/ ingame var
                STA wave
                LDX #$ff                ; break indicated by $ff
        halt1:  RTS

        show_digits:
                LDA first_digit         ; modify the 2 .byte below, at .digits
                STA .digits
                LDA second_digit
                STA .digits+1
                JSR showText            ; display
                .byte	0d,1d,28        ; X=1d (character #$00-27, 40 chars), Y=28 (of 192 pixel lines)
            .digits
                .byte   20,20           ; <space><space>
                .byte   00
                RTS

        check_is_number:
                ; http://6502.org/tutorials/compare_instructions.html
                ;    N Z C
                ; <: * 0 0
                ; =: 0 1 1
                ; >: * 0 1
                CMP ch_0                ; <0>
                BCS .greater_than_zero
                RTS                     ; is less than <0>, carry cleared
            .greater_than_zero:
                CMP ch_colon
                BCC .is_number          ; check if less than <:> (i.e. is less than <9>)
                CLC                     ; indicate it's not a number (carry cleared)
                RTS
            .is_number:
                SEC                     ; indicate it's a number (carry set)
                RTS

        dispatch_event:
                LDA state               ; state index into RTS table
                ASL                     ; table has 16bit addresses
                TAX
                LDA rts_table+1,X       ; push hibyte first
                PHA
                LDA rts_table,X         ; push lobyte second, will be popped first by RTS
                PHA
                LDA event               ; state subroutines get the event in A
                RTS

        state_hasNone:
                CMP ch_return           ; ignore Return
                BEQ .hasNone_done
                CMP ch_left
                BEQ .hasNone_done       ; ignore Left Arrow

                STA first_digit         ; ASSUMPTION (enforced by main loop): <0> - <9>
                LDA s_hasOne            ; we now have exactly 1 digit
                STA state               ; next state called by dispatch_event will be state_hasOne

            .hasNone_done:
                RTS

        state_hasOne:
                CMP ch_return
                BNE .hasOne_check_left

                LDA first_digit         ; <Return>, so calculate wave
                SEC
                SBC ch_0                ; first_digit in A from above, convert to number, sets Z if zero
                BEQ .hasOne_done        ; user entered <0> which is an invalid wave number - ignored
                STA wave
                LDA s_exit              ; main loop will exit with success
                STA state
            .hasOne_done
                RTS

            .hasOne_check_left
                CMP ch_left
                BNE .hasOne_add_digit
                LDA ch_space            ; clear the digit as shown on screen
                STA first_digit
                LDA s_hasNone           ; we don't have any digits anymore
                STA state
                RTS

            .hasOne_add_digit
                STA second_digit
                LDA s_hasTwo            ; we now have exactly 2 digits
                STA state
                RTS

        state_hasTwo:
                CMP ch_return
                BNE .hasTwo_check_left

                LDA first_digit         ; multiply first digit by 10
                SEC
                SBC ch_0
                ASL                     ; http://6502.org/source/integers/fastx10.htm
                STA wave
                ASL
                ASL
                CLC
                ADC wave
                STA wave

                LDA second_digit        ; add second digit
                SEC
                SBC ch_0
                CLC
                ADC wave                ; sets Z if zero
                BEQ .hasTwo_done        ; user entered <0><0> which is an invalid wave number - ignored

                STA wave                ; it's a valid wave number ...
                LDA s_exit
                STA state               ; ... so exit the main loop with success
                RTS

            .hasTwo_check_left
                CMP ch_left
                BNE .hasTwo_replace
                LDA ch_space            ; clear 2nd digit as shown on screen
                STA second_digit
                LDA s_hasOne            ; we now have exactly 1 digit
                STA state
                RTS

            .hasTwo_replace
                STA second_digit        ; replace second digit, no state change

            .hasTwo_done
                RTS

        state_exit:
                RTS                     ; we do nothing here, just a state to indicate success

        hook_4071:                      ; $4071	8D 07 14	STA	$1407 => overwrite w/ JSR hook_4071
                LDX wave                ; X is intentional, A used for other init stuff
                STX wave_in_game
                RTS

        hook_4b67:                      ; $4B67	20 25 4F	JSR	$4F25 => overwrite w/ JMP hook_4b67
                JSR choose_wave
                CPX #$ff                ; did we break?
                BNE continue_controls
                JMP $4be6               ; use chooseControl break (PLA / PLA / JMP $4060)

        continue_controls:
                JSR prepScreen          ; overwritten by hook
                JMP $4b6a               ; continue immediately behind the prep_screen

        rts_table:
                .word   state_hasNone-1
                .word   state_hasOne-1
                .word   state_hasTwo-1
                .word   state_exit-1
            """)

        self.store(byte_array, 0x8600)  # was 0x8600, 0x7e8d, 0x1e00
        print(len(byte_array))

        mem = self.apple2.memory._mem

        lo, hi = self.label_2byte_address('hook_4b67')
        mem[0x4b67] = 0x4c
        mem[0x4b68] = lo
        mem[0x4b69] = hi

        lo, hi = self.label_2byte_address('hook_4071')
        mem[0x4071] = 0x20
        mem[0x4072] = lo
        mem[0x4073] = hi

        self.apple2.memory.save_image(0x2dfd, 0x9000, r"tmp\ROBOTRON#062DFD.BIN")
        #self.apple2.memory.save_image(0x1e00, 0x9000, r"tmp\ROBOTRON#061E00.BIN")
        sys.exit(0)

        self.run_to_PC(0x4063)
        assert self.cpu.PC == 0x4063
        self.cpu.PC = 0xB000

        self.disassemble_instructions(0xb000, 145)

        self.labels_by_address = {}
        for key, value in self.asm.labels.items():
            self.labels_by_address[value] = key

        do_exit = self.asm.labels['HALT0']
        do_break = self.asm.labels['HALT1']
        self.kbd = [
            0x0d,   # return on empty digits, does nothing
            0x31,   # first digit
            0x15,   # clear first digit
            0x30,   # enter 0 as 10-digit
            0x30,   # second digit
            0x0d,   # nothing should happen
            0x39,   # enter 9 as 2nd digit
            0x0d,
        ]
        self.cpu.op_hook = self.op_hook
        if '.TEST' in self.asm.labels:
            do_test = self.asm.labels['.TEST']
            self.run_to_PC( [do_exit, do_break, do_test], self.dump)
        else:
            self.run_to_PC( [do_exit, do_break], self.dump)

        self.apple2.display.refresh_hires()
        time.sleep(1)

        # compile from hook.asm file
        # TDO: more test methods
        # TODO: https://www.tutorialspoint.com/python/python_reg_expressions.htm


    def op_hook(self, cpu):
        if cpu.PC == 0x4242: # waitKbdControls
            char = self.kbd[0]
            print("op_hook (waitKbdControls)", hexbyte(char))
            cpu.A = char
            del self.kbd[0]
            cpu.RTS()
            return True

    def dump(self, cpu):
        return
        # print(hexaddr(cpu.PC), hexaddr(cpu.last_PC))
        if cpu.last_PC >= 0xB000:
            if cpu.last_PC in self.labels_by_address:
                print(self.labels_by_address[cpu.last_PC])

            length, disassembled = self.disassemble(cpu.last_PC)
            matchObj = re.match(r'PC=[a-f0-9]+ (.+)', str(self.cpu))
            print(disassembled, ";", matchObj.group(1))


if __name__ == "__main__":
    unittest.main()
