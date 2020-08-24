using ExcelDna.Integration;
using System.Windows;

namespace Robotron {

    public static class VirtuRoXFunctions {

        static XlWorkbench _workbench;
        static XlWorkbench XlWorkbench { 
            get {
                if (_workbench == null) _workbench = new XlWorkbench();
                return _workbench;
            }
        }


        #region flags
        const int PN = 0x80;
        const int PV = 0x40;
        const int PR = 0x20;
        const int PB = 0x10;
        const int PD = 0x08;
        const int PI = 0x04;
        const int PZ = 0x02;
        const int PC = 0x01;

        [ExcelFunction( Name = "ToFlagsString", Category = "Schuhi" )]
        public static string ToFlagsString( int RS ) {
            string flags = "";
            flags += (RS & PN) != 0 ? "N" : "_";
            flags += (RS & PV) != 0 ? "V" : "_";
            flags += (RS & PB) != 0 ? "B" : "_";
            //bla += (rs & PR) != 0 ? "R" : "_";
            flags += ".";
            flags += (RS & PD) != 0 ? "D" : "_";
            flags += (RS & PI) != 0 ? "I" : "_";
            flags += (RS & PZ) != 0 ? "Z" : "_";
            flags += (RS & PC) != 0 ? "C" : "_";
            return flags;
        }

        [ExcelFunction( Name = "ToNZC", Category = "Schuhi" )]
        public static string ToNZC( int rs ) {
            string flags = "";
            flags += (rs & PN) != 0 ? "N" : "_";
            flags += (rs & PZ) != 0 ? "Z" : "_";
            flags += (rs & PC) != 0 ? "C" : "_";
            return flags;
        }
        #endregion


        [ExcelFunction( Name = "GetAsmLineByIndex", Category = "Schuhi" )]
        public static string GetAsmLineByIndex( int index ) {
            return XlWorkbench.GetAsmLineByIndex( index );
        }

        [ExcelFunction( Name = "GetAsmLineByAddress", Category = "Schuhi" )]
        public static string GetAsmLineByAddress( int address ) {
            return XlWorkbench.GetAsmLineByAddress( address );
        }


        [ExcelFunction( Name = "GetReadCounts", Category = "Schuhi" )]
        public static object[,] GetReadCounts( int baseAddress, int bytes ) {
            return XlWorkbench.GetReadCounts( baseAddress, bytes );
        }

        [ExcelFunction( Name = "GetWriteCounts", Category = "Schuhi" )]
        public static object[,] GetWriteCounts( int baseAddress, int bytes ) {
            return XlWorkbench.GetWriteCounts( baseAddress, bytes );
        }

        [ExcelFunction( Name = "GetExecutedCounts", Category = "Schuhi" )]
        public static object[,] GetExecutedCounts( int baseAddress, int bytes ) {
            return XlWorkbench.GetExecutedCounts( baseAddress, bytes );
        }


        public static bool OptionalBool( object oBool, bool defaultBool ) {
            if (oBool == null) return defaultBool;
            if (oBool is ExcelMissing) return defaultBool;
            if (oBool is string) {
                string sBool = (oBool as string).ToUpper();
                return sBool == "WAHR" || sBool == "FALSE";
            }
            double dBool = ExcelDataConverters.TryGetDoubleValue( oBool );
            return dBool != 0.0;
        }

        [ExcelFunction( Name = "GetReads", Category = "Schuhi" )]
        public static object[,] GetReads( int firstCycles, int lastCycles ) {
            return XlWorkbench.GetReads( firstCycles, lastCycles );
        }

        #region testing
        [ExcelFunction( Name = "TestEchoFunc", Category = "Schuhi" )]
        public static string TestEchoFunc( string text ) {
            return text;
        }

        [ExcelCommand( MenuText = "Run", MenuName = "Schuhi", ShortCut = "^R" )]
        public static void RunRobotronWindow() {
            MessageBoxResult result2 = MessageBox.Show( "hit the ground running?", "start mode", MessageBoxButton.YesNoCancel, MessageBoxImage.Question );
            if (result2 == MessageBoxResult.Cancel) {
                //
            } else {
                //
            }

        }
        #endregion
    }

}
