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

namespace Robotron {

    class Workbench {

        private MachineOperator _operator;
        private AsmReader _asmReader = new AsmReader( "tmp\\Robotron.csv" );

        private int CurrentRPC { get { return _operator.CurrentRPC; } }

        public Workbench( MachineOperator mop ) {
            _operator = mop;

            _operator.OnLoaded += _operator_OnLoaded;
            _operator.OnBreakpoint += _operator_Breakpoint;

        }

        private int GetAddress( string label ) {
            return _asmReader.AsmLinesByGlobalLabel[label].Address;
        }

        int _doneAtari;
        int _introStory7;
        InputSimulator _sim = new InputSimulator();

        private void _operator_OnLoaded( MachineOperator mop ) {
            _operator.LoadStateFromFile( _operator.BlaBin );

            _doneAtari = GetAddress( "doneAtari" );
            _introStory7 = GetAddress( "introStory7" );

            _operator.SetBreakpoint( _doneAtari );
            _operator.SetBreakpoint( _introStory7 );

            //_operator.Machine.Cpu.IsThrottled ^= true;
             _operator.Machine.Cpu.IsThrottled = false;
        }

        private void _operator_Breakpoint( MachineOperator mop, BreakpointEventArgs e ) {
            Debug.Assert( e.BreakpointRCP == CurrentRPC );
            //MachineOperator.WriteMessage( "es funktioniert tatsächlich - - irre! " + $"break @ PC ${e.BreakpointRCP:X4}" );

            if (e.BreakpointRCP == _doneAtari) {
                _sim.Keyboard.KeyPress( VirtualKeyCode.ESCAPE );
                _operator.mo_Unpause();
            } else if (e.BreakpointRCP == _introStory7) {

                _operator.ClearBreakpoint( _introStory7 );
                _operator.SetBreakpoint( 0x485c );
                _operator.mo_Unpause();
            }

        }

    }
}
