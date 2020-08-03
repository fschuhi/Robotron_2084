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

// TODO: how to use the Asm-Button on the MainPage? Probably an event...

namespace Robotron {

    class Workbench : RobotronObject {

        public MachineOperator _mo;

        public AsmService AsmService { get; private set; }
        public Options _options;
        WorkbenchScript1 _script;
        AsmWindow _win;
        FastColoredTextBox _fctb;

        public Workbench( MachineOperator mo, Options options ) {
            _mo = mo;
            _mo.OnLoaded += mo_OnLoaded;
            _mo.OnClosing += mo_OnClosing;
            _mo.OnPaused += mo_OnPause;
            _options = options;
            AsmService = new AsmService();
        }

        private void mo_OnLoaded( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnLoaded" );

            // 2. then run the form embedded in WPF Window
            // https://www.c-sharpcorner.com/article/adding-winforms-in-wpf/
            _win = new AsmWindow();
            _win.Show();

            _fctb = _win.formAsm.fastColoredTextBox1;

            // go top
            _fctb.Navigate( 1 );

            // needed, otherwise we don't see the caret
            _fctb.Focus();

            // we might want to jump back
            //fctb[100].LastVisit = DateTime.Now;

            _script = new WorkbenchScript1( this );
        }

        private void mo_OnClosing( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnClosing" );
            _script.TearDown( mo );
        }

        private void mo_OnPause( MachineOperator mo, PausedEventArgs e ) {
            _script.mo_OnPause( mo, e );
            
            // TODO: ask AsmService to return the AsmLine for the OpcodeRPC
            // TODO: search string = offset + address => _fctb.find, jump to start of line, then mark complete line (like in the breakpoint example)
        }

    }
}