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

        [ExcelFunction( Name = "GetAsmLine", Category = "Schuhi" )]
        public static string GetAsmLine( int index ) {
            return XlWorkbench.GetAsmLine( index );
        }

        [ExcelFunction( Name = "GetReadCounts", Category = "Schuhi" )]
        public static object[,] GetReadCounts( int baseAddress, int bytes ) {
            return XlWorkbench.GetReadCounts( baseAddress, bytes );
        }

        [ExcelFunction( Name = "GetWriteCounts", Category = "Schuhi" )]
        public static object[,] GetWriteCounts( int baseAddress, int bytes ) {
            return XlWorkbench.GetWriteCounts( baseAddress, bytes );
        }

        [ExcelFunction( Name = "GetArray", Category = "Schuhi" )]
        public static object[,] GetArray( int rows, int columns ) {
            return XlWorkbench.GetArray( rows, columns );
        }

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
    }

}
