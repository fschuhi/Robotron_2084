using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Stateless;
using Stateless.Graph;
using Jellyfish.Virtu;
using Jellyfish.Virtu.Services;
using System.Reflection;

namespace Robotron {

    class MachineOperator : IDisposable {

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

        public MainPage _mainPage;
        public Machine _machine;

        public enum State { Started, Running, Pausing, Paused, Terminating, Terminated }
        public enum Trigger { Run, Pause, Join, Unpause, Terminate }

        public readonly StateMachine<State, Trigger> _sm;
        private readonly StateMachine<State, Trigger>.TriggerWithParameters<RunWorkerCompletedEventArgs> _joinTrigger;

        private BackgroundWorker _bw;

        public MachineOperator( MainPage mainPage, Machine machine ) {
            _mainPage = mainPage;
            _machine = machine;
            Debug.Assert( _mainPage.Machine == _machine );

            // we can supply an own key handler which interfaces with our MachineOperator
            VirtuRoCWpfKeyboardService keyboardService = new VirtuRoCWpfKeyboardService( _machine, _mainPage );
            _mainPage.Init( keyboardService );

            // machine doesn't start to run on MainPage loaded, we'll do it in our own handler below
            _mainPage.Loaded += MainPage_loaded;

            _sm = new StateMachine<State, Trigger>( State.Started );

            // Instantiate a new trigger with a parameter. 
            _joinTrigger = _sm.SetTriggerParameters<RunWorkerCompletedEventArgs>( Trigger.Join );

            _sm.Configure( State.Started )
                .Permit( Trigger.Run, State.Running );

            _sm.Configure( State.Running )
                .SubstateOf( State.Started )
                .OnEntry( sm_OnRunning )
                .Permit( Trigger.Pause, State.Pausing )
                .Permit( Trigger.Terminate, State.Terminating );

            _sm.Configure( State.Pausing )
                .SubstateOf( State.Running )
                .Permit( Trigger.Join, State.Paused );

            _sm.Configure( State.Paused )
                .SubstateOf( State.Started )
                .OnEntryFrom( _joinTrigger, sm_OnPaused )
                .Permit( Trigger.Unpause, State.Running )
                .Permit( Trigger.Terminate, State.Terminated );

            _sm.Configure( State.Terminating )
                .SubstateOf( State.Started )
                .Permit( Trigger.Join, State.Terminated );

            _sm.Configure( State.Terminated )
                .OnEntryFrom( _joinTrigger, sm_OnTerminated );

            _bw = new BackgroundWorker {
                WorkerReportsProgress = true,
                WorkerSupportsCancellation = true
            };
            _bw.DoWork += bw_DoWork;
            _bw.ProgressChanged += bw_ProgressChanged;
            _bw.RunWorkerCompleted += bw_RunWorkerCompleted;
        }

        private void MainPage_loaded( object sender, System.Windows.RoutedEventArgs e ) {

            // We now have a WPF message pump in place.

            // make sure we wait until MainPage and its Machine have been created
            WriteMessage( "MainPage loaded, waiting for paused" );

            // Machine starts paused so that we can insert the boot disk
            _machine.StartMachineThread();
            _machine.WaitForPaused();

            // TODO: move load/save state to helper method
            if (Debugger.IsAttached) {
                LoadFromFile( "..\\..\\tmp\\bla.bin" );
            } else {
                LoadFromFile( "tmp\\bla.bin" );
            }

            // afterwards we *must* unpause manually
            WriteMessage( "before first unpause" );
            _machine.Unpause();
        }

        private void sm_OnRunning() {
            WriteMessage( MethodBase.GetCurrentMethod().Name );
            _bw.RunWorkerAsync( "Hello to worker" );
        }

        private void sm_OnPaused( RunWorkerCompletedEventArgs e ) {
            WriteMessage( MethodBase.GetCurrentMethod().Name );
        }

        private void sm_OnTerminated( RunWorkerCompletedEventArgs e ) {
            WriteMessage( MethodBase.GetCurrentMethod().Name );
        }

        public void sm_Run() { _sm.Fire( Trigger.Run ); }
        public void sm_Pause() { _sm.Fire( Trigger.Pause ); }
        public void sm_Unpause() { _sm.Fire( Trigger.Unpause ); }
        public void sm_Stop() { _sm.Fire( Trigger.Terminate ); }

        private void bw_ProgressChanged( object sender, ProgressChangedEventArgs e ) {
            Console.WriteLine( "Reached " + e.ProgressPercentage + "%" );
        }

        private void bw_RunWorkerCompleted( object sender, RunWorkerCompletedEventArgs e ) {

            _sm.Fire( _joinTrigger, e );

            if (e.Cancelled)
                Console.WriteLine( "You canceled!" );
            else if (e.Error != null)
                Console.WriteLine( "Worker exception: " + e.Error.ToString() );
            else
                Console.WriteLine( "Complete: " + e.Result );      // from DoWork
        }

        private void bw_DoWork( object sender, DoWorkEventArgs e ) {
            for (int i = 0; i <= 100; i += 20) {
                if (_bw.CancellationPending) {
                    Console.WriteLine( "CancellationPending" );
                    e.Cancel = true; return;
                }
                _bw.ReportProgress( i );
                Thread.Sleep( 1000 );      // Just for the demo... don't go sleeping
            }                           // for real in pooled threads!

            e.Result = 123;    // This gets passed to RunWorkerCompleted
        }

        public void LoadFromFile( string filename ) {
            Task taskA = new Task( () => {
                WriteMessage( "Task LoadFromFile bla.bin" );
                Thread.CurrentThread.SetApartmentState( ApartmentState.MTA );
                if (Debugger.IsAttached) {
                    _machine.LoadStateFromFile( "..\\..\\tmp\\bla.bin" );
                } else {
                    _machine.LoadStateFromFile( "tmp\\bla.bin" );
                }
            } );
            taskA.Start();
            taskA.Wait();

            // insert waiting for breakpoint pause here
            // 09.07.20 
            // IMPORTANT: This doesn't work without a "completion callback" because we are unable to wait for a Pause anymore - - we are on the main thread.
            // The new mechanism would not wait on a Pause event but would let the BackgroundWorker thread end on which the machine is running.
            // The passed result to the completion-callback can indicate that we encountered a breakpoint.
            // Afterwards the BackgroundWorker is restarted, again going into the main machine event loop.
            // _machine.Memory.SetBreakpoint( 0x4060 );
        }

        private void SaveToBlaBinDuringPauseAfterBreakpoint() {
            Task taskA = new Task( () => {
                Thread.CurrentThread.SetApartmentState( ApartmentState.MTA );
                _machine.SaveStateToFile( "tmp\\bla.bin" );
            } );
            taskA.Start();
            taskA.Wait();

        }

        private void SaveSpriteTable() {
            SpriteTable spriteTable = new SpriteTable( _machine.Memory, 0x7a00 );
            spriteTable.SaveEntriesToFile( "tmp\\entries.csv" );
            spriteTable.SaveStrobesToFile( "tmp\\strobes.csv" );
        }

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
                WriteMessage( "MachineOperator.Dispose() inside" );
            }
            WriteMessage( "MachineOperator.Dispose() outside" );
        }
        #endregion
    }

}
