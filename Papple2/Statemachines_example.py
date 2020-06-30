#!/usr/bin/env python

import time
import threading
from pysm import State, StateMachine, Event

# https://github.com/pgularski/pysm

class Statemachine1:
    def __init__(self):
        self.foo = True
        self.init_statemachine()

    def init_statemachine(self):
        self.m = StateMachine('m')
        self.s0 = StateMachine('s0')
        self.s1 = StateMachine('s1')
        self.s2 = StateMachine('s2')
        self.s11 = State('s11')
        self.s21 = StateMachine('s21')
        self.s211 = State('s211')

        m = self.m
        s0 = self.s0
        s1 = self.s1
        s2 = self.s2
        s11 = self.s11
        s21 = self.s21
        s211 = self.s211

        m.add_state(s0, initial=True)
        s0.add_state(s1, initial=True)
        s0.add_state(s2)
        s1.add_state(s11, initial=True)
        s2.add_state(s21, initial=True)
        s21.add_state(s211, initial=True)

        # Internal transitions
        # beziehen events und angehängte actions, die auf den state gehen
        m.add_transition(s0, None, events='i', action=self.action_i)
        s0.add_transition(s1, None, events='j', action=self.action_j)
        s0.add_transition(s2, None, events='k', action=self.action_k)
        s1.add_transition(s11, None, events='h', condition=self.is_foo, action=self.unset_foo)
        s1.add_transition(s11, None, events='n', action=self.action_n)
        s21.add_transition(s211, None, events='m', action=self.action_m)
        s2.add_transition(s21, None, events='l', condition=self.is_foo, action=self.action_l)

        # External transition
        m.add_transition(s0, s211, events='e')
        s0.add_transition(s1, s0, events='d')
        s0.add_transition(s1, s11, events='b')
        s0.add_transition(s1, s1, events='a')
        s0.add_transition(s1, s211, events='f')
        s0.add_transition(s1, s2, events='c')
        s0.add_transition(s2, s11, events='f')
        s0.add_transition(s2, s1, events='c')
        s1.add_transition(s11, s211, events='g')
        s21.add_transition(s211, s0, events='g')
        s21.add_transition(s211, s21, events='d')
        s2.add_transition(s21, s211, events='b')
        s2.add_transition(s21, s21, events='h', condition=self.is_not_foo, action=self.set_foo)

        # Attach enter/exit handlers
        states = [m, s0, s1, s11, s2, s21, s211]
        for state in states:
            state.handlers = {'enter': self.on_enter, 'exit': self.on_exit}

        self.m.initialize()

    def on_enter(self, state, event):
        print('enter state {0}'.format(state.name))

    def on_exit(self, state, event):
        print('exit state {0}'.format(state.name))

    def set_foo(self, state, event):
        global foo
        print('set foo')
        self.foo = True

    def unset_foo(self, state, event):
        global foo
        print('unset foo')
        self.foo = False

    def action_i(self, state, event):
        print('action_i')

    def action_j(self, state, event):
        print('action_j')

    def action_k(self, state, event):
        print('action_k')

    def action_l(self, state, event):
        print('action_l')

    def action_m(self, state, event):
        print('action_m')

    def action_n(self, state, event):
        print('action_n')

    def is_foo(self, state, event):
        return self.foo is True

    def is_not_foo(self, state, event):
        return self.foo is False

    def test(self):
        m = self.m

        assert m.leaf_state == self.s11
        m.dispatch(Event('a'))
        assert m.leaf_state == self.s11
        # This transition toggles state between s11 and s211
        m.dispatch(Event('c'))
        assert m.leaf_state == self.s211
        m.dispatch(Event('b'))
        assert m.leaf_state == self.s211
        m.dispatch(Event('i'))
        assert m.leaf_state == self.s211
        m.dispatch(Event('c'))
        assert m.leaf_state == self.s11
        assert self.foo is True
        m.dispatch(Event('h'))
        assert self.foo is False
        assert m.leaf_state == self.s11
        # Do nothing if foo is False
        m.dispatch(Event('h'))
        assert m.leaf_state == self.s11
        # This transition toggles state between s11 and s211
        m.dispatch(Event('c'))
        assert m.leaf_state == self.s211
        assert self.foo is False
        m.dispatch(Event('h'))
        assert self.foo is True
        assert m.leaf_state == self.s211
        m.dispatch(Event('h'))
        assert m.leaf_state == self.s211


