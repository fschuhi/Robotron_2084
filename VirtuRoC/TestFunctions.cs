using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using System;
using System.IO;
using System.Text;
using System.Globalization;
using System.Threading;

namespace Robotron {

    [TestClass]
    public class RobotronTestClass {
        public static string FilePath( string filename ) {
            return @"s:\source\repos\Robotron_2084\VirtuRoC\" + filename;
        }

        public static string FormatMessage( string format, params object[] args ) {
            var message = new StringBuilder( 256 );
            message.AppendFormat( CultureInfo.InvariantCulture, "[{0} T{1:X3} Tests] ", DateTime.Now.ToString( "HH:mm:ss.fff", CultureInfo.InvariantCulture ), Thread.CurrentThread.ManagedThreadId );
            if (args.Length > 0) {
                try {
                    message.AppendFormat( CultureInfo.InvariantCulture, format, args );
                } catch (FormatException ex) {
                    LogMessage( "[DebugService.FormatMessage] format: {0}; args: {1}; exception: {2}", format, string.Join( ", ", args ), ex.Message );
                }
            } else {
                message.Append( format );
            }
            return message.ToString();
        }

        public static void LogMessage( string message ) {
            Trace.WriteLine( FormatMessage( message ) );
        }

        public static void LogMessage( string message, params object[] args ) {
            Trace.WriteLine( FormatMessage( message, args ) );
        }

        // append to the log, or create it
        FileStream _logFileStream = new FileStream( FilePath( @"tmp\log.log" ), FileMode.Append, FileAccess.Write );

        [TestInitialize]
        public void Initialize() {
            TextWriterTraceListener tracer = new TextWriterTraceListener( _logFileStream );
            Trace.Listeners.Add( tracer );
            LogMessage( "starting tests..." );
        }

        [TestCleanup]
        public void Cleanup() {
            LogMessage( "... done tests." );
            Trace.Flush();
            _logFileStream.Close();
        }
    }


    [TestClass]
    public class SimpleTest : RobotronTestClass {

        [TestMethod]
        public void SampleTest() {
            //WriteToLog( "reiert" );
            Trace.Indent();
            AsmReader asmReader = new AsmReader( FilePath( @"tmp\\Robotron.csv" ));
            Trace.Unindent();
        }

    }
}
