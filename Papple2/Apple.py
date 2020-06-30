#!/usr/bin/env python3

# Papple is based on ApplePy, see LICENSE

# ApplePy - an Apple ][ emulator in Python
# James Tauber / http://jtauber.com/
# originally written 2001, updated 2011

# https://stackoverflow.com/questions/51464455/why-when-import-pygame-it-prints-the-version-and-welcome-message-how-delete-it
import contextlib
with contextlib.redirect_stdout(None):
    import pygame

import time

import numpy
from Memory import *
from CPU import *

class Display:

    characters = [
        [0b00000, 0b01110, 0b10001, 0b10101, 0b10111, 0b10110, 0b10000, 0b01111],
        [0b00000, 0b00100, 0b01010, 0b10001, 0b10001, 0b11111, 0b10001, 0b10001],
        [0b00000, 0b11110, 0b10001, 0b10001, 0b11110, 0b10001, 0b10001, 0b11110],
        [0b00000, 0b01110, 0b10001, 0b10000, 0b10000, 0b10000, 0b10001, 0b01110],
        [0b00000, 0b11110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b11110],
        [0b00000, 0b11111, 0b10000, 0b10000, 0b11110, 0b10000, 0b10000, 0b11111],
        [0b00000, 0b11111, 0b10000, 0b10000, 0b11110, 0b10000, 0b10000, 0b10000],
        [0b00000, 0b01111, 0b10000, 0b10000, 0b10000, 0b10011, 0b10001, 0b01111],
        [0b00000, 0b10001, 0b10001, 0b10001, 0b11111, 0b10001, 0b10001, 0b10001],
        [0b00000, 0b01110, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b01110],
        [0b00000, 0b00001, 0b00001, 0b00001, 0b00001, 0b00001, 0b10001, 0b01110],
        [0b00000, 0b10001, 0b10010, 0b10100, 0b11000, 0b10100, 0b10010, 0b10001],
        [0b00000, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b11111],
        [0b00000, 0b10001, 0b11011, 0b10101, 0b10101, 0b10001, 0b10001, 0b10001],
        [0b00000, 0b10001, 0b10001, 0b11001, 0b10101, 0b10011, 0b10001, 0b10001],
        [0b00000, 0b01110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110],
        [0b00000, 0b11110, 0b10001, 0b10001, 0b11110, 0b10000, 0b10000, 0b10000],
        [0b00000, 0b01110, 0b10001, 0b10001, 0b10001, 0b10101, 0b10010, 0b01101],
        [0b00000, 0b11110, 0b10001, 0b10001, 0b11110, 0b10100, 0b10010, 0b10001],
        [0b00000, 0b01110, 0b10001, 0b10000, 0b01110, 0b00001, 0b10001, 0b01110],
        [0b00000, 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100],
        [0b00000, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110],
        [0b00000, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01010, 0b00100],
        [0b00000, 0b10001, 0b10001, 0b10001, 0b10101, 0b10101, 0b11011, 0b10001],
        [0b00000, 0b10001, 0b10001, 0b01010, 0b00100, 0b01010, 0b10001, 0b10001],
        [0b00000, 0b10001, 0b10001, 0b01010, 0b00100, 0b00100, 0b00100, 0b00100],
        [0b00000, 0b11111, 0b00001, 0b00010, 0b00100, 0b01000, 0b10000, 0b11111],
        [0b00000, 0b11111, 0b11000, 0b11000, 0b11000, 0b11000, 0b11000, 0b11111],
        [0b00000, 0b00000, 0b10000, 0b01000, 0b00100, 0b00010, 0b00001, 0b00000],
        [0b00000, 0b11111, 0b00011, 0b00011, 0b00011, 0b00011, 0b00011, 0b11111],
        [0b00000, 0b00000, 0b00000, 0b00100, 0b01010, 0b10001, 0b00000, 0b00000],
        [0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b11111],
        [0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000],
        [0b00000, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000, 0b00100],
        [0b00000, 0b01010, 0b01010, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000],
        [0b00000, 0b01010, 0b01010, 0b11111, 0b01010, 0b11111, 0b01010, 0b01010],
        [0b00000, 0b00100, 0b01111, 0b10100, 0b01110, 0b00101, 0b11110, 0b00100],
        [0b00000, 0b11000, 0b11001, 0b00010, 0b00100, 0b01000, 0b10011, 0b00011],
        [0b00000, 0b01000, 0b10100, 0b10100, 0b01000, 0b10101, 0b10010, 0b01101],
        [0b00000, 0b00100, 0b00100, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000],
        [0b00000, 0b00100, 0b01000, 0b10000, 0b10000, 0b10000, 0b01000, 0b00100],
        [0b00000, 0b00100, 0b00010, 0b00001, 0b00001, 0b00001, 0b00010, 0b00100],
        [0b00000, 0b00100, 0b10101, 0b01110, 0b00100, 0b01110, 0b10101, 0b00100],
        [0b00000, 0b00000, 0b00100, 0b00100, 0b11111, 0b00100, 0b00100, 0b00000],
        [0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00100, 0b00100, 0b01000],
        [0b00000, 0b00000, 0b00000, 0b00000, 0b11111, 0b00000, 0b00000, 0b00000],
        [0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00100],
        [0b00000, 0b00000, 0b00001, 0b00010, 0b00100, 0b01000, 0b10000, 0b00000],
        [0b00000, 0b01110, 0b10001, 0b10011, 0b10101, 0b11001, 0b10001, 0b01110],
        [0b00000, 0b00100, 0b01100, 0b00100, 0b00100, 0b00100, 0b00100, 0b01110],
        [0b00000, 0b01110, 0b10001, 0b00001, 0b00110, 0b01000, 0b10000, 0b11111],
        [0b00000, 0b11111, 0b00001, 0b00010, 0b00110, 0b00001, 0b10001, 0b01110],
        [0b00000, 0b00010, 0b00110, 0b01010, 0b10010, 0b11111, 0b00010, 0b00010],
        [0b00000, 0b11111, 0b10000, 0b11110, 0b00001, 0b00001, 0b10001, 0b01110],
        [0b00000, 0b00111, 0b01000, 0b10000, 0b11110, 0b10001, 0b10001, 0b01110],
        [0b00000, 0b11111, 0b00001, 0b00010, 0b00100, 0b01000, 0b01000, 0b01000],
        [0b00000, 0b01110, 0b10001, 0b10001, 0b01110, 0b10001, 0b10001, 0b01110],
        [0b00000, 0b01110, 0b10001, 0b10001, 0b01111, 0b00001, 0b00010, 0b11100],
        [0b00000, 0b00000, 0b00000, 0b00100, 0b00000, 0b00100, 0b00000, 0b00000],
        [0b00000, 0b00000, 0b00000, 0b00100, 0b00000, 0b00100, 0b00100, 0b01000],
        [0b00000, 0b00010, 0b00100, 0b01000, 0b10000, 0b01000, 0b00100, 0b00010],
        [0b00000, 0b00000, 0b00000, 0b11111, 0b00000, 0b11111, 0b00000, 0b00000],
        [0b00000, 0b01000, 0b00100, 0b00010, 0b00001, 0b00010, 0b00100, 0b01000],
        [0b00000, 0b01110, 0b10001, 0b00010, 0b00100, 0b00100, 0b00000, 0b00100]
    ]

    lores_colours = [
        (0, 0, 0),  # black
        (208, 0, 48),  # magenta / dark red
        (0, 0, 128),  # dark blue
        (255, 0, 255),  # purple / violet
        (0, 128, 0),  # dark green
        (128, 128, 128),  # gray 1
        (0, 0, 255),  # medium blue / blue
        (96, 160, 255),  # light blue
        (128, 80, 0),  # brown / dark orange
        (255, 128, 0),  # orange
        (192, 192, 192),  # gray 2
        (255, 144, 128),  # pink / light red
        (0, 255, 0),  # light green / green
        (255, 255, 0),  # yellow / light orange
        (64, 255, 144),  # aquamarine / light green
        (255, 255, 255),  # white
    ]

    def __init__( self, apple2, no_display ):
        self.apple2 = apple2
        self.no_display = no_display

        # https://www.pygame.org/wiki/SettingWindowPosition
        import os
        os.environ['SDL_VIDEO_WINDOW_POS'] = "%d,%d" % (800, 400)

        self.mix = False
        self.flash_time = time.time()
        self.flash_on = False
        self.flash_chars = [[0] * 0x400] * 2

        self.page = 1
        self.text = False
        self.colour = False
        self.high_res = True

        if no_display:
            return

        apple_width = 280 * 2
        apple_height = 192 * 2
        if False:
            mem_width = 256 * 2 # bytes per page, each byte is a single pixel
            mem_height = 208 * 2 # pages 0000-CFFF, each page is a single pixel line
        else:
            mem_width = 0
            mem_height = 0
        status_bar_height = 20
        self.screen = pygame.display.set_mode((apple_width + mem_width, max(apple_height, mem_height) + status_bar_height))

        pygame.font.init()
        self.status_font = pygame.font.SysFont("Source Code Pro", 12)
        self.clear_status()

        pygame.display.set_caption("Apple ][")

        # TODO: turn on text
        if False:
            self.init_chars()

    def clear_status(self, flip=True):
        r = pygame.Rect(0,384,560,384+20)
        self.screen.fill((50,50,50), r)
        if flip:
            pygame.display.flip()

    def show_status(self, text, flip=True):
        self.clear_status()
        text = self.status_font.render(text, True, (255,255,255))
        self.screen.blit(text, (0,384))
        if flip:
            pygame.display.flip()

    def init_chars(self):
        self.chargen = []
        for c in self.characters:
            chars = [[pygame.Surface((14, 16)), pygame.Surface((14, 16))],
                     [pygame.Surface((14, 16)), pygame.Surface((14, 16))]]
            for colour in (0, 1):
                hue = (255, 255, 255) if colour else (0, 200, 0)
                for inv in (0, 1):
                    pixels = pygame.PixelArray(chars[colour][inv])
                    off = hue if inv else (0, 0, 0)
                    on = (0, 0, 0) if inv else hue
                    for row in range(8):
                        b = c[row] << 1
                        for col in range(7):
                            bit = (b >> (6 - col)) & 1
                            pixels[2 * col][2 * row] = on if bit else off
                            pixels[2 * col + 1][2 * row] = on if bit else off
                    del pixels
            self.chargen.append(chars)


    def pickle(self, pickler):
        pickler.dump(self.mix)
        pickler.dump(self.flash_time)
        pickler.dump(self.flash_on)
        pickler.dump(self.page)
        pickler.dump(self.text)
        pickler.dump(self.colour)
        pickler.dump(self.high_res)

    def unpickle(self, unpickler):
        self.mix = unpickler.load()
        self.flash_time = unpickler.load()
        self.flash_on = unpickler.load()
        self.page = unpickler.load()
        self.text = unpickler.load()
        self.colour = unpickler.load()
        self.high_res = unpickler.load()


    def txtclr(self):
        self.text = False

    def txtset(self):
        self.text = True
        self.colour = False

    def mixclr(self):
        self.mix = False

    def mixset(self):
        self.mix = True
        self.colour = True

    def lowscr(self):
        self.page = 1

    def hiscr(self):
        self.page = 2

    def lores(self):
        self.high_res = False

    def hires(self):
        self.high_res = True

    def update(self, address, value) -> bool:

        def update_text():
            base = address - start_text
            self.flash_chars[self.page - 1][base] = value
            hi, lo = divmod(base, 0x80)
            row_group, column = divmod(lo, 0x28)
            row = hi + 8 * row_group

            if row_group == 3:
                return

            if self.text or not self.mix or not row < 20:
                mode, ch = divmod(value, 0x40)

                if mode == 0:
                    inv = True
                elif mode == 1:
                    inv = self.flash_on
                else:
                    inv = False

                self.screen.blit(self.chargen[ch][self.colour][inv], (2 * (column * 7), 2 * (row * 8)))
            else:
                pixels = pygame.PixelArray(self.screen)
                if not self.high_res:
                    lower, upper = divmod(value, 0x10)

                    for dx in range(14):
                        for dy in range(8):
                            x = column * 14 + dx
                            y = row * 16 + dy
                            pixels[x][y] = self.lores_colours[upper]
                        for dy in range(8, 16):
                            x = column * 14 + dx
                            y = row * 16 + dy
                            pixels[x][y] = self.lores_colours[lower]
                del pixels

        def update_hires():
            base = address - start_hires
            row8, b = divmod(base, 0x400)
            hi, lo = divmod(b, 0x80)
            row_group, column = divmod(lo, 0x28)
            row = 8 * (hi + 8 * row_group) + row8

            if self.mix and row >= 160:
                return

            if row < 192 and column < 40:

                pixels = pygame.PixelArray(self.screen)
                msb = value // 0x80

                for b in range(7):
                    c = value & (1 << b)
                    xx = (column * 7 + b)
                    x = 2 * xx
                    y = 2 * row

                    if msb:
                        if xx % 2:
                            pixels[x][y] = (0, 0, 0)
                            # orange
                            pixels[x][y] = (255, 192, 0) if c else (0, 0, 0)  # @@@
                            pixels[x + 1][y] = (255, 192, 0) if c else (0, 0, 0)
                        else:
                            # blue
                            pixels[x][y] = (0, 192, 255) if c else (0, 0, 0)
                            pixels[x + 1][y] = (0, 0, 0)
                            pixels[x + 1][y] = (0, 192, 255) if c else (0, 0, 0)  # @@@
                    else:
                        if xx % 2:
                            pixels[x][y] = (0, 0, 0)
                            # green
                            pixels[x][y] = (0, 255, 0) if c else (0, 0, 0)  # @@@
                            pixels[x + 1][y] = (0, 255, 0) if c else (0, 0, 0)
                        else:
                            # violet
                            pixels[x][y] = (255, 0, 255) if c else (0, 0, 0)
                            pixels[x + 1][y] = (0, 0, 0)
                            pixels[x + 1][y] = (255, 0, 255) if c else (0, 0, 0)  # @@@

                    pixels[x][y + 1] = (0, 0, 0)
                    pixels[x + 1][y + 1] = (0, 0, 0)

                del pixels

        if self.page == 1:
            start_text = 0x400
            start_hires = 0x2000
        elif self.page == 2:
            start_text = 0x800
            start_hires = 0x4000
        else:
            assert False

        if self.no_display:
            return

        # ACHTUNG: momentan text komplett ausgeschaltet
        # if start_text <= address <= start_text + 0x3FF:
        # TODO: turn on text
        # update_text()

        if start_hires <= address <= start_hires + 0x1FFF and self.high_res:
            update_hires()


    def refresh_hires(self):
        if self.no_display:
            return

        start_hires = 0x2000 if self.page == 1 else 0x4000
        for address in range(start_hires, start_hires + 0x2000):
            value = self.apple2.memory._mem[address]
            self.update(address,value)
        pygame.display.flip()


    def flash(self):
        if self.no_display:
            return

        if time.time() - self.flash_time >= 0.5:
            self.flash_on = not self.flash_on
            for offset, char in enumerate(self.flash_chars[self.page - 1]):
                if (char & 0xC0) == 0x40:
                    self.update(0x400 + offset, char)
            self.flash_time = time.time()


    def save_hires_bytes( self, fn ):
        with open(fn, 'wb') as f:
            start_hires = 0x2000 if self.page == 1 else 0x4000
            end_hires = start_hires + 0x2000
            bytes = self.apple2.memory._mem[start_hires:end_hires]
            pickle.dump(bytes, f)

    def load_hires_bytes( self, fn ):
        with open(fn, 'rb') as f:
            start_hires = 0x2000 if self.page == 1 else 0x4000
            end_hires = start_hires + 0x2000
            bytes = pickle.load(f)
            self.apple2.memory._mem[start_hires:end_hires] = bytes
        self.refresh_hires()

    def save_hires_image(self, fn):
        self.refresh_hires()
        import re
        if not re.search('\.(png|jpg) *$', fn.lower()):
            fn = fn.strip() + '.png'
        print(fn)
        pygame.image.save(self.screen, fn)

    def clear_hires(self):
        start_hires = 0x2000 if self.page == 1 else 0x4000
        end_hires = start_hires + 0x2000
        self.apple2.memory._mem[start_hires:end_hires] = 0x2000 * [0x00]


