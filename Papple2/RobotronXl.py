#!/usr/bin/env python

import logging
import pickle
import os

from Excel import *
from Workbench import *
from Emulator import *
from Tiles import *

workbench = None  # type: Workbench
emulator = None  # type: Emulator

def validate_workbench( ):
    if workbench is None:
        raise_error("cannot find the workbench")

def validate_memlog_dialog():
    validate_workbench()
    #if workbench.memlog_dialog is None:
    #    create_memlog_dialog(15)

@xw.func
def start_emulator( path, show_window=True, time_machine=False, mem_access=False ):
    global emulator
    global workbench

    workbench = Workbench(path, show_window, time_machine, mem_access )
    emulator = workbench.emulator

    # TODO: refactor logging
    logging.basicConfig(filename='trace\\Robotron.log', level=logging.DEBUG, format='%(asctime)s %(message)s', datefmt='%d.%m.%Y %H:%M:%S')

    return "started"


@xw.func
def continue_robotron(event_loop=True, simulate_execution=False, determine_stretches=True):
    global emulator # type: Emulator
    with ExcelContext() as XL:
        if event_loop:
            emulator.event_loop()
        if simulate_execution:
            workbench.add_simulated_execution_paths()
        workbench.assign_labels()
        if determine_stretches:
            workbench.determine_stretches()
    return XL.result


@xw.func
def save_results( format='png', cycles_ruler=True, show_trace=False ):
    global emulator
    with ExcelContext() as XL:
        validate_workbench( )
        workbench.save_map(r'trace\map.txt')
        workbench.save_asm(r'trace\asm.txt')
        fnRendered = workbench.save_dot(r'trace\call_tree.dot', format, cycles_ruler )
        if show_trace:
            os.system('start %s' % fnRendered)
    return XL.result


@xw.func
def save_state(fn):
    global emulator  # type: Emulator
    with ExcelContext() as XL:
        validate_workbench( )
        with open(fn, 'wb') as output:
            pickler = pickle.Pickler(output, -1)
            workbench.pickle(pickler)
    return XL.result


@xw.func
def load_state(fn):
    global emulator
    with ExcelContext() as XL:
        validate_workbench( )
        with open(fn, 'rb') as input:
            unpickler = pickle.Unpickler(input)
            workbench.unpickle(unpickler)
            emulator = workbench.emulator
            emulator.apple2.display.refresh_hires()
            emulator.last_ticks = 0
    return XL.result


def safe_get_info(address):
    global emulator  # type: Emulator
    validate_workbench( )
    address = hex2int(address)
    info = emulator.memory_map.get_info(address)
    if info is None:
        raise_error("cannot find address %s" % hexaddr(address))
    return info


def get_attribute_from_info(address, attribute):
    if not isinstance(address, list):
        # address is not coming from an Excel range (which would be cast into a Python list)

        if address is None or address == '':
            return ''
        else:
            # e.g. '$2dfd'
            address = hex2int(address)

            # get descriptor object for the memory location (or None, if none found for address)
            info = emulator.memory_map.get_info(address)

            #  built-in reflection
            return getattr(info, attribute) if info is not None else '?'
    else:
        # we have passed a list of addresses, so return info for all addresses
        result = []

        # flatten the list, from 2D into 1D (we force 2D lists, see below)
        from itertools import chain
        addresses = list(chain.from_iterable(address))

        for address in addresses:
            result.append(get_attribute_from_info(address, attribute))
        return result


@xw.func
@xw.arg('address', ndim=2)   # force 2dim input
@xw.ret(transpose=True)      # input is oriented top-down, not left-right
def get_touch_count(address):

    # some magic for exception handling
    with ExcelContext() as XL:
        XL.result = get_attribute_from_info(address, 'touch_count')
    return XL.result


@xw.func
@xw.arg('address', ndim=2)
@xw.ret(transpose=True)
def get_first_cycles(address):
    with ExcelContext() as XL:
        XL.result = get_attribute_from_info(address, 'first_cycles')
    return XL.result


@xw.func
@xw.arg('address', ndim=2)
@xw.ret(transpose=True)
def get_last_cycles(address):
    with ExcelContext() as XL:
        XL.result = get_attribute_from_info(address, 'last_cycles')
    return XL.result


@xw.func
def get_disassembly():
    with ExcelContext() as XL:
        validate_workbench( )

        lines = []

        # TODO: unify
        ranges = workbench.collect_disassembly_ranges()
        for (start_address, end_address, type) in ranges:
            range_len = end_address-start_address+1

            # suppress byte blocks which would be too long in the listing
            if type == MEM_UNKNOWN and range_len > 2048:
                continue

            lines = lines + workbench.dis.disassemble( start_address, end_address )

        XL.result = lines
    return XL.result

