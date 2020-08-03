using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Robotron {
    public partial class AsmForm : Form {
        public AsmForm() {
            InitializeComponent();
        }

        private void fastColoredTextBox1_Load( object sender, EventArgs e ) {
            fastColoredTextBox1.Text = File.ReadAllText( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );

        }
    }
}