class Speaker:

    CPU_CYCLES_PER_SAMPLE = 60
    CHECK_INTERVAL = 1000

    def __init__(self, quiet):
        self.quiet = quiet
        self.last_toggle = None
        self.buffer = []
        self.polarity = False
        self.reset()

    def pickle(self, pickler):
        pickler.dump(self.quiet)
        pickler.dump(self.last_toggle)
        pickler.dump(self.buffer)
        pickler.dump(self.polarity)

    def unpickle(self, unpickler):
        self.quiet = unpickler.load()
        self.last_toggle = unpickler.load()
        self.buffer = unpickler.load()
        self.polarity = unpickler.load()

    def toggle(self, cycle):
        if not self.quiet:
            if self.last_toggle is not None:
                l = (cycle - self.last_toggle) / Speaker.CPU_CYCLES_PER_SAMPLE
                # https://youtu.be/EhK5JNx0irA?t=1329
                # ACHTUNG: missing speaker toggle, keine Ahnung was er da mit buffer.extend() macht
                # self.buffer.extend([0, 26000] if self.polarity else [0, -2600])
                # self.buffer.extend((l - 2) * [16384] if self.polarity else [-16384])
                self.polarity = not self.polarity
            self.last_toggle = cycle

    def reset(self):
        self.last_toggle = None
        self.buffer = []
        self.polarity = False

    def play(self):
        if not self.quiet:
            sample_array = numpy.int16(self.buffer)
            sound = pygame.sndarray.make_sound(sample_array)
            sound.play()
            self.reset()

    def update(self, cycle):
        if self.buffer and (cycle - self.last_toggle) > self.CHECK_INTERVAL:
            self.play()


