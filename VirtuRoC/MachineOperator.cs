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
using Microsoft.Win32;
using AspectInjector.Broker;
using Microsoft.SqlServer.Server;
using System.Windows.Threading;

namespace Robotron {

    #region aspects
    [Aspect( Scope.Global )]
    [Injection( typeof( OnEntry ) )]
    public class OnEntry : Attribute {
        [Advice( Kind.Before )] // you can have also After (async-aware), and Around(Wrap/Instead) kinds
        public void LogEnter( [Argument( Source.Name )] string name ) {
            MachineOperator.WriteMessage( $"OnEntry '{name}'" );   //you can debug it	
        }
    }

    [Aspect( Scope.Global )]
    [Injection( typeof( OnExit ) )]
    public class OnExit : Attribute {
        [Advice( Kind.Before )]
        public void LogEnter( [Argument( Source.Name )] string name ) {
            MachineOperator.WriteMessage( $"OnExit '{name}'" );
        }
    }

#if BLA
    [Aspect( Scope.Global )]
    [Injection( typeof( FireTrigger ) )]
    public class FireTrigger : Attribute {
        [Advice( Kind.Before )]
        public void LogEnter( [Argument( Source.Arguments )] object[] args ) {
            MachineOperator.WriteMessage( $"Trigger '{args[0].ToString()}'" );
        }
    }
#endif
    #endregion

    public class BreakpointEventArgs : EventArgs {
        // was in namespace System.ComponentModel(.ProgressChangedEventArgs)
        public BreakpointEventArgs( int breakpointRPC ) {
            BreakpointRCP = breakpointRPC;
        }

        public int BreakpointRCP { get; private set; }
    }

    public delegate void BreakpointEventHandler( MachineOperator mop, BreakpointEventArgs e );
    public delegate void LoadedEventHandler( MachineOperator mop );

    public class MachineOperator : IDisposable {

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

        public Machine Machine;

        private MainWindow _mainWindow;
        private MainPage _mainPage;

        private AutoResetEvent _resumeEvent = new AutoResetEvent( false );
        private bool _suspending = false;

        public event BreakpointEventHandler OnBreakpoint;
        public event LoadedEventHandler OnLoaded;

        private enum State { Starting, Started, Running, Suspended, Pausing, Paused, Terminating, Terminated }
        private enum Trigger { Start, Suspend, Resume, Pause, Join, Unpause, Terminate }
        private StateMachine<State, Trigger> _sm;
        private StateMachine<State, Trigger>.TriggerWithParameters<RunWorkerCompletedEventArgs> _joinTrigger;

        private BackgroundWorker _bw;

        public MachineOperator() {

            ConfigureWPF();
            ConfigureStatemachine();
            ConfigureBackgroundWorker();
        }

        private void ConfigureWPF() {
            // setup window, including MainPage
            _mainWindow = new MainWindow();
            _mainPage = _mainWindow.GetMainPage();

            // MainPage has created a Machine object, but hasn't done anything with it yet
            Machine = _mainPage.Machine;

            // machine doesn't start to run on MainPage loaded, we'll do it in our own handler below
            _mainPage.Loaded += MainPage_loaded;

            _mainPage.MainWindow.Closing += MainWindow_Closing;

            _mainPage._disk1Button.Click += ( sender, e ) => MainPage_OnDiskButtonClick( 0 );
            _mainPage._disk2Button.Click += ( sender, e ) => MainPage_OnDiskButtonClick( 1 );

            // we can supply an own key handler which interfaces with our MachineOperator
            VirtuRoCWpfKeyboardService keyboardService = new VirtuRoCWpfKeyboardService( this, Machine, _mainPage );
            _mainPage.Init( keyboardService );
        }

