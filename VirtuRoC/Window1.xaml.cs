using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Threading;
using System.Xml;

namespace Robotron {

    public class AsmListBoxItem {
        public AsmLine AsmLine { get; set; }
    }

    public class AddressItem : AsmListBoxItem {
        public string Address { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }
        public string Instruction { get; set; }
        public string Operand { get; set; }
        public string Comment { get; set; }

        public string InstructionColor { get; set; }
    }

    public class CommentItem : AsmListBoxItem {
        public string CommentLine { get; set; }
    }

    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class Window1 : Window {

        public AsmReader AsmReader;
        
        List<AsmListBoxItem> _items = new List<AsmListBoxItem>();

        Dictionary<AsmLine, AsmListBoxItem> _itemsByAsmLine = new Dictionary<AsmLine, AsmListBoxItem>();

        string InstructionColor( AsmLine asmLine ) {
            if (asmLine.IsBranchOperation()) return "Blue";
            if ("jmp jsr rts".Contains( asmLine.Opcode )) return "Red";
            return "Black";
        }

        public Window1() {
            InitializeComponent();

            AsmReader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            
            PaddingConverter.Window = this;
            IndentConverter.Window = this;
            OperandConverter.Window = this;

            foreach (AsmLine asmLine in AsmReader._asmLines) {
                AsmListBoxItem newItem = null;
                switch (asmLine.LineType) {
                    case AsmLineType.CommentLine:
                        newItem = new CommentItem() {
                            CommentLine = asmLine.Comment
                        };
                        break;

                    case AsmLineType.OpcodeLine:
                        newItem = new AddressItem() {
                            Address = asmLine.Address,
                            Bytes = asmLine.Bytes,
                            Label = asmLine.Label,
                            Instruction = asmLine.Opcode,
                            Operand = asmLine.OperandArgument.Operand,
                            InstructionColor = this.InstructionColor( asmLine ),
                            Comment = asmLine.Comment,
                        };
                        break;

                    case AsmLineType.DirectiveLine:
                        newItem = new AddressItem() {
                            Address = asmLine.Address,
                            Bytes = asmLine.Bytes,
                            Label = asmLine.Label,
                            Instruction = asmLine.Directive,
                            Operand = asmLine.DirectiveArgument.Operand,
                            InstructionColor = "DarkMagenta",
                            Comment = asmLine.Comment,
                        };
                        break;
                }

                if (newItem != null) {
                    newItem.AsmLine = asmLine;
                    _items.Add( newItem );
                    _itemsByAsmLine.Add( asmLine, newItem );
                }

                if (asmLine.HasOperandArgument()) {                    
                }
            }

            listBox.ItemsSource = _items;
            listBox.SelectedIndex = 0;
            listBox.Focus();
        }

        private void TextBlock_MouseUp( object sender, MouseButtonEventArgs e ) {
            MessageBox.Show( "yes" );
        }

        private void ScrollToAddress( int address ) {
            AsmLine asmLine = AsmReader.AsmLineByAddressDictionary()[address];
            if (asmLine == null) return;
            AsmListBoxItem scrollItem = _itemsByAsmLine[asmLine];
            ScrollToItem( scrollItem );
        }

        private void ScrollToItem( AsmListBoxItem item ) {
            listBox.ScrollToCenterOfView( item );
            ListBoxItem lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            lbi.Focus();
        }

        private void listBox_KeyDown( object sender, KeyEventArgs e ) {
            bool IsShiftKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Shift );
            bool IsAltKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Alt );
            bool IsControlKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Control );
            if (IsShiftKey && IsAltKey && IsControlKey ) {
                AsmListBoxItem item = (AsmListBoxItem)listBox.SelectedItem;
                if (item is AddressItem ) {
                    AddressItem addressItem = (AddressItem)item;
                    MessageBox.Show( addressItem.Address );
                    int addr = AsmReader.AddressByLabelDictionary()["chooseControls"];
                    ScrollToAddress( addr );
                }
            }
        }
    }


    #region value converters
    public abstract class AsmListBoxItemConverter : IValueConverter {

        public static Window1 Window { get; set; }

        public virtual object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            throw new NotImplementedException();
        }

        public object ConvertBack( object value, Type targetType, object parameter, CultureInfo culture ) {
            return value;
        }
    }


    public class PaddingConverter : AsmListBoxItemConverter {
        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            string str = (string)value ?? "";
            int padding;
            return int.TryParse( parameter.ToString(), out padding ) ? str.PadRight( padding ) : str;
        }
    }


    public class IndentConverter : AsmListBoxItemConverter {
        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            string str = (string)value ?? "";
            int padding;
            return int.TryParse( parameter.ToString(), out padding ) ? (new String( ' ', padding )) + str : str;
        }
    }


    public class OperandConverter : AsmListBoxItemConverter {

        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            var lbi = (ListBoxItem)value;
            AsmListBoxItem item = (AsmListBoxItem)lbi.Content;

            AddressItem addressItem = item as AddressItem;
            string operand = addressItem.Operand ?? "";

            int padding;
            operand = int.TryParse( parameter.ToString(), out padding ) ? operand.PadRight( padding ) : operand;

            AsmLine asmLine = item.AsmLine;
            if (asmLine.HasOperandArgument()) {
                if (asmLine.OperandArgument.HasLabel()) {
                    if (!(asmLine.IsJumpOperation() || asmLine.IsBranchOperation() )) {
                        string label = asmLine.OperandArgument.Label;
                        operand = operand.Replace( label, "<Run Foreground=\"DarkOrange\">" + label + "</Run>" );
                    }
                }
            }

            return operand.Replace( "&", "&amp;" );
        }
    }
    #endregion


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
            if (textBlock == null) return;

            var formattedText = (string)e.NewValue ?? string.Empty;
            formattedText = string.Format( "<Span xml:space=\"preserve\" xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\">{0}</Span>", formattedText );

            textBlock.Inlines.Clear();
            using (var xmlReader = XmlReader.Create( new StringReader( formattedText ) )) {
                var result = (Span)XamlReader.Load( xmlReader );
                textBlock.Inlines.Add( result );
            }
        }
    }


    public static class ItemsControlExtensions {
        // https://stackoverflow.com/questions/2946954/make-listview-scrollintoview-scroll-the-item-into-the-center-of-the-listview-c
        public static void ScrollToCenterOfView( this ItemsControl itemsControl, object item ) {
            // Scroll immediately if possible
            if (!itemsControl.TryScrollToCenterOfView( item )) {
                // Otherwise wait until everything is loaded, then scroll
                if (itemsControl is ListBox) ((ListBox)itemsControl).ScrollIntoView( item );
                itemsControl.Dispatcher.BeginInvoke( DispatcherPriority.Loaded, new Action( () =>
                {
                    itemsControl.TryScrollToCenterOfView( item );
                } ) );
            }
        }

        private static bool TryScrollToCenterOfView( this ItemsControl itemsControl, object item ) {
            // Find the container
            var container = itemsControl.ItemContainerGenerator.ContainerFromItem( item ) as UIElement;
            if (container == null) return false;

            // Find the ScrollContentPresenter
            ScrollContentPresenter presenter = null;
            for (Visual vis = container; vis != null && vis != itemsControl; vis = VisualTreeHelper.GetParent( vis ) as Visual)
                if ((presenter = vis as ScrollContentPresenter) != null)
                    break;
            if (presenter == null) return false;

            // Find the IScrollInfo
            var scrollInfo =
                !presenter.CanContentScroll ? presenter :
                presenter.Content as IScrollInfo ??
                FirstVisualChild( presenter.Content as ItemsPresenter ) as IScrollInfo ??
                presenter;

            // Compute the center point of the container relative to the scrollInfo
            Size size = container.RenderSize;
            Point center = container.TransformToAncestor( (Visual)scrollInfo ).Transform( new Point( size.Width / 2, size.Height / 2 ) );
            center.Y += scrollInfo.VerticalOffset;
            center.X += scrollInfo.HorizontalOffset;

            // Adjust for logical scrolling
            if (scrollInfo is StackPanel || scrollInfo is VirtualizingStackPanel) {
                double logicalCenter = itemsControl.ItemContainerGenerator.IndexFromContainer( container ) + 0.5;
                Orientation orientation = scrollInfo is StackPanel ? ((StackPanel)scrollInfo).Orientation : ((VirtualizingStackPanel)scrollInfo).Orientation;
                if (orientation == Orientation.Horizontal)
                    center.X = logicalCenter;
                else
                    center.Y = logicalCenter;
            }

            // Scroll the center of the container to the center of the viewport
            if (scrollInfo.CanVerticallyScroll) scrollInfo.SetVerticalOffset( CenteringOffset( center.Y, scrollInfo.ViewportHeight, scrollInfo.ExtentHeight ) );
            if (scrollInfo.CanHorizontallyScroll) scrollInfo.SetHorizontalOffset( CenteringOffset( center.X, scrollInfo.ViewportWidth, scrollInfo.ExtentWidth ) );
            return true;
        }

        private static double CenteringOffset( double center, double viewport, double extent ) {
            return Math.Min( extent - viewport, Math.Max( 0, center - viewport / 2 ) );
        }
        private static DependencyObject FirstVisualChild( Visual visual ) {
            if (visual == null) return null;
            if (VisualTreeHelper.GetChildrenCount( visual ) == 0) return null;
            return VisualTreeHelper.GetChild( visual, 0 );
        }
    }
}
