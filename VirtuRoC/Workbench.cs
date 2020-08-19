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
using FastColoredTextBoxNS;
using System.Windows.Forms;

// TODO: how to use the Asm-Button on the MainPage? Probably an event...

namespace Robotron {

    class Workbench : RobotronObject {

        public MachineOperator _mo;

        public AsmService AsmService { get; private set; }
        public Options _options;
        WorkbenchScript1 _script;

        AsmLinesWindow _window1;

        public Workbench( MachineOperator mo, Options options ) {
            _mo = mo;
            _mo.OnLoaded += mo_OnLoaded;
            _mo.OnClosing += mo_OnClosing;
            _mo.OnPaused += mo_OnPause;
            _options = options;
            AsmService = new AsmService();
        }

        private void DoAction() {
            _window1 = new AsmLinesWindow();
            _window1.Show();
        }

        private void mo_OnLoaded( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnLoaded" );

            _mo.MainPage.AsmAction = DoAction;

            _window1 = new AsmLinesWindow();
            _window1.Show();
            _window1.ScrollToAddress( 0x4000 );

            _script = new WorkbenchScript1( this );
        }

        private void mo_OnClosing( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnClosing" );
            _script.TearDown( mo );
        }

        private void mo_OnPause( MachineOperator mo, PausedEventArgs e ) {
            _script.mo_OnPause( mo, e );

            TraceLine( "opcount", _mo.Machine.Memory.RecordedOperations.Operations.Count );

            _window1.ScrollToAddress( e.BreakpointRCP );

            // TODO: Warum brauchen wir hier auch ein MainPage.Focus() ?
            _mo.MainPage.Focus();
        }

    }
}