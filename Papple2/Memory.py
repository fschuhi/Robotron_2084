#!/usr/bin/env python3

import pickle
from util import *

class Memory:
    def __init__( self, apple2 = None ):
        self.apple2 = apple2
        self.use_apple_softswitches = apple2 is not None
        self.use_apple_display = apple2 is not None
        self._mem = [0x00] * 0x10000

    def load_image(self, first_address, fn):
        with open(fn, "rb") as f:
            for offset, data in enumerate(f.read()):
                self._mem[first_address + offset] = data.to_bytes(1, 'little')[0]  # ord(datum)

    def save_image(self, first_address, last_address, fn):
        import struct
        mem = self._mem[first_address:last_address+1]
        bytes = struct.pack("{}B".format(len(mem)), *mem)
        with open(fn, "wb") as f:
            f.write(bytes)

    def load_test_data(self, address, data):
        for offset, datum in enumerate(data):
            self._mem[address + offset] = datum

    def pickle(self, pickler):
        pickler.dump(self._mem)
        pickler.dump(self.use_apple_display)
        pickler.dump(self.use_apple_softswitches)

    def unpickle(self, unpickler):
        self._mem = unpickler.load()
        self.use_apple_display = unpickler.load()
        self.use_apple_softswitches = unpickler.load()

    def read_byte(self, address):
        # access to $C0 pages w/ softswitches might be masked by softswitches mechanism
        if 0xC000 <= address <= 0xCFFF:
            return self.apple2.softswitches.read_byte( address ) if self.use_apple_softswitches else self._mem[address]
        else:
            return self._mem[address]

    def read_word(self, address):
        return self.read_byte(address) + (self.read_byte(address + 1) << 8)

    def read_word_bug(self, address):
        if address % 0x100 == 0xFF:
            return self.read_byte(address) + (self.read_byte(address & 0xFF00) << 8)
        else:
            return self.read_word(address)

    def write_byte2(self, address, value):
        # we don't restrict access to softswitch page $C0
        # note that we will never be able to access a value on $C0 if it is masked by the softswitches

        # TODO: protect certain ram ranges
        if not 0x4000 <= address <= 0x4100:
            self._mem[address] = value

        # special handling for Apple ][ hardware
        if self.use_apple_softswitches:
            if 0xC000 <= address <= 0xCFFF:
                self.apple2.softswitches.write_byte( address, value )
        if self.use_apple_display:
            if 0x400 <= address < 0x800 or 0x2000 <= address < 0x5FFF:
                self.apple2.display.update( address, value )

    def write_byte(self, address, value):
        # we don't restrict access to softswitch page $C0
        # note that we will never be able to access a value on $C0 if it is masked by the softswitches

        # TODO: protect certain ram ranges
        if not (0x2dfd <= address <= 0x2dff) and not (0x4000 <= address <= 0x4100):
            self._mem[address] = value

        # special handling for Apple ][ hardware
        if 0xC000 <= address <= 0xCFFF:
            if self.use_apple_softswitches:
                self.apple2.softswitches.write_byte( address, value )
        elif 0x400 <= address < 0x800 or 0x2000 <= address < 0x5FFF:
            if self.use_apple_display:
                self.apple2.display.update( address, value )
