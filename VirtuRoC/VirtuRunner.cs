﻿using System.Threading;
using System.Diagnostics;
using System;
using System.Text;
using System.Globalization;
using Jellyfish.Virtu;
using Jellyfish.Virtu.Services;
using System.Windows.Threading;
using VirtuRoC;

namespace bla {

    public class VirtuRunner : IDisposable {

        public MainWindow _showDialogWindow;
        private Thread _thread;
        private Machine _machine;

        #region Dispose
        private bool disposedValue;

        public void Dispose() {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose( disposing: true );
            GC.SuppressFinalize( this );
        }

        protected virtual void Dispose( bool disposing ) {
            if (!disposedValue) {
                if (disposing) {
                    // TODO: dispose managed state (managed objects)
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
                WriteMessage( "inside" );
            }
            WriteMessage( "outside" );
        }
        #endregion

        #region debugging
        private static string FormatMessage( string format, params object[] args ) {
            var message = new StringBuilder( 256 );
            message.AppendFormat( CultureInfo.InvariantCulture, "[{0} T{1:X3} Runner] ", DateTime.Now.ToString( "HH:mm:ss.fff", CultureInfo.InvariantCulture ), Thread.CurrentThread.ManagedThreadId );
            if (args.Length > 0) {
                try {
                    message.AppendFormat( CultureInfo.InvariantCulture, format, args );
                } catch (FormatException ex) {
                    Trace.WriteLine( FormatMessage("[VirtuRunner.FormatMessage] format: {0}; args: {1}; exception: {2}", format, string.Join( ", ", args ), ex.Message ));
                }
            } else {
                message.Append( format );
            }

            return message.ToString();
        }

        public static void WriteMessage( string format, params object[] args ) {
            Trace.WriteLine( FormatMessage( format, args ) );
        }
        #endregion

        public void TestVirtu() {
            WriteMessage( "TestVirtu() enter" );

            // start WPF thread
            AutoResetEvent pageLoadedEvent = new AutoResetEvent( false );
            _thread = new Thread( () => RunShowDialogThread( pageLoadedEvent ) ) { Name = "ShowDialog" };
            _thread.SetApartmentState( ApartmentState.STA );
            _thread.Start();
            WriteMessage( "ShowDialog thread started" );

            // make sure we wait until MainPage and its Machine have been created
            pageLoadedEvent.WaitOne();
            WriteMessage( "MainPage loaded, waiting for paused" );

            // Machine starts paused so that we can insert the boot disk
            _machine.WaitForPaused();
            StorageService.LoadResource( "Disks/Default.dsk", stream => _machine.BootDiskII.BootDrive.InsertDisk( "Default.dsk", stream, false ) );

            // insert waiting for breakpoint pause here
            _machine.Memory.SetBreakpoint( 0x4060 );

            // afterwards we *must* unpause manually
            WriteMessage( "before first unpause" );
            _machine.Unpause();
            WriteMessage( "after first unpause, now WaitForPaused()" );

            // WriteMessage( "before _machine.WaitForPaused()" );
            _machine.WaitForPaused();
            WriteMessage( "after _machine.WaitForPaused(), now calling Unpause" );

            Debug.Assert( _machine.Cpu.RPC == 0x4060 );

            SpriteTable spriteTable = new SpriteTable( _machine.Memory, 0x7a00 );
            spriteTable.SaveEntriesToFile( "tmp\\entries.csv" );
            spriteTable.SaveStrobesToFile( "tmp\\strobes.csv" );

            // _machine.Unpause();

            // leave it to the user to close the WPF MainWindow, which will exit ShowDialog() and and the thread
            WriteMessage( "waiting for join ShowDialog thread" );
            _thread.Join();

            WriteMessage( "TestVirtu() exit" );

            // https://stackoverflow.com/questions/5923767/simple-state-machine-example-in-c
            }


            private void RunShowDialogThread( AutoResetEvent loadedEvent ) {
            WriteMessage( "RunShowDialogThread() enter" );

            // setup window (includes MainPage)
            _showDialogWindow = new MainWindow();

            // MainPage has created a Machine, which will be started as soon as the MainPage is loaded
            // IMPORTANT: MachineThread has not been started yet => we could set up breakpoints here ...
            _machine = _showDialogWindow.GetMainPage().Machine;

            // ... or in the caller after it receives the signal that the page (i.e. its Machine) is loaded
            loadedEvent.Set();

            // display and start message pumping
            // ASSUMPTION: this is where MainPage.Loaded starts the MachineThread, which in turn immediately starts executing 6502
            // TODO: fix Machine startup action (e.g. start paused)
            _showDialogWindow.ShowActivated = true;
            _showDialogWindow.ShowDialog();

            WriteMessage( "ShowDialog exited, shutting down" );

            // prevents that Debugger throws System.Runtime.InteropServices.InvalidComObjectException
            // https://stackoverflow.com/questions/6232867/com-exceptions-on-exit-with-wpf
            Dispatcher.CurrentDispatcher.InvokeShutdown();

            WriteMessage( "shut down (via InvokeShutdown)" );

            _showDialogWindow = null;
            WriteMessage( "RunShowDialogThread() exit" );
        }

    }
}