@xw.func
def get_memory_map():
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.collect_map_infos()
    return XL.result

@xw.func
def get_annotations():
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.annotations.as_table()
    return XL.result


@xw.func
def max_cycles():
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.max_cycles()
    return XL.result

@xw.func
def count_mem_accesses():
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.count_mem_accesses()
    return XL.result

@xw.func
def get_mem_access_log(first_cycle, last_cycle):
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.mem_access_log(first_cycle, last_cycle)
    return XL.result

@xw.func
def get_mem_access_counts():
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.access_counts_as_table()
    return XL.result

@xw.func
def get_screen_read_counts(first_cycle, last_cycle):
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.screen_reads_as_table(first_cycle, last_cycle)
    return XL.result

@xw.func
def get_screen_write_counts(first_cycle, last_cycle, ignore_zero):
    with ExcelContext() as XL:
        validate_workbench( )
        XL.result = workbench.emulator.mem_access.screen_writes_as_table(first_cycle, last_cycle, ignore_zero)
    return XL.result


@xw.func
def get_access_colors(access_type, first_cycle, last_cycle, include_stack, only_indirect):
    with ExcelContext() as XL:
        validate_workbench( )
        if first_cycle <= 0: first_cycle = None
        if last_cycle <= 0: last_cycle = None
        XL.result = workbench.emulator.mem_access.mem_access_colors(access_type, first_cycle, last_cycle, include_stack, only_indirect)
    return XL.result

@xw.func
def get_bytes(first_byte, last_byte):
    with ExcelContext() as XL:
        validate_workbench( )
        bytes = []
        for byte in range(first_byte,last_byte):
            bytes.append(emulator.mem[byte])
        XL.result = bytes
    return XL.result

@xw.func
def create_memlog_dialog(window_lines):
    with ExcelContext() as XL:
        validate_workbench( )
        if (workbench.memlog_dialog is None) or (workbench.memlog_dialog.window_lines != window_lines):
            states = workbench.emulator.mem_access.memory_states
            total_lines = len(states)
            workbench.memlog_dialog = MemLogDialog(total_lines, window_lines)
            XL.result = "ok (created)"
        else:
            XL.result = "ok (reused"
    return XL.result

@xw.func
def send_memlog_dialog_event(dlg_event):
    with ExcelContext() as XL:
        validate_workbench( )
        validate_memlog_dialog()
        dlg = workbench.memlog_dialog
        dlg.send_event(dlg_event)
        XL.result = "ok"
    return XL.result


@xw.func
def get_memlog_lines():
    with ExcelContext() as XL:
        validate_workbench( )
        validate_memlog_dialog()
        dlg = workbench.memlog_dialog
        states = workbench.emulator.mem_access.memory_states
        top_cpu_state, _, _ = states[dlg.total_at_top_pos]
        top_cycles, _ = top_cpu_state
        bottom_cpu_state, _, _ = states[dlg.total_at_bottom_pos]
        bottom_cycles, _ = bottom_cpu_state
        XL.result = get_mem_access_log(top_cycles, bottom_cycles)
    return XL.result

@xw.func
def get_memlog_cursor_pos():
    with ExcelContext() as XL:
        validate_workbench( )
        validate_memlog_dialog()
        dlg = workbench.memlog_dialog
        XL.result = dlg.window_cursor_pos
    return XL.result

@xw.func
def find_pc_forward( pc ):
    with ExcelContext() as XL:
        validate_workbench( )
        validate_memlog_dialog()
        dlg = workbench.memlog_dialog
        states = workbench.emulator.mem_access.memory_states
        found = -1
        # TODO: check if total_cursor_pos is at end
        for index, state in enumerate(states[dlg.total_cursor_pos+1:dlg.total_lines]):
            cpu_state, _, _ = state
            _, last_PC = cpu_state
            if last_PC == pc:
                dlg.jump_to_line(dlg.total_cursor_pos+1 + index)
                return "found"
        XL.result = "not found"
    return XL.result

@xw.func
def find_pc_backward( pc ):
    with ExcelContext() as XL:
        validate_workbench( )
        validate_memlog_dialog()
        dlg = workbench.memlog_dialog
        states = workbench.emulator.mem_access.memory_states
        found = -1
        # TODO: check if total_cursor_pos is at beginning
        for index, state in enumerate(list(reversed(states[0:dlg.total_cursor_pos]))):
            cpu_state, _, _ = state
            _, last_PC = cpu_state
            if last_PC == pc:
                dlg.jump_to_line(dlg.total_cursor_pos-1 - index)
                return "found"
        XL.result = "not found"
    return XL.result
