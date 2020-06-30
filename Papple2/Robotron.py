#!/usr/bin/env python

from RobotronXl import *
from Assembler import *
from pysm import State, StateMachine, Event

def dump_stretches( workbench: Workbench ):

    tf = workbench.tile_factory
    ann = workbench.annotations

    # start w/ all tiles marked as being a head of an ensemble of linked (consecutive) tiles
    heads = tf.collect_heads( )  # type: [Tile]

    # dump info on all stretches
    for head in heads:
        tiles = tf.pull_tiles( head )
        stretch = Stretch( tf, tiles )
        address = stretch.first_info().address
        print( stretch.verbose_tiles( ) )
        for info in stretch.all_infos():
            ann.add(info.address, "stretch", hexaddr(address))
            ann.add(info.address, "compact", stretch.is_compact())
    print( )

    # chromatix01 (formerly known as closed03)
    tiles = tf.pull_address_tiles( 0x51d9 )
    stretch = Stretch( tf, tiles )
    print( stretch.first_tile( ).is_head )
    print( stretch.verbose_tiles( ) )
    print( stretch.is_compact( ) )
    print( stretch.is_shallow( ) )


def dump_spidered(spidered):
    for line in spidered:
        [address, bytes, mnemonic, operand] = line
        print(hexaddr(address), hexbytes(bytes), mnemonic, operand)
    print()


def spider( workbench: Workbench, params: [str] ):
    start_address = int(params[0], 16) if params else 0x4542
    start_info = workbench.emulator.memory.get(start_address)

    spidered = workbench.simulate_execution( start_info )
    dump_spidered(spidered)


def zero_counts(workbench: Workbench, params: [str] ):
    workbench.add_simulated_execution_paths()


class Stepper:

    def __init__(self, apple2: Apple2):
        self.apple2 = apple2
        self.mem = apple2.memory._mem
        self.cpu = apple2.cpu
        self.asm = Assembler()

    def compile(self, program):
        tokens = self.asm.tokenize( program, verbose=False )
        code = self.asm.generate_code( tokens, verbose=False )
        return self.asm.to_byte_array( code )

    def run_stepper(self):
        line = """
            $5108  84 fc   printChar      STY  $fc
            $510a  84 fe                  STY  $fe
            $510c  a0 40                  LDY  #$40
            $510e  84 09                  STY  $09
            $5110  38                     SEC
            $5111  e9 20                  SBC  #$20
            $5113  0a                     ASL
            $5114  0a                     ASL
            $5115  0a                     ASL
            $5116  26 09                  ROL  $09
            $5118  85 08                  STA  $08
            $511a  a0 07                  LDY  #$07
        """

        self.mem[0x08] = 0
        self.mem[0x09] = 0
        self.cpu.A = ord('R')
        self.cpu.Y = 30
        self.cpu.X = 5

        self.cpu.PC = 0x5108
        while self.cpu.PC < 0x511a:
            self.cpu.do_next_step()
            if self.cpu.PC == 0x510c:
                fdfe = self.get_indirect_address(0xfc)
                feff = self.get_indirect_address(0xfe)
                print('%s, %s' % (hexaddr(fdfe), hexaddr(feff)))

        print(hexaddr(self.get_indirect_address(0x08)))

        line = """
            $511c  b1 fc   L511c          LDA  ($fc),Y
            $511e  8d 29 51               STA  $5129
            $5121  b1 fe                  LDA  ($fe),Y
            $5123  8d 2a 51               STA  $512a
            $5126  b1 08                  LDA  ($08),Y
            $5128  9d 00 29               STA  $2900,X
            $512b  88                     DEY
            $512c  10 ee                  BPL  L511c
        """

        patterns = []
        while self.cpu.PC <= 0x512c:
            self.cpu.do_next_step()
            if self.cpu.PC == 0x5128:
                line_byte = self.cpu.A
                pattern = '{0:b}'.format(line_byte).zfill(8).replace('0', '.').replace('1', '#')
                patterns.append( pattern )

        for pattern in reversed(patterns):
            print(pattern)


    def get_address(self, addr_lo, addr_hi = None):
        if addr_hi is None:
            addr_hi = addr_lo + 1
        return (addr_hi << 8) + addr_lo

    def get_indirect_address(self, addr_lo, addr_hi = None):
        if addr_hi is None:
            addr_hi = addr_lo + 1
        return (self.mem[addr_hi] << 8) + self.mem[addr_lo]

    def get_line_y_base_addr(self, line_y):
        # https://www.xtof.info/blog/?p=768
        # https://en.wikipedia.org/wiki/Apple_II_graphics#High-Resolution_.28Hi-Res.29_graphics
        line_addr_lo = self.mem[0x1200 + line_y]
        line_addr_hi = self.mem[0x1300 + line_y]
        return self.get_address(line_addr_lo, line_addr_hi)

    def get_char(self, char):
        base = 0x8000 + (ord(char) - 0x20) * 8
        return self.mem[base:base+8]

    def print_char(self, char, char_x, line_y):
        # TODO: use selector
        # TODO: https://github.com/Pixinn/Rgb2Hires (in C++, port to Python)
        char = char.upper()
        char_bytes = self.get_char(char)
        for line_index, char_byte in enumerate(char_bytes):
            line_addr = self.get_line_y_base_addr(line_y + line_index)
            self.mem[line_addr + char_x] = char_bytes[line_index]

    def print_string(self, string, char_x, line_y):
        for char_index, char in enumerate(string):
            self.print_char(char, char_x + char_index, line_y )

    def clear_screen(self):
        for index in range(0x2000, 0x4000):
            self.mem[index] = 0x00

    def run(self):
        self.run_stepper()
        self.clear_screen()
        for index, char_y in enumerate(range(15,20)):
            line_y = char_y * 8
            self.print_string("Hi 6502.org", 5 + index, line_y)
        self.apple2.display.refresh_hires()


