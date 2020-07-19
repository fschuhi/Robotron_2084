using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using WindowsInput.Native;
using WindowsInput;
using Stateless;

namespace Robotron {

    class Workbench {

        private MachineOperator _operator;
        private AsmReader _asmReader = new AsmReader( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\Robotron.csv" );

        private enum State { Idle, WaitForDoneAtari, DoneAtari, IntroStory7, YouDrawn }
        private enum Trigger { Start, Breakpoint }
        private StateMachine<State, Trigger>.TriggerWithParameters<PausedEventArgs> _breakpointTrigger;
        private StateMachine<State, Trigger> _sm;

        bool _runWithBreakpoints;

        public Workbench( MachineOperator mop, bool runWithBreakpoints ) {
            _operator = mop;
            _runWithBreakpoints = runWithBreakpoints;
            _operator.OnLoaded += _operator_OnLoaded;
        }

        private void _operator_OnLoaded( MachineOperator mop ) {
            _operator.LoadStateFromFile( _operator.BlaBin );
            if (_runWithBreakpoints) {
                _operator.OnPaused += _operator_OnPaused;
                ConfigureStatemachine();
                _sm.Fire( Trigger.Start );
            }
        }

        private void _operator_OnPaused( MachineOperator mop, PausedEventArgs e ) {
            _operator.MainPage.StateText = GetLabel( e.BreakpointRCP );

            switch (e.PausedReason) {
                case PausedReason.Breakpoint:
                    _sm.Fire( _breakpointTrigger, e );
                    break;
                
                case PausedReason.Keypress:
                    // do nothing
                    // it doesn't help to see a partial log, better execute until next breakpoint
                    break;
            }
        }

        private string GetLabel( int address ) {
            AsmLine line = _asmReader.AsmLinesByAddress[address];
            return line.HasLabel ? line.Label : $"${address:X4}";
        }

        private int GetAddress( string label ) {
            return _asmReader.AsmLinesByGlobalLabel[label].Address;
        }

        InputSimulator _sim;
        List<Tuple<string, int, int>> _calls = new List<Tuple<string, int, int>>();

        private void AddCall( string opcode, Cpu cpu ) {
            _calls.Add( new Tuple<string, int, int>( opcode, cpu.OpcodeRPC, cpu.RPC ) );
        }

        private void ConfigureStatemachine() {
            _sm = new StateMachine<State, Trigger>( State.Idle );

            _breakpointTrigger = _sm.SetTriggerParameters<PausedEventArgs>( Trigger.Breakpoint );

            _sm.Configure( State.Idle )
                .Permit( Trigger.Start, State.WaitForDoneAtari );

            _sm.Configure( State.WaitForDoneAtari )
                .Permit( Trigger.Breakpoint, State.DoneAtari )
                .OnEntry( () => {
                    _operator.SetBreakpoint( GetAddress( "doneAtari" ) );
                    _operator.Machine.Cpu.IsThrottled = false;
                } );

            _sm.Configure( State.DoneAtari )
                .Permit( Trigger.Breakpoint, State.IntroStory7 )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _operator.SetBreakpoint( GetAddress( "introStory7" ) );
                    _sim = new InputSimulator();
                    _sim.Keyboard.KeyPress( VirtualKeyCode.ESCAPE );
                    _operator.mo_Unpause();
                } );

            _sm.Configure( State.IntroStory7 )
               .Permit( Trigger.Breakpoint, State.YouDrawn )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _operator.Machine.Cpu.OnJSR = ( Cpu cpu ) => AddCall( "JSR", cpu );
                    _operator.Machine.Cpu.OnRTS = ( Cpu cpu ) => AddCall( "RTS", cpu );
                    _operator.SetBreakpoint( GetAddress( "BP_YouDrawn" ) );
                    _operator.mo_Unpause();
                } );
 
            _sm.Configure( State.YouDrawn )
                .PermitReentry( Trigger.Breakpoint )
                .OnEntryFrom( _breakpointTrigger, sm_OnEntry_YouDrawn );                
        }


        private void sm_OnEntry_YouDrawn( PausedEventArgs e ) {
            SortedDictionary<int, int> counts = new SortedDictionary<int, int>();

            foreach (Tuple<string, int, int> tuple in _calls) {
                (string opcode, int opcodeRPC, int rpc) = tuple;

                switch (opcode) {
                    case "JSR":
                        Trace.WriteLine( $"{GetLabel(opcodeRPC)}: JSR {GetLabel(rpc)}" );
                        Trace.Indent();

                        counts[rpc] = (counts.ContainsKey( rpc ) ? counts[rpc] : 0) + 1;
                        break;

                    case "RTS":
                        Trace.Unindent();
                        break;
                }
            }

            foreach (KeyValuePair<int, int> pair in counts) {
                Trace.WriteLine( $"${pair.Key:X04}: {pair.Value}" );
            }
            _calls.Clear();
        }
    }
}