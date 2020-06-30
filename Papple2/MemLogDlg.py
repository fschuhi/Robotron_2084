#!/usr/bin/env python3

# "window" or "screen"?

from pysm import State, StateMachine, Event

class MemLogDialog(object):
    def __init__( self, total_lines, window_lines ):
        self.total_lines = int(total_lines)
        self.window_lines = int(window_lines)
        assert self.window_lines >= 3
        self.sm = self._get_statemachine()

    def _get_statemachine(self):
        dlg = StateMachine('memlog dialog')
        self.at_top = State('at top')
        self.in_middle = State('in middle')
        self.at_bottom = State('at bottom')

        dlg.add_state(self.at_top, initial=True)
        self.window_cursor_pos = 0
        self.total_cursor_pos = 0
        self.total_at_top_pos = 0
        dlg.add_state(self.in_middle)
        dlg.add_state(self.at_bottom)

        dlg.add_transition(self.at_top, self.in_middle, events=['down_key'], action=self.move_down)
        dlg.add_transition(self.at_bottom, self.in_middle, events=['up_key'], action=self.move_up)

        # higher specificity: external transition, logically overwrites external transition (because it comes first)
        # IMPORTANT: add first, otherwise the up_key/down_key events are always handled by the 2 internal transitions below
        dlg.add_transition(self.in_middle, self.at_top, events=['up_key'], condition=self.is_at_second, action=self.move_up)
        dlg.add_transition(self.in_middle, self.at_bottom, events=['down_key'], condition=self.is_at_second_last, action=self.move_down)

        # lower specificity: internal transition
        dlg.add_transition(self.in_middle, None, events=['up_key'], action=self.move_up)
        dlg.add_transition(self.in_middle, None, events=['down_key'], action=self.move_down)

        dlg.add_transition(self.at_top, None, events=['up_key'], condition=self.has_more_up, action=self.scroll_up )
        dlg.add_transition(self.at_bottom, None, events=['down_key'], condition=self.has_more_down, action=self.scroll_down )

        dlg.initialize()
        return dlg

    @property
    def state(self):
        return self.sm.leaf_state.name

    @property
    def total_at_bottom_pos(self):
        return int(min(self.total_at_top_pos + self.window_lines - 1, self.total_lines - 1))

    # conditions

    def is_at_second(self, state, event):
        return self.window_cursor_pos == 1

    def is_at_second_last(self, state, event):
        return self.window_cursor_pos == self.window_lines - 2

    def has_more_up(self, state, event):
        print("has_more_up", self.total_cursor_pos > 0)
        return self.total_cursor_pos > 0

    def has_more_down(self, state, event):
        print("has_more_down", self.total_cursor_pos < self.total_lines)
        return self.total_cursor_pos < self.total_lines

    # actions

    def move_up(self, state, event):
        print("move_up")
        self.window_cursor_pos -= 1
        self.total_cursor_pos -= 1

    def move_down(self, state, event):
        print("move_down")
        self.window_cursor_pos += 1
        self.total_cursor_pos += 1

    def scroll_up(self, state, event):
        print("scroll_up")
        self.total_cursor_pos -= 1
        self.total_at_top_pos -= 1

    def scroll_down(self, state, event):
        print("scroll_down")
        self.total_cursor_pos += 1
        self.total_at_top_pos += 1

    # dispatch events

    def send_event(self, event):
        self.sm.dispatch(Event(event))

    def post_down_key(self):
        self.send_event('down_key')

    def post_up_key(self):
        self.send_event('up_key')

    # jump

    def jump_to_line(self, total_line):
        assert total_line < self.total_lines
        # on screen?
        if total_line == self.total_cursor_pos:
            # already at right pos
            pass
        elif total_line == self.total_at_top_pos:
            self.window_cursor_pos = 0
            self.sm.state = self.at_top
        elif total_line == self.total_at_bottom_pos:
            self.window_cursor_pos = self.window_lines-1
            self.sm.state = self.at_bottom
        elif self.total_at_top_pos < total_line < self.total_at_bottom_pos:
            self.window_cursor_pos = self.window_cursor_pos + (total_line - self.total_cursor_pos)
            self.sm.state = self.in_middle
        else:
            # not in current window
            # initialize new window w/ jump target at the top of the window
            self.window_cursor_pos = 0
            self.total_at_top_pos = total_line
            self.sm.state = self.at_top

        self.total_cursor_pos = total_line

if __name__ == "__main__":
    dlg = MemLogDialog(10, 5)
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)

    print()
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_up_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)

    print()
    dlg.jump_to_line(0)
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.jump_to_line(3)
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.jump_to_line(4)
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.jump_to_line(5)
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)
    dlg.post_down_key()
    print(dlg.state, dlg.window_cursor_pos, dlg.total_cursor_pos, dlg.total_at_top_pos)