        private void ConfigureStatemachine() {

            _sm = new StateMachine<State, Trigger>( State.Starting );

            // Instantiate a new trigger with a parameter. 
            _joinTrigger = _sm.SetTriggerParameters<RunWorkerCompletedEventArgs>( Trigger.Join );

            // always starts in Paused state, to be able to load the state before running, or set breakpoints
            _sm.Configure( State.Starting )
                .Permit( Trigger.Start, State.Paused );

            _sm.Configure( State.Started )
                .OnEntry( sm_OnEntry_Started );

                _sm.Configure( State.Paused )
                    .SubstateOf( State.Started )
                    .OnEntryFrom( _joinTrigger, sm_OnEntry_Paused )
                    .OnExit( sm_OnExit_Paused )
                    .Ignore( Trigger.Pause )
                    .Permit( Trigger.Unpause, State.Running )
                    .Permit( Trigger.Terminate, State.Terminated );

                _sm.Configure( State.Running )
                    .SubstateOf( State.Started )
                    .OnEntry( sm_OnEntry_Running )
                    .Permit( Trigger.Join, State.Paused )
                    .Permit( Trigger.Suspend, State.Suspended )
                    .Permit( Trigger.Pause, State.Pausing )
                    .Permit( Trigger.Terminate, State.Terminating );

                    _sm.Configure( State.Suspended )
                        .SubstateOf( State.Running )
                        .Permit( Trigger.Resume, State.Running )
                        .OnEntry( sm_OnEntry_Suspended )
                        .OnExit( sm_OnExit_Suspended );

                    _sm.Configure( State.Pausing )
                        .SubstateOf( State.Running )
                        .OnEntry( sm_OnStopping )
                        .Permit( Trigger.Join, State.Paused );

                    _sm.Configure( State.Terminating )
                        .SubstateOf( State.Running )
                        .OnEntry( sm_OnStopping )
                        .Permit( Trigger.Join, State.Terminated );

            _sm.Configure( State.Terminated )
                .OnEntryFrom( _joinTrigger, sm_OnEntry_Terminated );

            _sm.OnTransitioned( t => WriteMessage( $"OnTransitioned: {t.Source} -> {t.Destination} via {t.Trigger}({string.Join( ", ", t.Parameters )})" ) );

            string dotGraph = UmlDotGraph.Format( _sm.GetInfo() );
            System.IO.File.WriteAllText( "tmp\\MachineOperator.dot", dotGraph);
        }


        private void ConfigureBackgroundWorker() {
            _bw = new BackgroundWorker {
                WorkerReportsProgress = true,
                WorkerSupportsCancellation = true
            };
            _bw.DoWork += bw_DoWork_OnRunning;
            _bw.ProgressChanged += bw_ProgressChanged;
            _bw.RunWorkerCompleted += bw_RunWorkerCompleted;
        }


        public void ShowDialog() {
            // start message pumping
            _mainWindow.ShowActivated = true;
            _mainWindow.ShowDialog();
            WriteMessage( "ShowDialog exited, shutting down" );
        }


        #region ExecuteMachineTask
        private void ExecuteMachineTask<T>( Action<T> machineAction, T argument ) {
            Task taskA = new Task( () => {
                WriteMessage( $"running on machine: {machineAction.Method.Name}({(argument == null ? "null" : argument.ToString())})" );
                Thread.CurrentThread.SetApartmentState( ApartmentState.MTA );
                machineAction( (T)argument );
            } );
            taskA.Start();
            taskA.Wait();
        }

        public void LoadStateFromFile( string name ) {
            ExecuteMachineTask( Machine.LoadStateFromFile, name );
        }
        #endregion

        public void SetBreakpoint( int breakpoint ) {
            Machine.Memory.SetBreakpoint( breakpoint );
        }

        public void ClearBreakpoint( int breakpoint ) {
            Machine.Memory.ClearBreakpoint( breakpoint );
        }


        #region MainWindow / MainPage events
        private void MainPage_loaded( object sender, System.Windows.RoutedEventArgs e ) {

            // We now have a WPF message pump in place.

            // make sure we wait until MainPage and its Machine have been created
            WriteMessage( "MainPage loaded, waiting for paused" );

            mo_Start();
            Debug.Assert( _sm.IsInState( State.Paused ) );

            OnLoaded( this );

            mo_Unpause();
        }

        private void MainPage_OnDiskButtonClick( int drive ) {
            var dialog = new OpenFileDialog() { Filter = "Disk Files (*.dsk;*.nib;*.2mg;*.po;*.do)|*.dsk;*.nib;*.2mg;*.po;*.do|All Files (*.*)|*.*" };
            bool? result = dialog.ShowDialog();
            if (result.HasValue && result.Value) {
                // Machine.Pause();
                mo_Suspend();

                StorageService.LoadFile( dialog.FileName, stream => Machine.BootDiskII.Drives[drive].InsertDisk( dialog.FileName, stream, false ) );
                // Machine.Unpause();
                mo_Resume();
            }
        }
        
        private void MainWindow_Closing( object sender, CancelEventArgs e ) {
            // do not close the window if we are still terminating
            WriteMessage( "MainWindow_Closing" );
            if (!(_sm.IsInState( State.Terminating ) || _sm.IsInState( State.Terminated ))) {
                mo_Terminate();
            }

            e.Cancel = !(_sm.IsInState( State.Terminated ));
        }
        #endregion


        #region OnEntry / OnExit
        [OnEntry]
        private void sm_OnEntry_Started() {
            ExecuteMachineTask<object>( Machine.Initialize, null );
            ExecuteMachineTask<object>( Machine.Reset, null );
        }
        
        [OnEntry]
        private void sm_OnEntry_Running() { _bw.RunWorkerAsync( "some unnecessary argument" ); }

