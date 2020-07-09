using System;
using System.Threading;
using System.ComponentModel;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Stateless;
using Stateless.Graph;

namespace Robotron {

    class BackgroundWorkerExample {

        static BackgroundWorker _bw;

        public BackgroundWorkerExample() {
            _bw = new BackgroundWorker {
                WorkerReportsProgress = true,
                WorkerSupportsCancellation = true
            };
            _bw.DoWork += bw_DoWork;
            _bw.ProgressChanged += bw_ProgressChanged;
            _bw.RunWorkerCompleted += bw_RunWorkerCompleted;
        }

        public void Test() {

            _bw.RunWorkerAsync( "Hello to worker" );

            Console.WriteLine( "Press Enter in the next 5 seconds to cancel" );
            Console.ReadLine();
            if (_bw.IsBusy) _bw.CancelAsync();
            Console.ReadLine();
        }

        private static void bw_ProgressChanged( object sender, ProgressChangedEventArgs e ) {
            Console.WriteLine( "Reached " + e.ProgressPercentage + "%" );
        }

        private static void bw_RunWorkerCompleted( object sender, RunWorkerCompletedEventArgs e ) {
            if (e.Cancelled)
                Console.WriteLine( "You canceled!" );
            else if (e.Error != null)
                Console.WriteLine( "Worker exception: " + e.Error.ToString() );
            else
                Console.WriteLine( "Complete: " + e.Result );      // from DoWork
        }

        static void bw_DoWork( object sender, DoWorkEventArgs e ) {
            for (int i = 0; i <= 100; i += 20) {
                if (_bw.CancellationPending) {
                    Console.WriteLine( "CancellationPending" );
                    e.Cancel = true; return;
                }
                _bw.ReportProgress( i );
                Thread.Sleep( 1000 );      // Just for the demo... don't go sleeping
            }                           // for real in pooled threads!

            e.Result = 123;    // This gets passed to RunWorkerCompleted
        }
    }

}
