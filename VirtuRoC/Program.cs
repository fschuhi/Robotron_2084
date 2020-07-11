using System;
using System.Diagnostics;

namespace Robotron {

    class Program {

        [STAThread]
        static void Main( string[] args ) {

            ConsoleTraceListener consoleTracer = new ConsoleTraceListener();
            Trace.Listeners.Add( consoleTracer );

            Trace.WriteLine( "Main() start" );

            // Flush any pending trace messages
            Trace.Flush();

            // TestWindow1();

            using (MachineOperator _operator = new MachineOperator()) {

                Workbench _workbench = new Workbench( _operator );

                _operator.ShowDialog();
            }

            // Write a final trace message to all trace listeners.
            Trace.WriteLine( "Main() end" );

            // remove the console trace listener from the collection, and close the console trace listener.
            Trace.Listeners.Remove( consoleTracer );
            consoleTracer.Close();

            // Close all other configured trace listeners.
            Trace.Close();
        }

        static void TestWindow1() {
            Window1 win = new Window1();
            win.ShowDialog();
        }
    }


}