#!/usr/bin/env python3

# IMPORTANT: Try to have the MemoryMap as stateless as possible

from Memory import *
from CPU import *

MEM_UNKNOWN = 0
MEM_OPCODE = 1
MEM_OPERAND = 2
MEM_DATA = 3

class Leaps:
    def __init__(self, memory_map):
        self.infos = None  # type: set

    def exist( self ):
        return self.infos is not None

    def add( self, info ):
        if self.infos is None:
            self.infos = set( )
        self.infos.add( info )

    def first( self ):  # type: OpInfo
        # we use type comment here intentionally, not "->" because I want to avoid forward-declaring OpInfo
        return next( iter( self.infos ) )

    def first_address( self ):
        return self.first( ).address

    def count( self ):
        return 0 if self.infos is None else len( self.infos )

    def has_only_leaps_from_JSR(self):
        return False if self.infos is None else all( info.opcode == JSR for info in self.infos )

    def verbose( self, disassembler ):
        if self.infos is None:
            return '?'
        else:
            leaps = []
            for info in sorted( self.infos, key=lambda i: i.address ):
                # TODO: if we remove labels from OpInfo then we need to provide Leaps.verbose() with the labels (via disassembler)
                verbose_info = (info.label) if info.has_label() else hexaddr(info.address)
                (_, mnemonic, _) = disassembler.ops[info.opcode]
                leaps.append("%s (%s)" % (verbose_info, mnemonic))
            return ", ".join(leaps)

    def has_single_leap_from_regular_RTS(self):
        if self.count( ) == 1:
            first_leap_from = self.first( )
            return first_leap_from.opcode == RTS and first_leap_from.has_matched_JSR

    def has_only_leaps_from_branchings( self ):
        return all(info.is_branch() for info in self.infos )


class OpInfo:
    # alternative: https://docs.python.org/2.4/lib/node70.html
    unpickling_memory_map = None  # type: MemoryMap

    def __init__(self, address, memory_map):
        self.address = address
        self.memory_map = memory_map  # type: MemoryMap
        self.first_cycles = None
        self.last_cycles = None
        self.execution_count = None  # >0 on execution path, 0 if manually spidered, None if given in branch but never taken
        self.opcode = None
        self.operand_length = None
        self.label = None
        self.prev_sequential_info = None  # type: OpInfo
        self.next_sequential_info = None  # type: OpInfo

        # outbound jumps
        self.has_matched_JSR = None
        self.branched = None

        self.leaps_from = Leaps(self.memory_map)
        self.leaps_to = Leaps(self.memory_map)

        self.data_after_op = None

    def __getstate__(self):
        state = self.__dict__.copy()
        del state['memory_map']
        return state

    def __setstate__(self, state):
        self.__dict__.update(state)
        self.memory_map = OpInfo.unpickling_memory_map

    def verbose(self):
        return hexaddr(self.address)

    def verbose_node(self):
        return hexaddr(self.address)

    def is_branch(self):
        return self.opcode in [BPL, BMI, BVC, BVS, BCC, BCS, BNE, BEQ]

    def handle_branched(self, branched):
        if branched is None:
            # while spidering (i.e. not on execution path) the passed branched is None
            # we retain the info char, so that user can see what (not) happened while executing
            pass
        elif self.branched is None:
            self.branched = '+' if branched else '-'
        elif self.branched == '0':
            pass
        elif self.branched == '+' and branched:
            pass
        elif self.branched == '-' and not branched:
            pass
        elif self.branched == '+' and not branched:
            self.branched = '0'
        elif self.branched == '-' and branched:
            self.branched = '0'

    def is_leap(self):
        return self.is_branch() or self.opcode in [JSR, RTS, JMP_absolute, JMP_indirect]

    def has_label(self):
        return self.label is not None

    def has_single_leap_from_no_branching(self):
        if self.leaps_from.count() == 1:
            first_leap_from = self.leaps_from.first( )
            if first_leap_from.is_branch() and self.prev_sequential_info is not None:
                return self.prev_sequential_info.is_branch( )


