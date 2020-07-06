using bla;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Jellyfish.Virtu;
using System.Threading;
using System.Windows.Forms;
using System.Windows.Input;
using System.Runtime.CompilerServices;

namespace VirtuRoC {
    class Program {

        [STAThread]
        static void Main( string[] args ) {
            ConsoleTraceListener consoleTracer = new ConsoleTraceListener();
            Trace.Listeners.Add( consoleTracer );

            Trace.WriteLine( "Main() start" );

            // Flush any pending trace messages
            Trace.Flush();

            // Write a final trace message to all trace listeners.
            Trace.WriteLine( "Main() end" );

            // TestVirtu();

            TestVirtu();

            // remove the console trace listener from the collection, and close the console trace listener.
            Trace.Listeners.Remove( consoleTracer );
            consoleTracer.Close();

            // Close all other configured trace listeners.
            Trace.Close();
        }

        static void TestVirtu() {
            using (VirtuRunner st = new VirtuRunner()) {
                st.TestVirtu();
            }
            Console.WriteLine( "exit TestVirtu() from using" );
        }

        static void TestWindow1() {
            Window1 win = new Window1();
            win.ShowDialog();
        }
    }
}