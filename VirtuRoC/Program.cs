using System;
using System.Diagnostics;
using CommandLine;
using VirtuRoC;

namespace Robotron {

    class Program {

        public class Options {
            [Option( 'b', "Breakpoints", Required = false, HelpText = "Run with breakpoints." )]
            public bool Breakpoints { get; set; }
        }

        [STAThread]
        static void Main( string[] args ) {
            ConsoleTraceListener tracer = new ConsoleTraceListener();
            Trace.Listeners.Add( tracer );
            Trace.WriteLine( "Main() start" );

            //TestWindow2();

            Parser.Default.ParseArguments<Options>( args )
                .WithParsed<Options>( o => {
                    Trace.WriteLine( $"Running workbench{(o.Breakpoints ? "with" : "without")} breakpoints: -b {o.Breakpoints}" );

                    using (MachineOperator _operator = new MachineOperator()) {
                        Workbench _workbench = new Workbench( _operator, o.Breakpoints );

                        //Form1 frm = new Form1();
                        //frm.Populate();
                        //frm.Show();

                        _operator.ShowDialog();
                    }
                } );

            Trace.WriteLine( "Main() end" );
            Trace.Flush();
            Trace.Listeners.Remove( tracer );
            tracer.Close();
            Trace.Close();
        }

        static void TestWindow1() {
            Window1 win = new Window1();
            win.ShowDialog();
        }
        static void TestWindow2() {
            Window2 win = new Window2();
            win.ShowDialog();
        }
    }


}