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


namespace Robotron {

    public class VirtuRunner : IDisposable {

        private MachineOperator _operator;
        private Machine _machine;
        public MainWindow _mainWindow;
        public MainPage _mainPage;


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


        public void TestVirtu2() {
            WriteMessage( "TestVirtu() enter" );

            // setup window, including MainPage
            _mainWindow = new MainWindow();
            _mainPage = _mainWindow.GetMainPage();

            // MainPage has created a Machine object, but hasn't done anything with it yet
            _machine = _mainPage.Machine;
            using (_operator = new MachineOperator( _mainPage, _machine )) {

                // start message pumping
                _mainWindow.ShowActivated = true;
                _mainWindow.ShowDialog();

                WriteMessage( "ShowDialog exited, shutting down" );
            }
            // prevents that Debugger throws System.Runtime.InteropServices.InvalidComObjectException
            // https://stackoverflow.com/questions/6232867/com-exceptions-on-exit-with-wpf
            Dispatcher.CurrentDispatcher.InvokeShutdown();
            _mainWindow = null;
            WriteMessage( "TestVirtu2() exit" );
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
                WriteMessage( "VirtuRunner.Dispose() inside" );
            }
            WriteMessage( "VirtuRunner.Dispose() outside" );
        }
        #endregion
    }
}