# It's possible to encapsulate all state related behaviour in a state class.
class HeatingState(StateMachine):
    def __init__(self):
        super().__init__('Heating')
        self.toasting = State('Toasting')
        self.baking = State('Baking')
        self.add_state(self.baking, initial=True)
        self.add_state(self.toasting)

    def on_enter(self, state, event):
        oven = event.cargo['source_event'].cargo['oven']
        if not oven.timer.is_alive():
            oven.start_timer()
        print('Heating on')

    def on_exit(self, state, event):
        print('Heating off')

    def register_handlers(self):
        self.handlers = {
            'enter': self.on_enter,
            'exit': self.on_exit,
        }

    def action(self, state, event):
        if event.name == 'bake':
            print("action!!!! we are in state '%s', baking" % (state.name))
        elif event.name == 'bake':
            print("action!!!! we are in state '%s', toasting" % (state.name))
        else:
            print("no idea")


class Oven(object):
    TIMEOUT = 0.1

    def __init__(self):
        self.sm = self._get_state_machine()
        self.timer = threading.Timer(Oven.TIMEOUT, self.on_timeout)

    def _get_state_machine(self):
        oven = StateMachine('Oven')   # composition: Oven not isa StateMachine but contains one, linked below ((KXOQEIF))
        door_closed = StateMachine('Door closed')   # a StateMachine isa State
        door_open = State('Door open')
        heating = HeatingState()
        off = State('Off')

        oven.add_state(door_closed, initial=True)
        oven.add_state(door_open)
        door_closed.add_state(off, initial=True)
        door_closed.add_state(heating)

        # https://pysm.readthedocs.io/en/latest/pysm_module.html
        # So the order of calls on an event is as follows:
        # State’s event handler
        # condition callback
        # # before callback
        # exit handlers
        # action callback
        # enter handlers
        # after callback

        oven.add_transition(door_closed, heating.toasting, events=['toast'], after=heating.action)
        oven.add_transition(door_closed, heating.baking, events=['bake'], after=heating.action)
        oven.add_transition(door_closed, off, events=['off', 'timeout'])
        oven.add_transition(door_closed, door_open, events=['open'])

        # This time, a state behaviour is handled by Oven's methods.
        # ((KXOQEIF))
        door_open.handlers = {
            'enter': self.on_open_enter,
            'exit': self.on_open_exit,
            'close': self.on_door_close
        }

        # https://pysm.readthedocs.io/en/latest/pysm_module.html
        # If using nested state machines (HSM), initialize() has to be called on a root state machine in the hierarchy.
        oven.initialize()
        return oven

    @property
    def state(self):
        return self.sm.leaf_state.name

    def light_on(self):
        print('Light on')

    def light_off(self):
        print('Light off')

    def start_timer(self):
        self.timer.start()

    def bake(self):
        self.sm.dispatch(Event('bake', oven=self))

    def toast(self):
        self.sm.dispatch(Event('toast', oven=self))

    def open_door(self):
        self.sm.dispatch(Event('open', oven=self))

    def close_door(self):
        self.sm.dispatch(Event('close', oven=self))

    def on_timeout(self):
        print('Timeout...')
        self.sm.dispatch(Event('timeout', oven=self))
        self.timer = threading.Timer(Oven.TIMEOUT, self.on_timeout)

    def on_open_enter(self, state, event):
        print('Opening door')
        self.light_on()

    def on_open_exit(self, state, event):
        print('Closing door')
        self.light_off()

    def on_door_close(self, state, event):
        # Transition to a history state
        self.sm.set_previous_leaf_state(event)


def test_oven():
    oven = Oven()
    print(oven.state)
    assert oven.state == 'Off'
    oven.bake()
    print(oven.state)
    assert oven.state == 'Baking'
    oven.open_door()
    print(oven.state)
    assert oven.state == 'Door open'
    oven.close_door()
    print(oven.state)
    assert oven.state == 'Baking'
    time.sleep(0.2)
    print(oven.state)
    assert oven.state == 'Off'


if __name__ == "__main__":

    #foo = Foo()
    #foo.run()

    # sm = Statemachine1()
    # sm.test()
    test_oven()
