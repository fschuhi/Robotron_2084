#!/usr/bin/env python3

from util import *
from MemoryMap import *

TYPE_SEQUENTIAL = 1
TYPE_BRANCH_ALWAYS = 2
TYPE_STRAIGHT_JSR = 4
TYPE_BRANCH_OVER_RTS = 6
TYPE_BRANCH_OVER_JMP = 8
TYPE_SHOWTEXT = 10


class Tile:
    def __init__( self, infos ):
        assert infos is not None and len( infos ) > 0
        self.infos = infos  # type: [OpInfo]
        self.link_prev_type = None
        self.link_next_type = None
        self.link_prev = None  # type: Tile
        self.link_next = None  # type: Tile
        self.is_head = False
        self.is_body = False
        self.is_tail = False

    def verbose( self ):
        return '%s -> %s' % (hexaddr( self.first_info( ).address ), hexaddr( self.last_info( ).address ))

    def first_info( self ) -> OpInfo:
        return self.infos[0]

    def last_info( self ) -> OpInfo:
        return self.infos[-1]

    def index_of( self, address ):
        for index, info in enumerate( self.infos ):  # type: OpInfo
            if info.address == address:
                return index
        return None


class TileFactory:
    def __init__( self, memory_map: MemoryMap ):
        self.memory_map = memory_map  # type: MemoryMap

        # build double-linked list of all tiles
        self.all_tiles = []  # type: [Tile]

        # each instruction (i.e. a MemInfo) is contained in exactly one tile
        self.infos = {}  # type: {int, Tile}


    def init(self, start_address, end_address ):
        self.all_tiles.clear()
        self.infos.clear()

        # build double-linked list of all tiles
        self.create_tiles( start_address, end_address )

        # each instruction (i.e. a MemInfo) is contained in exactly one tile
        self.init_infos_dictionary()

        # link tiles as best as possible
        # method could also be called "link_prev_tiles", because the condition is written from the perspective of the prev tile
        self.link_tiles( self.is_sequential_tile, TYPE_SEQUENTIAL )
        self.link_tiles( self.is_branch_always_tile, TYPE_BRANCH_ALWAYS )
        self.link_tiles( self.is_straight_jsr_tile, TYPE_STRAIGHT_JSR )

        # "stretches" of tiles have heads and tails
        # you can wrap those "stretches" into Stretch decorators
        # NOTE: needs to be called again after manual bridging of tiles
        self.update_heads_and_tails()


    def create_tiles( self, start_address, end_address ):
        address = start_address
        current_tile = []  # type: [OpInfo]
        while address <= end_address:

            info = self.memory_map.get_info( address )  # type: OpInfo

            if info is None:
                # no instruction
                address += 1
                continue

            if info.is_leap():
                # leap instruction concludes the tile i.e. it's part of this tile
                current_tile.append( info )

                # tile completed
                new_tile = Tile( current_tile )
                self.all_tiles.append( new_tile )

                # start new tile: next instruction is the first in the tile
                current_tile = []
            else:
                # instruction is sequentially executed, no leap

                # any instruction can be leaped to
                if info.leaps_from.exist( ):

                    # leaping to this instruction breaks the tile, before the current instruction
                    # afterwards the previous instruction is the last of the previous tile and we now start a new tile...
                    if len( current_tile ) == 0:
                        # ... but we need to have instructions for the tile first
                        pass
                    else:
                        # now we can create the tile and store it
                        new_tile = Tile( current_tile )
                        self.all_tiles.append( new_tile )

                    # in any case (i.e. when there are leaps from somewhere): start new tile, we are the first instruction
                    current_tile = [info]

                else:
                    # no leaping to this instruction from elsewhere
                    # => collect the serial execution instructions, to be wrapped as Tile
                    current_tile.append( info )
            address += info.operand_length + 1


    def init_infos_dictionary(self):
        for tile in self.all_tiles:  # type: Tile
            for info in tile.infos:
                self.infos[info.address] = tile

    ###
    ### helpers
    ###

    def get_tile( self, address ):
        return self.infos[address] if address in self.infos else None

    # TODO: think about dumping towards html, makes more sense for bigger collections (like all Tiles in the TileFactory)
    def dump( self ):
        for tile in self.all_tiles:
            first_info = tile.infos[0]  # type: OpInfo
            last_info = tile.infos[-1]  # type: OpInfo
            print( '%s -> %s' % (hexaddr( first_info.address ), hexaddr( last_info.address )) )

    ###
    ### linking tiles
    ###

    def link_tiles( self, condition, link_type ):
        for (prev_tile, next_tile) in pairwise( self.all_tiles ):  # type: Tile
            prev_info = prev_tile.last_info()  # type: OpInfo
            next_info = next_tile.first_info()  # type: OpInfo
            consecutive = prev_info.address + prev_info.operand_length + 1 == next_info.address
            if consecutive:
                if condition(prev_tile, next_tile, prev_info, next_info ):
                    # next tile was sequentially executed from this tile
                    self.link_consecutive_tiles( prev_tile, next_tile, prev_info, next_info, link_type )

    @staticmethod
    def is_sequential_tile( prev_tile, next_tile, prev_info, next_info ):
        # next tile was sequentially executed from this tile
        return prev_info.next_sequential_info is not None

    @staticmethod
    def is_branch_always_tile( prev_tile, next_tile, prev_info, next_info ):
        if prev_info.is_branch():
            # this is an '+' branch
            # it it were a '0' or '-' branch, it would have been already in the tile

            # TODO: have a central place to manage excemptions from connecting tiles to stretches
            # 0x51b6: SEC/BCS combo
            # 0x5171 is SEC/BCS but it is branched over by 0x5161->0x5173
            return prev_info.address not in [0x51b6]

    @staticmethod
    def is_straight_jsr_tile( prev_tile, next_tile, prev_info, next_info ):
        if prev_info.opcode == JSR:
            for leap_from in next_info.leaps_from.infos:  # type: OpInfo
                if leap_from.opcode == RTS:
                    # intentionally split the double condition
                    # we might have multiple leaps_from, not all of them RTS
                    return leap_from.has_matched_JSR

    @staticmethod
    def link_consecutive_tiles( prev_tile: Tile, next_tile: Tile, prev_info: OpInfo, next_info: OpInfo, link_type ):
        prev_tile.link_next = next_tile
        next_tile.link_prev = prev_tile

        consecutive = prev_info.address + prev_info.operand_length + 1 == next_info.address
        the_link_type = link_type if consecutive else link_type + 1
        prev_tile.link_type = the_link_type
        next_tile.link_type = the_link_type

    def link_tiles_manually( self, prev_address, next_address, link_type ):
        prev_tile = self.get_tile(prev_address)
        next_tile = self.get_tile(next_address)
        if prev_tile is not None and next_tile is not None:
            prev_info = prev_tile.last_info()
            next_info = next_tile.first_info()
            self.link_consecutive_tiles( prev_tile, next_tile, prev_info, next_info, link_type )

    def update_heads_and_tails(self):
        for tile in self.all_tiles:  # type: Tile
            # if tile.link_prev is None and tile.link_next is not None:
            if tile.link_prev is None:
                tile.is_head = True
                tile.is_body = False
                tile.is_tail = False
            elif tile.link_prev is not None and tile.link_next is None:
                tile.is_head = False
                tile.is_body = False
                tile.is_tail = True
            else:
                tile.is_head = False
                tile.is_body = True
                tile.is_tail = True

    ###
    ### collect tiles
    ###

    def collect(self, func):  # type: [Tile]
        return list( filter( func, self.all_tiles ) )

    def collect_heads( self ):  # type: [Tile]
        return self.collect( lambda tile: tile.is_head )

    def collect_tails( self ):  # type: [Tile]
        return self.collect( lambda tile: tile.is_tail )

    @staticmethod
    def pull_tiles( anchor_tile: Tile ):
        assert anchor_tile is not None

        # pull a chain of linked tiles from the factory, using any of the tiles (anchor)

        # chain obviously needs to include the anchor
        tiles = [anchor_tile]

        # go in prev-direction and insert all linked tiles
        tile = anchor_tile
        while tile.link_prev is not None:
            tiles.insert( 0, tile.link_prev )
            tile = tile.link_prev

        # go in next-direction and append all linked tiles
        tile = anchor_tile
        while tile.link_next is not None:
            tiles.append( tile.link_next)
            tile = tile.link_next

        return tiles

    def pull_address_tiles(self, anchor_address):
        anchor_tile = self.get_tile(anchor_address)  # type: Tile
        assert anchor_tile is not None
        return self.pull_tiles(anchor_tile)


