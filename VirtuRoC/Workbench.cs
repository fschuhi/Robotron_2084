using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Robotron {

    class Workbench {

        private MachineOperator _operator;

        private int CurrentRPC { get { return _operator.CurrentRPC; } }

        public Workbench( MachineOperator mop ) {
            _operator = mop;

            _operator.OnLoaded += _operator_OnLoaded;
            _operator.OnBreakpoint += _operator_Breakpoint;

        }

        private void _operator_OnLoaded( MachineOperator mop ) {
            _operator.LoadStateFromFile( _operator.BlaBin );
            _operator.SetBreakpoint( 0x4060 );
        }

        private void _operator_Breakpoint( MachineOperator mop, BreakpointEventArgs e ) {
            Debug.Assert( e.BreakpointRCP == CurrentRPC );
            MachineOperator.WriteMessage( "es funktioniert tatsächlich - - irre! " + $"break @ PC ${e.BreakpointRCP:X4}" );
            //_operator.ClearBreakpoint( 0x4c36 );
        }

    }
}