class SoftSwitches:

    def __init__(self, display: Display, speaker: Speaker):
        self.kbd = 0x00
        self.display = display
        self.speaker = speaker

    def pickle(self, pickler):
        pickler.dump(self.kbd)

    def unpickle(self, unpickler):
        self.kbd = unpickler.load()

    def read_byte(self, address):
        assert 0xC000 <= address <= 0xCFFF
        if address == 0xC000:
            return self.kbd
        elif address == 0xC010:
            # "clearing the keyboard strobe"
            self.kbd &= 0x7F
        elif address == 0xC030:
            # TODO: speaker cycle missing 05.03.19
            cycle = 0
            self.speaker.toggle(cycle)
        elif address == 0xC050:
            self.display.txtclr()
        elif address == 0xC051:
            self.display.txtset()
        elif address == 0xC052:
            self.display.mixclr()
        elif address == 0xC053:
            self.display.mixset()
        elif address == 0xC054:
            self.display.lowscr()
        elif address == 0xC055:
            self.display.hiscr()
        elif address == 0xC056:
            self.display.lores()
        elif address == 0xC057:
            self.display.hires()
        elif address == 0xC060:
            # no cassette support anymore
            pass
        else:
            pass  # print "%04X" % address
        return 0x00

    def write_byte(self, address, value):
        # disregard value - - softswitches is ROM
        self.read_byte(address)


