using System;
using System.Diagnostics;
using CommandLine;
using Jellyfish.Virtu;
using System.Threading;
using System.Windows;

namespace Robotron {

    public class Options {
        [Option( 'b', "Breakpoints", Required = false, HelpText = "Run with breakpoints." )]
        public bool Breakpoints { get; set; }

        [Option( 'c', "CloseOnFirstBreakpoint", Required = false, HelpText = "Close on first breakpoint." )]
        public bool CloseOnFirstBreakpoint { get; set; }

        [Option( 'f', "Fast", Required = false, Default = false, HelpText = "Fast execution (not throttled)." )]
        public bool Fast { get; set; }
    }

    class Program {

        private static MachineOperator _machineOperator;
        private static Workbench _workbench;

        [STAThread]
        static void Main( string[] args ) {

            Window1 wnd1 = new Window1();
            wnd1.ShowDialog();
            return;
            
            /*
            Window wnd1 = new Window1();
            wnd1.ShowDialog();
            return;
            */
            /*
            Window wnd2 = new Window2();
            wnd2.ShowDialog();
            return;

            // 1. test the form in a standalone fashion
            Form1 frm = new Form1();
            //frm.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            frm.ShowDialog();
            return;
            */

            Parser.Default.ParseArguments<Options>( args )
                .WithParsed<Options>( o => {

                    ConsoleTraceListener tracer = new ConsoleTraceListener();
                    Trace.Listeners.Add( tracer );
                    Trace.WriteLine( "Main() start" );

                    AsmReader reader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
                    //reader.Test1();
                                        
                    Trace.WriteLine( $"Running workbench{(o.Breakpoints ? "with" : "without")} breakpoints: -b {o.Breakpoints}" );

                    using (_machineOperator = new MachineOperator()) {

                        if (o.Breakpoints) {

                            // _machineOperator.OnPaused += MachineOperator_OnPaused;
                            _workbench = new Workbench( _machineOperator, o );

                        } else {

                            _machineOperator.OnLoaded += ( MachineOperator mo ) => mo.LoadStateFromFile( mo.BlaBin );
                        }

                        //Form1 frm = new Form1();
                        //frm.Populate();
                        //frm.Show();

                        _machineOperator.ShowDialog();
                    }
                    

                    Trace.WriteLine( "Main() end" );
                    Trace.Flush();
                    Trace.Listeners.Remove( tracer );
                    tracer.Close();
                    Trace.Close();
                } );
        }

        private static void MachineOperator_OnPaused( MachineOperator mo, PausedEventArgs e ) {

            string saveStateFile = @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\save_state.bin";

            if (e.BreakpointRCP == _workbench.AsmService.GetAddress( "doneAtari")) {
                _machineOperator.Machine.SaveStateToFile( saveStateFile );
                try {

                    Cpu cpu = _machineOperator.Machine.Cpu;

                    int divideAX = _workbench.AsmService.GetAddress( "divideAX" );
                    int rts = _workbench.AsmService.GetAddress( "divideAX_RTS" );

                    long min = 10000;
                    long max = 0;

                    for (int A = 0; A <= 255; A++ ) {
                        for (int X=1; X <= 255; X++ ) {
                            cpu.RPC = divideAX;
                            long cycles = Execute4C00( cpu, divideAX ,rts, A, X, A / X, A % X );
                            min = cycles < min ? cycles : min;
                            max = cycles > max ? cycles : max;
                        }
                    }

                    Trace.WriteLine( $"min={min}, max={max}" );

                } finally {
                    _machineOperator.LoadStateFromFile( saveStateFile );
                }
            }
        }


        private static long Execute4C00( Cpu cpu, int startAddr, int endAddr, int A, int X, int quotient, int rest ) {
            cpu.RPC = startAddr;
            cpu.RA = A;
            cpu.RX = X;

            cpu.Cycles = 0;

            while (cpu.RPC != endAddr) {
                cpu.Execute();
            }

            Debug.Assert( cpu.RA == quotient );
            Debug.Assert( cpu.RX == rest );

            return cpu.Cycles;

            //Trace.WriteLine( $"A={A}, X={X} => A={cpu.RA} X={cpu.RX}" );
        }

    }
}