        [OnEntry]
        private void sm_OnEntry_Suspended() { _suspending = true; }

        [OnExit]
        private void sm_OnExit_Suspended() { _resumeEvent.Set(); }

        [OnEntry]
        private void sm_OnStopping() { _bw.CancelAsync(); }

        [OnEntry]
        private void sm_OnEntry_Paused( RunWorkerCompletedEventArgs e ) {
            // show on the MainPage where we paused (PC)
            _mainPage.OnPause(); 

            if ((int)e.Result == 666) {
                OnBreakpoint( this, new BreakpointEventArgs( CurrentRPC ) );
            }
        }

        [OnExit]
        private void sm_OnExit_Paused() { _mainPage.OnUnpause(); }

        [OnEntry]
        private void sm_OnEntry_Terminated( RunWorkerCompletedEventArgs e ) {
            ExecuteMachineTask<object>( Machine.Uninitialize, null );
            _mainPage.MainWindow.Close();
        }
        #endregion


        #region triggers
        private void FireTrigger( Trigger trigger ) {
            WriteMessage( $"FireTrigger({trigger.ToString()})" );
            _sm.Fire( trigger ); 
        }

        public void mo_Start() { FireTrigger( Trigger.Start ); }
        public void mo_Pause() { FireTrigger( Trigger.Pause ); }
        public void mo_Suspend() { FireTrigger( Trigger.Suspend ); }
        public void mo_Resume() { FireTrigger( Trigger.Resume ); }
        public void mo_Unpause() { FireTrigger( Trigger.Unpause ); }
        public void mo_Terminate() { FireTrigger( Trigger.Terminate ); }
        #endregion


        #region BackgroundWorker
        private void bw_ProgressChanged( object sender, ProgressChangedEventArgs e ) {
            WriteMessage( "Reached " + e.ProgressPercentage + "%" );
        }

        private void bw_RunWorkerCompleted( object sender, RunWorkerCompletedEventArgs e ) {

            // method runs GUI thread
            // bw_DoWork (on worker thread) has ended, e is marshalled from bw_DoWork

            if (e.Cancelled)
                WriteMessage( "You canceled!" );
            else if (e.Error != null)
                WriteMessage( "Worker exception: " + e.Error.ToString() );
            else
                WriteMessage( "Complete: " + e.Result );

            // execution has joined with GUI thread
            // semantics of "where we come from" is handled by states - - we just have to signal that we are back
            _sm.Fire( _joinTrigger, e );
        }

        public int CurrentRPC { get; private set; }
        public int PreviousRPC { get; private set; }

        private void bw_DoWork_OnRunning( object sender, DoWorkEventArgs e ) {
            do {
                PreviousRPC = CurrentRPC;
                CurrentRPC = Machine.Cpu.RPC;

                if (Machine.Memory.DebugInfo[CurrentRPC].Flags.HasFlag( DebugFlags.Breakpoint )) {
                    if (CurrentRPC == PreviousRPC) {
                        // we probably paused on a breakpoint and unpaused; in this case the PC is still on the breakpoint
                        // => never break right away again on the same PC
                    } else {

                        // flush events which would have been handled below in the main loop
                        // obviously do *not* execute the op at PC
                        Machine.Events.HandleEvents( 0 );

                        // Virtu emulates beam, so we might not have everything from memory on the screen yet
                        // dirty everything and flush to pixels
                        Machine.Video.Reset();

                        WriteMessage( $"break @ PC ${CurrentRPC:X4}" );
                        e.Result = 666;
                        return;
                    }
                }

                // main MachineEvents loop
                Machine.Events.HandleEvents( Machine.Cpu.Execute() );

                if (_suspending) {
                    // assigning to _suspending is atomic
                    _resumeEvent.WaitOne();
                    _suspending = false;
                }
            } while (!_bw.CancellationPending);

            // This gets passed to RunWorkerCompleted
            e.Result = 123;
        }
        #endregion


        public string BlaBin { get { return Debugger.IsAttached ? "..\\..\\tmp\\bla.bin" : "tmp\\bla.bin"; } }

        private void SaveToBlaBinDuringPauseAfterBreakpoint() {
            ExecuteMachineTask( Machine.SaveStateToFile, BlaBin );
        }

        private void SaveSpriteTable() {
            SpriteTable spriteTable = new SpriteTable( Machine.Memory, 0x7a00 );
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

                    // prevents that Debugger throws System.Runtime.InteropServices.InvalidComObjectException
                    // https://stackoverflow.com/questions/6232867/com-exceptions-on-exit-with-wpf
                    Dispatcher.CurrentDispatcher.InvokeShutdown();

                    _mainWindow = null;
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