class MemoryMap:
    def __init__(self, memory):
        self.memory = memory  # type: Memory

        # in order to intercept weird calls to operands we must know what is an opcode and what is an operand
        self.types = [MEM_UNKNOWN] * 0x10000

        # MemInfo objects are only created for opcode locations
        self.infos = [None] * 0x10000  # type: [OpInfo]


    def pickle(self, pickler):
        pickler.dump( self.types )
        pickler.dump( self.infos )

    def unpickle(self, unpickler):
        self.types = unpickler.load( )

        # OpInfo points back to this MemoryMap (excluded from the pickle)
        OpInfo.unpickling_memory_map = self
        self.infos = unpickler.load( )


    def is_op(self, address):
        return self.types[address] == MEM_OPCODE


    def get_info(self, address) -> OpInfo:
        return self.infos[address]

    def __safe_get_info( self, address ) -> OpInfo:
        op = self.infos[address]
        if op is None:
            op = OpInfo( address, self )
            self.infos[address] = op
            opcode = self.memory._mem[address]
            op.opcode = opcode
        return op


    def post_op( self, op_address, operand_length, cycles, prev_info: OpInfo ) -> OpInfo:
        # intentionally not using CPU here
        # called from both inside execution path and from instruction spidering

        info = self.__safe_get_info( op_address )

        def update_types():
            # do not allow calling into an operand
            # we only add info objects for memory locations which contain an opcode or which are accessed from opcodes
            # http://forum.6502.org/viewtopic.php?f=3&t=5517
            assert self.types[op_address] != MEM_OPERAND
            assert 0 <= operand_length <= 2
            self.types[op_address] = MEM_OPCODE
            if operand_length >= 1:
                self.types[op_address + 1] = MEM_OPERAND
                if operand_length == 2:
                    self.types[op_address + 2] = MEM_OPERAND

        def update_cycles():
            info.last_cycles = cycles
            if info.first_cycles is None:
                info.first_cycles = cycles

        def link_with_prev():
            if prev_info is not None:
                # we do not allow jumps to self (inifite loop)
                assert prev_info.address != op_address

                is_next_in_memory = info.address == prev_info.address + prev_info.operand_length + 1
                if is_next_in_memory:
                    # OpInfo is adjacent to the prev OpInfo
                    # sequential execution is "unique" (i.e. 2 OpInfo are either sequential or not)
                    # TODO: think about if we really need info about sequential *execution*
                    # if being sequential is enough then we can put this into a function and check it statically
                    info.prev_sequential_info = prev_info
                    prev_info.next_sequential_info = info

        update_types()
        update_cycles()
        info.operand_length = operand_length

        # TODO: cannot MemoryMap.link_with_prev() when using the TimeMachine
        link_with_prev()

        return info


    def register_leap( self, leap_from_info: OpInfo, leap_to_address ):
        # need to intercept leap_to_address == None (from faked RTS and JMP_indirect leaps)
        if leap_to_address is None:
            return None
        else:
            # symmetric from -> to, to <- from
            # we have just executed instruction at leap_from, so the OpInfo exists
            # target leap_to might not yet exist
            leap_to_info = self.__safe_get_info( leap_to_address )
            leap_from_info.leaps_to.add( leap_to_info )
            leap_to_info.leaps_from.add( leap_from_info )
            return leap_to_info

    def register_jmp(self, leap_from_info: OpInfo, leap_to_address: int):
        # TODO: handle indirect jmp
        return self.register_leap( leap_from_info, leap_to_address )

    def register_jsr(self, leap_from_info: OpInfo, leap_to_address: int):
        return self.register_leap( leap_from_info, leap_to_address )

    def register_rts( self, leap_from_info: OpInfo, leap_to_address, matched_jsr ):
        # NOTE: passed leap_to_address / matched_jsr can be None (during spidering)
        # if there is a caller it necessarily is the matching JSR
        # unmatched RTS (e.g. PHA/PHA/RTS constructs) have caller==None
        assert matched_jsr is None or self.get_info( matched_jsr ).opcode == JSR
        leap_to_info = self.register_leap( leap_from_info, leap_to_address )

        if leap_from_info.has_matched_JSR is None:
            leap_from_info.has_matched_JSR = matched_jsr is not None
        else:
            leap_from_info.has_matched_JSR = leap_from_info.has_matched_JSR and matched_jsr is not None

        return leap_to_info

    def register_branch(self, leap_from_info: OpInfo, leap_to_address: int, branched):
        leap_to_info = self.register_leap(leap_from_info, leap_to_address)

        # passed branched is None for spidered instructions => retain the +/- info (never 0)
        leap_from_info.handle_branched(branched)
        return leap_to_info

