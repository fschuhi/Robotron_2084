using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using WindowsInput.Native;
using WindowsInput;
using Stateless;
using System.IO;
using CommandLine;
using System.Runtime.InteropServices;

namespace Robotron {

    class Workbench {

        public MachineOperator _mo;

        private enum State { Idle, WaitForDoneAtari, DoneAtari, IntroStory7, YouDrawn }
        private enum Trigger { Start, Breakpoint }
        private StateMachine<State, Trigger>.TriggerWithParameters<PausedEventArgs> _breakpointTrigger;
        private StateMachine<State, Trigger> _sm;

        public AsmService AsmService { get; private set; }
        Options _options;
        int _logIndent = 0;
        StreamWriter _logOutput;

        public Workbench( MachineOperator mo, Options options ) {
            _mo = mo;
            _mo.OnLoaded += mo_OnLoaded;
            _mo.OnClosing += mo_OnClosing;
            _options = options;
            AsmService = new AsmService();
        }

        private void mo_OnLoaded( MachineOperator mo ) {
            MachineOperator.WriteMessage( "Workbench: mo_OnLoaded" );
            _logOutput = File.AppendText( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\out.log" );
            _mo.LoadStateFromFile( _mo.BlaBin );
            _mo.OnPaused += mo_OnPause;
            ConfigureStatemachine();
            _sm.Fire( Trigger.Start );
        }

        private void mo_OnClosing( MachineOperator mo ) {
            MachineOperator.WriteMessage( "Workbench: mo_OnClosing" );
            _logOutput.Close();
        }

        private void mo_OnPause( MachineOperator mo, PausedEventArgs e ) {
            _logOutput.Flush();

            _mo.MainPage.StateText = AsmService.SafeGetLabel( e.BreakpointRCP );

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

        private void WriteLog( string message ) {
            _logOutput.WriteLine( new String( ' ', _logIndent*4 ) + message );
        }

        private void IndentLog() {
            _logIndent++;
        }

        private void UnindentLog() {
            _logIndent = _logIndent == 0 ? 0 : _logIndent - 1;
        }

        InputSimulator _sim;
        List<Tuple<string, int, int>> _calls = new List<Tuple<string, int, int>>();
        StackTracker _stackTracker;

        private void ConfigureStatemachine() {
            _sm = new StateMachine<State, Trigger>( State.Idle );

            _breakpointTrigger = _sm.SetTriggerParameters<PausedEventArgs>( Trigger.Breakpoint );

            _sm.Configure( State.Idle )
                .Permit( Trigger.Start, State.WaitForDoneAtari );

            _sm.Configure( State.WaitForDoneAtari )
                .Permit( Trigger.Breakpoint, State.DoneAtari )
                .OnEntry( () => {
                    _mo.SetBreakpoint( AsmService.GetAddress( "doneAtari" ) );
                    _mo.Machine.Cpu.IsThrottled = ! _options.Fast;
                } );

            _sm.Configure( State.DoneAtari )
                .Permit( Trigger.Breakpoint, State.IntroStory7 )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _sim = new InputSimulator();
                    if (_options.CloseOnFirstBreakpoint) {
                        _sim.Keyboard.ModifiedKeyStroke( VirtualKeyCode.LMENU, VirtualKeyCode.F4 );
                    } else {
                        _mo.SetBreakpoint( AsmService.GetAddress( "introStory7" ) );
                        _sim.Keyboard.KeyPress( VirtualKeyCode.ESCAPE );
                        _mo.mo_Unpause();
                    }
                } );

            _sm.Configure( State.IntroStory7 )
                .Permit( Trigger.Breakpoint, State.YouDrawn )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _stackTracker = new StackTracker( this );
                    _mo.Machine.Cpu.OnJSR += ( Cpu cpu ) => AddCall( "JSR", cpu );
                    _mo.Machine.Cpu.OnRTS += ( Cpu cpu ) => AddCall( "RTS", cpu );
                    _mo.SetBreakpoint( AsmService.GetAddress( "BP_YouDrawn" ) );
                    _mo.mo_Unpause();
                } );
 
            _sm.Configure( State.YouDrawn )
                .PermitReentry( Trigger.Breakpoint )
                .OnEntryFrom( _breakpointTrigger, sm_OnEntry_YouDrawn );                
        }


        private void AddCall( string opcode, Cpu cpu ) {
            _calls.Add( new Tuple<string, int, int>( opcode, cpu.OpcodeRPC, cpu.RPC ) );
        }


        private void sm_OnEntry_YouDrawn( PausedEventArgs e ) {
            SortedDictionary<int, int> counts = new SortedDictionary<int, int>();

            foreach (Tuple<string, int, int> tuple in _calls) {
                (string opcode, int opcodeRPC, int rpc) = tuple;

                switch (opcode) {
                    case "JSR":
                        WriteLog( $"{AsmService.SafeGetLabel(opcodeRPC)}: JSR {AsmService.SafeGetLabel(rpc)}" );
                        IndentLog();

                        counts[rpc] = (counts.ContainsKey( rpc ) ? counts[rpc] : 0) + 1;
                        break;

                    case "RTS":
                        UnindentLog();
                        break;
                }
            }

            foreach (KeyValuePair<int, int> pair in counts) {
                string addr = AsmService.SafeGetLabel( pair.Key );
                Trace.WriteLine( $"{addr}: {pair.Value}" );
            }
            _calls.Clear();

            _stackTracker.DumpStack();
            _stackTracker.DumpJsrInfoList();
        }
    }
}