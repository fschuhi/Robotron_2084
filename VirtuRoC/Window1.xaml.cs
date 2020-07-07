using Robotron;
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

// https://blog.magnusmontin.net/2014/08/13/tabbing-between-items-in-wpf-listbox/
// https://www.wpf-tutorial.com/list-controls/listbox-control/

namespace Robotron {
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window {
        public Window1() {
            InitializeComponent();
            MyFirstListBox.Focus();
            MyFirstListBox.SelectedIndex = 0;
        }

        private void MyFirstListBox_SelectionChanged( object sender, SelectionChangedEventArgs e ) {

        }
    }
}
