#!/usr/bin/env python

import ctypes  # An included library with Python install.
import itertools

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    # https://stackoverflow.com/questions/312443/how-do-you-split-a-list-into-evenly-sized-chunks
    for i in range(0, len(l), n):
        yield l[i:i + n]

def signed(x):
    if x > 0x7F:
        x -= 0x100
    return x


def group(iterable):
    "s -> (s0,s1), (s2,s3), (s4, s5), ..."
    # https://stackoverflow.com/questions/5389507/iterating-over-every-two-elements-in-a-list
    a = iter(iterable)
    return zip(a, a)


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = itertools.tee(iterable)
    next(b, None)
    return zip(a, b)


def verbose_info(info):
    return hexaddr(info.address)


def verbose_enum(enum):
    return "none" if enum is None else str(enum).split(".", 1)[1]


def verbose_address_set(s):
    if s is None:
        return ""
    else:
        addresses = map(hexaddr, sorted(s))
        return " ".join(addresses)

def verbose_address_list(l):
    if l is None:
        return ""
    else:
        addresses = map(hexaddr, sorted(l))
        return " ".join(addresses)


def hex2int(hex) -> int:
    hex = hex if hex[:1] != "$" else hex[1:]
    return int(hex, 16)


def hexaddr(address, show_dollar=True, lower=True):
    res = "-" if address is None else ("$" if show_dollar else "") + hex(address)[2:].zfill(4)
    return res.lower() if lower else res.upper()


def hexbyte(address, lower=True):
    res = "-" if address is None else hex(address)[2:].zfill(2)
    return res if lower else res.upper()

def hexbytes(bytes):
    return list(map(lambda b: hexbyte(b), bytes))


def msgbox(text):
    ctypes.windll.user32.MessageBoxW(0, str(text), "msgbox", 1)


def dot_RGB( R, G, B ):
    # https://www.graphviz.org/doc/info/attrs.html#k:color
    return '"#%02x%02x%02x"' % (R, G, B)

def Ascii2Apple2Ascii(char):
    if isinstance(char, str): char = ord(char)
    return 0x80 + (char & 0x7F)

def Apple2Ascii2Ascii(char):
    return char & 0x7F

def lerp_rgb(a, b, t):
    return (
        a[0] + (b[0] - a[0]) * t,
        a[1] + (b[1] - a[1]) * t,
        a[2] + (b[2] - a[2]) * t,
    )