class Stretch:
    def __init__( self, tile_factory, tiles ):
        self.tile_factory = tile_factory
        self.memory_map = self.tile_factory.memory_map
        self.tiles = tiles

    def verbose_tiles( self ):
        return list( map( lambda tile: tile.verbose( ), self.tiles ) )

    def first_tile( self ) -> Tile:
        return self.tiles[0] if len( self.tiles ) > 0 else None

    def last_tile( self ) -> Tile:
        return self.tiles[-1] if len( self.tiles ) > 0 else None

    def first_info(self) -> OpInfo:
        return self.first_tile( ).first_info( ) if len( self.tiles ) > 0 else None

    def first_address(self) -> int:
        return self.first_info().address

    def last_info(self) -> OpInfo:
        return self.last_tile( ).last_info( ) if len( self.tiles ) > 0 else None

    def all_infos(self) -> [OpInfo]:
        for tile in self.tiles:
            for info in tile.infos:
                yield info

    def all_leaps(self) -> {OpInfo}:
        for tile in self.tiles:
            for info in tile.infos:
                if info.is_leap():
                    yield info

    def filter_opcode( self, opcode ) -> [OpInfo]:
        infos = self.all_infos()
        return list( filter( lambda info: info.opcode == opcode, infos ) )

    def filter_branches( self ) -> [OpInfo]:
        infos = self.all_infos()
        return list( filter( lambda info: info.is_branch(), infos ) )


    def is_compact( self):
        # "compact" means ending w/ a regular RTS
        if self.last_info().opcode != RTS:
            return False

        # "compact" means only JSR as entry point allowed
        if not self.first_info().leaps_from.has_only_leaps_from_JSR():
            return False

        # "compact" means that we only allow JSR leaps which leap outside the stretch
        # TODO: how does the [:-1] work and what does it mean?
        # if not all( info.leap_type in [None, LeapType.branch] for info in list( self.all_infos( ) )[:-1] ):
        if not all( (not info.is_leap() or info.is_branch() or info.opcode == JSR) for info in list( self.all_infos( ) )[:-1] ):
            return False

        # TODO: "compact" also means no JMP, rtsjump, JSR *into* the stretch
        # TODO: we should also define another type of compactness: we want all branchings starting from the stretch ending in tiles of the stretch
        # TODO: define a stretch condition for JMP (and JSR as well): always leap outside the stretch

        return True

    def is_shallow( self):
        # compactness is necessary condition for shallowness
        if not self.is_compact():
            return False

        # "shallow" means that we don't allow leap
        # if not all( info.leap_type in [None, LeapType.branch] for info in list( self.all_infos( ) )[:-1] ):
        if not all( (not info.is_leap() or info.is_branch()) for info in list( self.all_infos( ) )[:-1] ):
            return False

        return True


