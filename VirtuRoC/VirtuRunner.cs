using System.Threading;
using System.Diagnostics;
using System;
using System.Text;
using System.Globalization;
using Jellyfish.Virtu;
using Jellyfish.Virtu.Services;
using System.Windows.Threading;
using System.Windows.Input;
using System.Windows.Forms;
using System.IO;
using System.Threading.Tasks;

// https://github.com/dotnet-state-machine/stateless
// https://www.hanselman.com/blog/Stateless30AStateMachineLibraryForNETCore.aspx

// http://www.albahari.com/threading/part2.aspx

// https://stackoverflow.com/questions/28772886/how-to-call-a-method-on-a-running-thread
// https://stackoverflow.com/questions/530211/creating-a-blocking-queuet-in-net/530228#530228

namespace Robotron {

    public class VirtuRunner : IDisposable {

        private Machine _machine;

        #region debugging
        private static string FormatMessage( string format, params object[] args ) {
            var message = new StringBuilder( 256 );
            message.AppendFormat( CultureInfo.InvariantCulture, "[{0} T{1:X3} Runner] ", DateTime.Now.ToString( "HH:mm:ss.fff", CultureInfo.InvariantCulture ), Thread.CurrentThread.ManagedThreadId );
            if (args.Length > 0) {
                try {
                    message.AppendFormat( CultureInfo.InvariantCulture, format, args );
                } catch (FormatException ex) {
                    Trace.WriteLine( FormatMessage( "[VirtuRunner.FormatMessage] format: {0}; args: {1}; exception: {2}", format, string.Join( ", ", args ), ex.Message ) );
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

            StartDialogThread();

            // StorageService.LoadResource( "Disks/Default.dsk", stream => _machine.BootDiskII.BootDrive.InsertDisk( "Default.dsk", stream, false ) );

            // TODO: move load/save state to helper method
            if (true) {
                Task taskA = new Task( () => {
                    Thread.CurrentThread.SetApartmentState( ApartmentState.MTA );
                    _machine.LoadStateFromFile( "tmp\\bla.bin" );
                } );
                taskA.Start();
                taskA.Wait();
            }

            // TODO: test if breakpoint is set in loaded state
            // TODO: clear all breakpoints here

            // insert waiting for breakpoint pause here
            _machine.Memory.SetBreakpoint( 0x4060 );

            // afterwards we *must* unpause manually
            WriteMessage( "before first unpause" );
            _machine.Unpause();

            WriteMessage( "after first unpause, now WaitForPaused()" );

            // WriteMessage( "before _machine.WaitForPaused()" );
            _machine.WaitForPaused();

            WriteMessage( "after _machine.WaitForPaused(), now calling Unpause" );

            // not necessarily a breakpoint (e.g. if immediately stop startup of machine / Robotron)
            // Debug.Assert( _machine.Cpu.RPC == 0x4060 );

            if (true) {
                Task taskA = new Task( () => {
                    Thread.CurrentThread.SetApartmentState( ApartmentState.MTA );
                    _machine.SaveStateToFile( "tmp\\bla.bin" );
                } );
                taskA.Start();
                taskA.Wait();
            }

            SpriteTable spriteTable = new SpriteTable( _machine.Memory, 0x7a00 );
            spriteTable.SaveEntriesToFile( "tmp\\entries.csv" );
            spriteTable.SaveStrobesToFile( "tmp\\strobes.csv" );

            // _machine.Unpause();

            WaitForDialogThreadEnded();

            WriteMessage( "TestVirtu() exit" );

            // https://stackoverflow.com/questions/5923767/simple-state-machine-example-in-c
        }

        public MainWindow _showDialogWindow;
        private Thread _showDialogThread;
        private AutoResetEvent _pageLoadedEvent = new AutoResetEvent( false );

        #region dialog thread mgmnt
        private void StartDialogThread() {
            // start WPF thread
            _showDialogThread = new Thread( () => RunShowDialogThread( _pageLoadedEvent ) ) { Name = "ShowDialog" };
            _showDialogThread.SetApartmentState( ApartmentState.STA );
            _showDialogThread.Start();
            WriteMessage( "ShowDialog thread started" );

            // make sure we wait until MainPage and its Machine have been created
            _pageLoadedEvent.WaitOne();
            WriteMessage( "MainPage loaded, waiting for paused" );

            // Machine starts paused so that we can insert the boot disk
            _machine.WaitForPaused();
        }

        private void WaitForDialogThreadEnded() {
            // leave it to the user to close the WPF MainWindow, which will exit ShowDialog() and and the thread
            WriteMessage( "waiting for join ShowDialog thread" );
            _showDialogThread.Join();
        }

        private void RunShowDialogThread( AutoResetEvent loadedEvent ) {
            WriteMessage( "RunShowDialogThread() enter" );

            // setup window (includes MainPage)
            _showDialogWindow = new MainWindow();

            // InputLanguage.CurrentInputLanguage.LayoutName = "US";


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
        #endregion

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

    }
}