class Apple2:

    def __init__(self, no_display=False, quiet=True, frame_rate=20):
        pygame.mixer.pre_init(11025, -16, 1)
        pygame.init()

        self.display = Display(self, no_display)
        self.speaker = Speaker(quiet)
        self.softswitches = SoftSwitches(self.display, self.speaker)

        self.memory = Memory(self)
        self.memory.load_image(0xD000, r'bin\A2ROM.BIN')
        self.cpu = CPU(self.memory, program_counter=None)

    def pickle(self, pickler):
        self.memory.pickle(pickler)
        self.cpu.pickle(pickler)
        self.display.pickle(pickler)
        self.speaker.pickle(pickler)
        self.softswitches.pickle(pickler)

    def unpickle(self, unpickler):
        self.memory.unpickle(unpickler)
        self.cpu.unpickle(unpickler)
        self.display.unpickle(unpickler)
        self.speaker.unpickle(unpickler)
        self.softswitches.unpickle(unpickler)


def determine_states_from_kmods():
    mods = pygame.key.get_mods()
    if mods & pygame.KMOD_SHIFT:
        states = 200
    elif mods & pygame.KMOD_CTRL:
        states = 20
    elif mods & pygame.KMOD_ALT:
        states = 1
    else:
        states = 2000
    return states
