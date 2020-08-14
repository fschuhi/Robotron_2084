using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Xml;

namespace Robotron {
    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window {

        AsmReader _reader;

        public Window1() {
            InitializeComponent();

            _reader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );

            List<ListBoxItem> items = new List<ListBoxItem>();
            foreach (AsmLine asmLine in _reader._asmLines) {
                switch (asmLine.LineType) {
                    case AsmLineType.CommentLine:
                        items.Add( new CommentItem() {
                            Comment = asmLine.Comment
                        } );
                        break;

                    case AsmLineType.OpcodeLine:
                        items.Add( new AddressItem() {
                            Address = asmLine.Address,
                            Bytes = asmLine.Bytes,
                            Label = asmLine.Label,
                            Opcode = asmLine.Opcode,
                            Operand = asmLine.OperandArgument.Operand
                        } );
                        break;

                    case AsmLineType.DirectiveLine:
                        items.Add( new AddressItem() {
                            Address = asmLine.Address,
                            Bytes = asmLine.Bytes,
                            Label = asmLine.Label,
                            Opcode = asmLine.Directive,
                            Operand = asmLine.DirectiveArgument.Operand
                        } );
                        break;
                }
                if (asmLine.HasOperandArgument()) {                    
                }
            }

            listBox.ItemsSource = items;
            listBox.SelectedIndex = 0;
            listBox.Focus();
        }

        private void TextBlock_MouseUp( object sender, MouseButtonEventArgs e ) {
            MessageBox.Show( "yes" );
        }

        private void listBox_KeyDown( object sender, KeyEventArgs e ) {
            MessageBox.Show( "key" );
        }
    }


    public class ListBoxItem { }

    public class AddressItem : ListBoxItem {
        public string Address { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }
        public string Opcode { get; set; }
        public string Operand { get; set; }
    }

    public class CommentItem : ListBoxItem {
        public string Comment { get; set; }
    }

    public class PaddingConverter : IValueConverter {
        public object Convert( object value, Type targetType, object parameter, System.Globalization.CultureInfo culture ) {
            string str = (string)value;
            if (parameter != null) {
                string strParameter = (String)parameter;
                switch (strParameter) {
                    case "Bytes":
                        str = str.PadRight( 15 );
                        break;

                    case "Label":
                        str = str.PadRight( 20 );
                        break;

                    case "Opcode":
                        str = "<Italic>" + str.PadRight( 5 ) + "</Italic>";
                        break;

                }
            }
            return str;
        }

        public object ConvertBack( object value, Type targetType, object parameter, System.Globalization.CultureInfo culture ) {
            return value;
        }
    }

    public class Attached {
        // https://stackoverflow.com/questions/5582893/wpf-generate-textblock-inlines

        public static readonly DependencyProperty FormattedTextProperty = DependencyProperty.RegisterAttached(
            "FormattedText",
            typeof( string ),
            typeof( Attached ),
            new FrameworkPropertyMetadata( string.Empty, FrameworkPropertyMetadataOptions.AffectsMeasure, FormattedTextPropertyChanged ) );

        public static void SetFormattedText( DependencyObject textBlock, string value ) {
            textBlock.SetValue( FormattedTextProperty, value );
        }

        public static string GetFormattedText( DependencyObject textBlock ) {
            return (string)textBlock.GetValue( FormattedTextProperty );
        }

        private static void FormattedTextPropertyChanged( DependencyObject d, DependencyPropertyChangedEventArgs e ) {
            var textBlock = d as TextBlock;
            if (textBlock == null) {
                return;
            }

            var formattedText = (string)e.NewValue ?? string.Empty;
            formattedText = string.Format( "<Span xml:space=\"preserve\" xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\">{0}</Span>", formattedText );

            textBlock.Inlines.Clear();
            using (var xmlReader = XmlReader.Create( new StringReader( formattedText ) )) {
                var result = (Span)XamlReader.Load( xmlReader );
                textBlock.Inlines.Add( result );
            }
        }
    }
}