class DotCallTree:
    def __init__(self, tile_factory: TileFactory):
        self.tile_factory = tile_factory

        # node_stretches contains all stretches which are shown in the dot
        self.node_stretches = {}

    def add_node_stretch( self, address ) -> Stretch:
        stretch = self.node_stretches.get( address )  # type: Stretch
        if stretch is None:
            stretch = Stretch( self.tile_factory, self.tile_factory.pull_address_tiles( address ) )
            self.node_stretches[address] = stretch
        return stretch

    # represent a MemInfo in a Graphviz node
    def info_to_node( self, info: OpInfo ):
        # TODO: info_to_node doesn't have labels anymore (came via OpInfo)
        return info.label if info.has_label() else info.verbose_node( )


    def collect_arrows_dot( self, stretch: Stretch ):

        arrows = []

        # include origin of arrow
        stretch = self.add_node_stretch( stretch.first_address() )

        # stretches are represented by the first info from the fire tile (head)
        from_stretch_info = stretch.first_info( )
        from_node = self.info_to_node( from_stretch_info )

        for leap_in_stretch_info in stretch.all_leaps():  # type: OpInfo

            if leap_in_stretch_info.is_branch():
                color = dot_RGB( 83, 141, 213 )

            elif leap_in_stretch_info.opcode == JSR:
                color = dot_RGB( 0, 176, 80 )

            elif leap_in_stretch_info.opcode == JMP_absolute:
                color = dot_RGB( 192, 0, 0 )

            elif leap_in_stretch_info.opcode == RTS:
                if leap_in_stretch_info.has_matched_JSR:
                    # do not show regular RTS, only rtsjump
                    continue
                else:
                    color = dot_RGB( 255, 192, 0 )

            else:
                assert False

            if leap_in_stretch_info.leaps_to.exist():
                # an RTS encountered while spidering cannot be resolved
                # for this case that RTS cannot trigger an arrow, because the target stretch is unknown
                # this is a slightly degenerate case where the op is a leap but doesn't show any actual leaps
                # TODO: same situation will arise w/ indirect JMP
                for leap_to_info in leap_in_stretch_info.leaps_to.infos:  # type: OpInfo
                    if leap_to_info.prev_sequential_info == leap_in_stretch_info:
                        # do not show branches not taken
                        pass
                    else:
                        # arrow goes from one stretch (from_node) to stretch which contains the info leaped to (to_node)
                        leap_to_stretch = self.add_node_stretch( leap_to_info.address )  # type: Stretch
                        leap_to_stretch_first_info = leap_to_stretch.first_info( )
                        to_node = self.info_to_node( leap_to_stretch_first_info )
                        arrows.append( '"%s" -> "%s" [color=%s]' % (from_node, to_node, color) )

        return arrows


    def collect_nodes_dot(self):
        nodes = []
        # change the node shapes etc. depending on stretch conditions
        for _, node_stretch in self.node_stretches.items():  # type: Stretch
            node_first_info = node_stretch.first_info( )
            node = self.info_to_node( node_first_info )
            params = 'shape=box' if node_stretch.is_compact() else 'shape=ellipse'
            nodes.append( '"%s" [label="%s (%s)" %s]' % (node, node, node_first_info.execution_count, params) )
        return nodes


    def collect_cycles_ruler( self ):
        # https://stackoverflow.com/questions/15762014/graphviz-keep-node-position-with-dot
        ruler = [
            '{',
            'node [shape=point, color=white]',
            'edge [style=invis]',
            'splines=false',
        ]

        cycles = set()
        for _, node_stretch in self.node_stretches.items():
            first_info = node_stretch.first_tile().first_info()
            first_cycles = first_info.first_cycles
            # print(node_stretch, node_stretch.first_tile().first_info().verbose())
            # assert first_cycles not in cycles
            cycles.add(first_cycles)
        for prev_cycles, next_cycles in pairwise(sorted(cycles)):
            ruler.append( 'n%i -> n%i' % (prev_cycles, next_cycles) )
        ruler.append('}')

        for _, node_stretch in self.node_stretches.items():
            node_first_info = node_stretch.first_tile().first_info()
            ruler.extend([
                "{",
                "rank=same",
                '"%s"' % self.info_to_node(node_first_info),
                "n%i" % node_first_info.first_cycles,
                "}",
            ])

        return ruler


    def generate_dot( self, heads: [Tile], cycles_ruler ):
        dot = [
            'digraph G {',
            'nodesep=0.1',
            'ranksep=0.23',
            'node [fontname=Arial, fontsize=10]',
            'node [margin=0.07 width=0 height=0]',
            'node [color=%s]' % dot_RGB(180,180,180),
            'edge [style=solid, color=black, arrowsize=0.6]',
            'splines=true'
        ]

        # first collect all arrows
        # we do it first because we will have to add the target stretches the heads leap to
        arrows_dot = []
        for head in heads:
            tiles = self.tile_factory.pull_tiles( head )
            stretch = Stretch( self.tile_factory, tiles )
            arrows_dot = arrows_dot + self.collect_arrows_dot(stretch)

        # after doing all branches, we know that we have all nodes (head stretches and the target stretches leaped to)
        nodes_dot = self.collect_nodes_dot()

        # each node stands for the first info of a stretch
        # each info was executed first at some cycles => use this to show the stretches stretched out in time
        cycle_ruler_dot = self.collect_cycles_ruler( ) if cycles_ruler else []

        dot = dot + cycle_ruler_dot + nodes_dot + arrows_dot
        dot.append("}")
        return dot


    def save_dot( self, heads: [Tile], fnDot, format, cycles_ruler ):
        dot_lines = self.generate_dot( heads, cycles_ruler )

        with open( fnDot, "w" ) as text_file:
            print(*dot_lines, sep='\n', file=text_file)

        import os
        os.environ["PATH"] += os.pathsep + r's:\shared\Graphviz\bin'

        from graphviz import render
        fnRendered = render('dot', format, fnDot )
        return fnRendered

