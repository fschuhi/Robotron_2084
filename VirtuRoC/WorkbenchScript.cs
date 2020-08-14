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

    class WorkbenchScript : RobotronObject {

        protected Workbench _workbench;
        protected MachineOperator _mo;

        public WorkbenchScript( Workbench workbench ) {
            _workbench = workbench;
            _mo = _workbench._mo;
            _logOutput = File.AppendText( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\out.log" );
        }

        public string SafeGetLabel( int addr ) {
            return _workbench.AsmService.SafeGetLabel( addr );
        }

        public int GetAddress( string label ) {
            return _workbench.AsmService.GetAddress( label );
        }

        int _logIndent = 0;
        StreamWriter _logOutput;

        protected void WriteLog( string message ) { _logOutput.WriteLine( new String( ' ', _logIndent * 4 ) + message ); }
        protected void IndentLog() { _logIndent++; }
        protected void UnindentLog() { _logIndent = _logIndent == 0 ? 0 : _logIndent - 1; }
        protected void FlushLog() { _logOutput.Flush(); }
        protected void CloseLog() { _logOutput.Close(); }

    }


    class WorkbenchScript1 : WorkbenchScript {

        private enum State { Idle, WaitForDoneAtari, DoneAtari, IntroStory7, YouDrawn }
        private enum Trigger { Start, Breakpoint }
        private StateMachine<State, Trigger>.TriggerWithParameters<PausedEventArgs> _breakpointTrigger;
        private StateMachine<State, Trigger> _sm;

        StackTracker _stackTracker;

        public WorkbenchScript1( Workbench workbench ) : base( workbench ) { 
            TraceLine( "WorkbenchScript1" );
            _mo.LoadStateFromFile( _mo.BlaBin );
            _stackTracker = new StackTracker( _workbench );
            ConfigureStatemachine();
            _sm.Fire( Trigger.Start );
        }

        public void TearDown( MachineOperator mo ) {
            MachineOperator.WriteMessage( "WorkbenchScript: mo_OnClosing" );
            CloseLog();
        }

        public void mo_OnPause( MachineOperator mo, PausedEventArgs e ) {
            FlushLog();

            _mo.MainPage.StateText = SafeGetLabel( e.BreakpointRCP );

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

        InputSimulator _sim;
        List<Tuple<string, int, int>> _calls = new List<Tuple<string, int, int>>();

        private void ConfigureStatemachine() {
            _sm = new StateMachine<State, Trigger>( State.Idle );

            _breakpointTrigger = _sm.SetTriggerParameters<PausedEventArgs>( Trigger.Breakpoint );

            _sm.Configure( State.Idle )
                .Permit( Trigger.Start, State.WaitForDoneAtari );

            _sm.Configure( State.WaitForDoneAtari )
                .Permit( Trigger.Breakpoint, State.DoneAtari )
                .OnEntry( () => {
                    TraceLine( "doneAtari" );
                    _mo.SetBreakpoint( GetAddress( "doneAtari" ) );
                    _mo.Machine.Cpu.IsThrottled = ! _workbench._options.Fast;
                } );

            _sm.Configure( State.DoneAtari )
                .Permit( Trigger.Breakpoint, State.IntroStory7 )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _sim = new InputSimulator();

                    // simulated keys must land on the MainPage
                    _mo.MainPage.Focus();
                    if (_workbench._options.CloseOnFirstBreakpoint) {
                        _sim.Keyboard.ModifiedKeyStroke( VirtualKeyCode.LMENU, VirtualKeyCode.F4 );
                    } else {
                        _mo.SetBreakpoint( GetAddress( "introStory7" ) );
                        _sim.Keyboard.KeyPress( VirtualKeyCode.ESCAPE );
                        _mo.mo_Unpause();
                    }
                } );

            _sm.Configure( State.IntroStory7 )
                .Permit( Trigger.Breakpoint, State.YouDrawn )
                .OnEntryFrom( _breakpointTrigger, ( PausedEventArgs e ) => {
                    _mo.Machine.Cpu.OnJSR += ( Cpu cpu ) => AddCall( "JSR", cpu );
                    _mo.Machine.Cpu.OnRTS += ( Cpu cpu ) => AddCall( "RTS", cpu );
                    _stackTracker.StartTracking();
                    _mo.SetBreakpoint( GetAddress( "BP_YouDrawn" ) );
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

            // TODO: check for correct breakpoint, if not then exit script

            SortedDictionary<int, int> counts = new SortedDictionary<int, int>();

            
            foreach (Tuple<string, int, int> tuple in _calls) {
                (string opcode, int opcodeRPC, int rpc) = tuple;

                switch (opcode) {
                    case "JSR":
                        WriteLog( $"{SafeGetLabel(opcodeRPC)}: JSR {SafeGetLabel(rpc)}" );
                        IndentLog();

                        counts[rpc] = (counts.ContainsKey( rpc ) ? counts[rpc] : 0) + 1;
                        break;

                    case "RTS":
                        UnindentLog();
                        break;
                }
            }

            
            foreach (KeyValuePair<int, int> pair in counts) {
                string addr = SafeGetLabel( pair.Key );
                Trace.WriteLine( $"{addr}: {pair.Value}" );
            }
            
            _calls.Clear();

            _stackTracker.DumpStack();
            _stackTracker.DumpJsrInfoList();
            _stackTracker.StopTracking();
        }
    }
}