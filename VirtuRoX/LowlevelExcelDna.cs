using ExcelDna.Integration;
using ExcelDna.Integration.Extensibility;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Robotron {
    public class MyAddIn : IExcelAddIn {

        private static ExcelComAddIn com_addin;

        public void AutoOpen() {
            ExcelIntegration.RegisterUnhandledExceptionHandler( ErrorHandler );

            try {
                com_addin = new MyCom();
                ExcelComAddInHelper.LoadComAddIn( com_addin );
            } catch (Exception e) {
                MessageBox.Show( "Error loading COM AddIn: " + e.ToString() );
            }
        }

        private object ErrorHandler( object exceptionObject ) {
            ExcelReference caller = (ExcelReference)XlCall.Excel( XlCall.xlfCaller );

            // Calling reftext here requires all functions to be marked IsMacroType=true, which is undesirable.
            // A better plan would be to build the reference text oneself, using the RowFirst / ColumnFirst info
            // Not sure where to find the SheetName then....
            string callingName = (string)XlCall.Excel( XlCall.xlfReftext, caller, true );

            Trace.WriteLine( callingName + " Error: " + exceptionObject.ToString() );

            // return #VALUE into the cell anyway.
            return ExcelError.ExcelErrorValue;
        }

        public void AutoClose() {
            // https://groups.google.com/forum/#!topic/exceldna/uIH6x8ESEUs
        }

        [ExcelFunction( IsMacroType = true )]
        public static double DoGood() {
            return 7;
        }

        [ExcelFunction( IsMacroType = true )]
        public static double DoBad() {
            throw new InvalidOperationException( "Don't be evil!" );
        }
    }


    [ComVisible( true )]
    public class MyCom : ExcelComAddIn {

        public MyCom() {
            //SWF.MessageBox.Show("asdf");
        }

        public override void OnConnection( object Application, ext_ConnectMode ConnectMode, object AddInInst, ref Array custom ) {
        }

        public override void OnDisconnection( ext_DisconnectMode RemoveMode, ref Array custom ) {
        }

        public override void OnAddInsUpdate( ref Array custom ) {
        }

        public override void OnStartupComplete( ref Array custom ) {
            //SWF.MessageBox.Show("OnStartupComplete");
        }

        public override void OnBeginShutdown( ref Array custom ) {
            //SWF.MessageBox.Show("OnBeginShutDown");
        }
    }

}