def dump_chars(workbench: Workbench, params: [str] ):

    stepper = Stepper(workbench.emulator.apple2)
    stepper.run()

    if False:
        print("start")
        for i in range(0,10000):
            emulator.apple2.display.update(2000, 0xff)
        print("stop")

    import time
    time.sleep(0.5)


def get_arguments():
    import argparse
    parser = argparse.ArgumentParser()

    parser.add_argument('--run', help='run a particular Robotron function (after event loop)', type=str, nargs='+')
    parser.add_argument('--load', help='load Robotron.dat', action='store_true')
    parser.add_argument('--save', help='save Robotron.dat after stopping', action='store_true')
    parser.add_argument('--savemem', help='save collected mem access after stopping', action='store_true')
    parser.add_argument('--timemachine', help='enable time machine', action='store_true')
    parser.add_argument('--exit', help='exit immediately after (loading and) starting, i.e. no event loop', action='store_true')
    parser.add_argument('--cycles', help='generate call tree with cycles ruler', action='store_true')
    parser.add_argument('--format', help='dot output format', default='png', choices=['png','jpg','pdf','svg'])
    parser.add_argument('--showtrace', help='automatically show the call tree after generation', action='store_true')
    parser.add_argument('--noresults', help='suppress writing asm/map/dot', action='store_true')
    parser.add_argument('--nodisplay', help='do not show pygame display', action='store_true')
    parser.add_argument('--simulate', help='simulate execution', action='store_true')

    return parser.parse_args()


if __name__ == "__main__":

    args = get_arguments()

    # TODO: think about passing path to emulator - - really needed? or just use current?
    # path = "s:\\Apple II\\Python\\Papple"
    # path = "s:\\source\\Python\\Papple2"
    path = "."
    show_window = (not args.exit) and (not args.nodisplay)

    mem_access = args.savemem

    # timemachine wrecks stretches (bzw. vermutlich tiles)
    # TODO: have stretches even when using timemachine
    time_machine = args.timemachine
    determine_stretches = not time_machine

    start_emulator( path, show_window, time_machine=time_machine, mem_access=mem_access )

    from RobotronXl import workbench, emulator

    if args.load:
        load_state(r'trace\Robotron.dat')

    event_loop = not args.exit
    simulate_execution = args.simulate
    continue_robotron(event_loop, simulate_execution, determine_stretches)

    # ($fc) is low byte
    # ($fe) is high byte
    base_lo = 0x1200
    base_hi = 0x1300

    # ($08) is ascii table, $09=#$40

    if args.run:
        func = args.run[0]
        params = args.run[1:]
        if func in locals():
            locals()[func](workbench, params)
        else:
            print("cannot find '%s'" % func )

    if args.save:
        save_state(r'trace\Robotron.dat')

    if not args.noresults:
        save_results( args.format, args.cycles, args.showtrace )

    if args.savemem:
        fn = r'dat\test.dat'
        with open(fn, 'wb') as output:
            pickle.dump( emulator.mem_access.memory_states, output )

