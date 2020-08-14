using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.IO;

namespace Robotron {
    /// <summary>
    /// Interaction logic for Window2.xaml
    /// </summary>
    public partial class Window2 : Window {
        public Window2() {
            InitializeComponent();

            listBox1.Items.Clear();

            List<string> asm = File.ReadAllLines( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" ).ToList();
            listBox1.ItemsSource = asm;
            return;

            StringBuilder sb = new StringBuilder();
            //listBox1.BeginUpdate();
            for (int i = 0; i < 1000; i++) {
                sb.Clear();
                for (int j = 0; j < 20; j++) {
                    sb.Append( i.ToString() + " " );
                }
                listBox1.Items.Add( sb.ToString() );
            }
            //listBox1.EndUpdate();
        }
    }
}
