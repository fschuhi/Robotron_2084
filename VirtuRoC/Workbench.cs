using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using WindowsInput.Native;
using WindowsInput;
using System.Windows.Documents;
using System.Reflection.Emit;
using System.Windows.Media.Media3D;

namespace Robotron {

    class Workbench {

        private MachineOperator _operator;
        private AsmReader _asmReader = new AsmReader( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\Robotron.csv" );
        private bool _runWithBreakpoints;

        private int CurrentRPC { get { return _operator.CurrentRPC; } }

        public Workbench( MachineOperator mop, bool runWithBreakpoints ) {
            _operator = mop;
            _runWithBreakpoints = runWithBreakpoints;

            _operator.OnLoaded += _operator_OnLoaded;
            _operator.OnBreakpoint += _operator_Breakpoint;
            _operator.OnPaused += _operator_OnPaused;

        }

        private int GetAddress( string label ) {
            return _asmReader.AsmLinesByGlobalLabel[label].Address;
        }

        int _doneAtari;
        int _introStory7;
        InputSimulator _sim = new InputSimulator();

        private void _operator_OnLoaded( MachineOperator mop ) {
            _operator.LoadStateFromFile( _operator.BlaBin );

            if (_runWithBreakpoints) {
                _doneAtari = GetAddress( "doneAtari" );
                _introStory7 = GetAddress( "introStory7" );

                _operator.SetBreakpoint( _doneAtari );
                _operator.SetBreakpoint( _introStory7 );

                //_operator.Machine.Cpu.IsThrottled ^= true;
                _operator.Machine.Cpu.IsThrottled = false;
            }
        }

        bool _assignedEvents = false;

        private void _operator_Breakpoint( MachineOperator mop, BreakpointEventArgs e ) {
            Debug.Assert( e.BreakpointRCP == CurrentRPC );
            //MachineOperator.WriteMessage( "es funktioniert tatsächlich - - irre! " + $"break @ PC ${e.BreakpointRCP:X4}" );

            if (e.BreakpointRCP == _doneAtari) {
                _sim.Keyboard.KeyPress( VirtualKeyCode.ESCAPE );
                _operator.mo_Unpause();
            } else if (e.BreakpointRCP == _introStory7) {

                if (! _assignedEvents ) {
                    mop.Machine.Cpu.OnJSR = OnJSR;
                    mop.Machine.Cpu.OnRTS = OnRTS;
                    _assignedEvents = true;
                }

                _operator.ClearBreakpoint( _introStory7 );
                _operator.SetBreakpoint( 0x485c );
                _operator.mo_Unpause();
            }

        }

        List<Tuple<string, int, int>> _calls = new List<Tuple<string, int, int>>();

        private void _operator_OnPaused( MachineOperator mop ) {
            SortedDictionary<int, int> counts = new SortedDictionary<int, int>();

            foreach (Tuple<string, int, int>tuple in _calls ) {
                (string opcode, int opcodeRPC, int rpc) = tuple;
                
                switch (opcode) {
                    case "JSR":
                        Trace.WriteLine( $"${opcodeRPC:X04}: JSR ${rpc:X04}" );
                        Trace.Indent();

                        counts[rpc] = (counts.ContainsKey( rpc ) ? counts[rpc] : 0 ) + 1;
                        break;

                    case "RTS":
                        Trace.Unindent();
                        break;
                }

            }

            foreach (KeyValuePair<int,int> pair in counts) {
                Trace.WriteLine( $"${pair.Key:X04}: {pair.Value}" );
            }

            _calls.Clear();


        }

        private void OnJSR( Cpu cpu ) {
            //Trace.WriteLine( $"${cpu.OpcodeRPC:X04}: JSR ${cpu.RPC:X04}" );
            //Trace.Indent();

            _calls.Add( new Tuple<string, int, int>("JSR", cpu.OpcodeRPC, cpu.RPC) );
        }

        private void OnRTS( Cpu cpu ) {
            // Trace.WriteLine( "RTS" );
            //Trace.Unindent();
            _calls.Add( new Tuple<string, int, int>( "RTS", cpu.OpcodeRPC, cpu.RPC ) );
        }

    }
}
