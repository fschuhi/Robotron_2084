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

namespace Robotron {

    class MachineOperator {

        public MainPage _page;
        public Machine _machine;

        public MachineOperator( MainPage page, Machine machine ) {
            _page = page;
            _machine = machine;
            Debug.Assert( _page.Machine == _machine );
        }

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

    }

}
