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
using System.IO.IsolatedStorage;
using System.IO;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Globalization;

namespace Robotron {

    class Program {

        [STAThread]
        static void Main( string[] args ) {

            //SettingKeyboardLanguage.SetKeyboardLayout( SettingKeyboardLanguage.GetInputLanguageByName( "English" ) );
            //Console.WriteLine( InputLanguage.CurrentInputLanguage.LayoutName );
            //Console.ReadLine();
            //return;

            ConsoleTraceListener consoleTracer = new ConsoleTraceListener();
            Trace.Listeners.Add( consoleTracer );

            Trace.WriteLine( "Main() start" );

            // Flush any pending trace messages
            Trace.Flush();

            // TestWindow1();

            using (VirtuRunner st = new VirtuRunner()) {
                st.TestVirtu2();
                Console.WriteLine( "exit TestVirtu() from using" );
            }

            //MachineOperator mop = new MachineOperator();
            //mop.Test();

            if ( false ) {
                Bug bug = new Bug( "bug" );
                Debug.Assert( bug.CanAssign );
                Debug.Assert( bug._machine.IsInState( Bug.State.Open ) );
                bug.Assign( "Frank" );
                Debug.Assert( bug._machine.IsInState( Bug.State.Assigned ) );
                bug.Assign( "Holger" );

                bug.Defer();
                bug.Assign( "Eva" );
                bug.Close();
                Debug.Assert( !bug.CanAssign );
                Debug.Assert( bug._machine.IsInState( Bug.State.Closed ) );
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