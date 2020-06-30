#!/usr/bin/env python3

import collections
from util import *

class Annotations:

    def __init__(self):
        self.by_address = {}

    def add(self, address: int, topic: str, value: str):
        if not self.has_address(address):
            self.by_address[address] = {}
        # no problem (actually a feature) that passed values can overwrite existing ones
        self.by_address[address][topic] = value

    def has_address(self, address):
        return address in self.by_address

    def get_annotations( self, address ) -> {}:
        return self.by_address[address] if self.has_address(address) else None

    def get_annotation(self, address, topic):
        # returns None if either the address or the topic for the address is unknown
        annotations = self.by_address[address] if address in self.by_address else None
        if annotations is None:
            return None
        else:
            return annotations[topic] if topic in annotations else None

    def as_table(self):
        lines = [['address', 'tile', 'stretch', 'compact']]
        for address, topics in sorted(self.by_address.items()):
            tile = topics['tile'] if 'tile' in topics else ''
            stretch = topics['stretch'] if 'stretch' in topics else ''
            compact = topics['compact'] if 'compact' in topics else ''
            line = [hexaddr(address), tile, stretch, compact]  # add ... after tile
            lines.append(line)

        return lines