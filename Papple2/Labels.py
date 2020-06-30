#!/usr/bin/env python3

from util import *
from CPU import *

class Labels:
    def __init__(self):
        self.labels = {}
        self.passed_labels = {}
        self.add_standard_lables()


    def add_address( self, leap_from_opcode: int, leap_to_address: int, label=None ):
        if leap_to_address in self.labels:
            return self.labels[leap_to_address]

        if label is None:
            if leap_to_address in self.passed_labels:
                label = self.passed_labels[leap_to_address]
            else:
                if leap_from_opcode == JSR:
                    marker = 'S'
                elif leap_from_opcode == RTS:
                    marker = 'R'
                elif leap_from_opcode in [JMP_absolute, JMP_indirect]:
                    marker = 'J'
                else:
                    marker = 'L'
                # print(hexaddr(leap_to_address, show_dollar=False))
                label = marker + hexaddr(leap_to_address, show_dollar=False)
        self.labels[leap_to_address] = label
        return label

    def add_labels(self, labels):
        for address, label in labels:
            self.passed_labels[address] = label

    def add_standard_lables(self):
        self.add_labels([
            (0xfc, 'LoLoPLBase'),
            (0xfd, 'HiLoPLBase'),
            (0xfe, 'LoHiPLBase'),
            (0xff, 'HiHiPLBase'),

            (0x1407, 'Level'),
            (0x1417, 'Control'),
            (0x150a, 'Score0'),
            (0x150b, 'Score1'),
            (0x150c, 'Score2'),

            (0xC000, 'r:KBD w:CLR80COL'),
            (0xC010, 'r:KBDSTRB'),
            (0xC030, 'rw:SPKR'),
            (0xC050, 'rw:TXTCLR'),
            (0xC052, 'rw:MIXCLR'),

            (0xc054, 'rw:TXTPAGE1'),
            (0xc057, 'rw:HIRES'),
            (0xc061, 'r:BUTN0'),
            (0xc062, 'r:BUTN1'),

            (0xfb1e, 'F8ROM:PREAD'),
            (0xfca8, 'F8ROM:WAIT'),

            (0x401f, 'overwrite4000'),
            (0x4025, 'initVariables'),
            (0x4060, 'initIntro'),
            (0x4242, 'waitKbd'),
            (0x449d, 'copyPagesAtoY'),
            (0x44ad, 'copyLoop'),
            (0x4504, 'startIntro'),
            (0x453d, 'waitKbd'),
            (0x455e, 'titleScene'),
            (0x456c, 'atariPresents'),
            (0x4582, 'doneAtari'),
            (0x4595, 'roboNoises'),
            (0x45ac, 'doneNoises'),
            (0x4b67, 'chooseControls'),
            (0x4bce, 'doneShowControls'),
            (0x4bd7, 'nextControlNum'),
            (0x4bdc, 'nextControlChar'),
            (0x4be6, 'unknownControl'),
            (0x4c36, 'compact02'),
            (0x4c4b, 'chromatixTop'),
            (0x4c4f, 'chromatix01'),
            (0x4e1f, 'showScore'),
            (0x4e4f, 'showLives'),
            (0x4ec4, 'stats-04'),
            (0x4f25, 'clearScreen'),
            (0x4f42, 'rightStats'),
            (0x4930, 'explainControls'),
            (0x4a51, 'doneExplain'),
            (0x5081, 'initRoboNoise'),
            (0x50a1, 'roboNoise-01'),
            (0x50c5, 'roboNoise'),
            (0x5108, 'printChar'),
            (0x512f, 'init01'),
            (0x51e8, 'readNextChar'),
            (0x51b8, 'showText'),
            (0x522e, 'showYou'),
        ])

    def replace_operand_address(self, operand: str, operand_address: int):
        # TODO: label replacement in operands must work for all addresses, including zero page
        if operand_address in self.labels:
            operand = operand.replace(hexaddr(operand_address), self.labels[operand_address])

        elif operand_address in self.passed_labels:
            # we never encountered the passed label for this particular address
            # if we had, the label would be in in self.labels
            assert operand_address not in self.labels
            operand = operand.replace(hexaddr(operand_address), self.passed_labels[operand_address])

        return operand
