using System;
using System.Linq;
using System.Diagnostics;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Controls.Primitives;
using System.Windows.Input;
using System.Xml;
using System.IO;
using System.Windows.Markup;
using System.Windows.Documents;
using System.Runtime.CompilerServices;
using System.Windows.Threading;

namespace Robotron {

    public class RobotronObject {
        public static int StringToDecimal( string s ) {
            if (s == "") return -1;
            if (s.StartsWith( "$" ))
                return HexToDecimal( s );
            else if (s.StartsWith( "#$" ))
                return HexToDecimal( s.Substring( 2 ) );
            else if (s.StartsWith( "#" ))
                return Int32.Parse( s.Substring( 1 ) );
            else
                return Int32.Parse( s );
        }

        public static int HexToDecimal( string s ) {
            if (s == "") return -1;
            return int.Parse( s.StartsWith( "$" ) ? s.Substring( 2 ) : s, NumberStyles.HexNumber );
        }

        public static string DecimalToHexAddress( int addr, bool zeroPage = false ) {
            return zeroPage ? $"${addr:X02}" : $"${addr:X04}";
        }
        public static string DecimalToHexNum( int addr, bool zeroPage = false ) {
            return zeroPage ? $"{addr:X02}" : $"{addr:X04}";
        }

        public void TraceLine() {
            TraceLine( "" );
        }

        public void TraceLine( params object[] objects ) {
            Trace.WriteLine( string.Join( "\t", objects.Select( o => o.ToString() ).ToArray() ) );
        }

        public void TraceNewLine( params object[] objects ) {
            TraceLine();
            TraceLine( objects );
        }

        public void TraceObjectType( object obj ) {
            TraceLine( obj.ToString() );
        }
    }

    public enum AddressPart { NA, High, Low };

    public static class RobotronExtensions {
        public static int ToDecimal( this string hex ) {
            return RobotronObject.HexToDecimal( hex );
        }
        public static string ToHex( this int dec ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexAddress( dec );
        }
        public static string ToHex( this int dec, bool zeroPage ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexAddress( dec, zeroPage );
        }

        public static string To8BitHex( this int dec ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexNum( dec, true );
        }

        public static int LowByte( this int address ) {
            return address & 0x00ff;
        }

        public static int HighByte( this int address ) {
            return address >> 8;
        }
    }

    public class RegexHelpers {
        public static void Transfer( object obj, Match match, params string[] values ) {
            Type type = obj.GetType();
            foreach (string value in values) {
                PropertyInfo prop = type.GetProperty( value );
                Debug.Assert( prop != null, $"unknown property {value}" );
                Debug.Assert( prop.GetValue( obj ) == null );
                prop.SetValue( obj, match.Groups[value].Value, null );
            }
        }

        public static string MatchValue( Regex regex, string target, string value ) {
            Match match = regex.Match( target );
            return match.Groups[value].Value;
        }
    }

    public class UIHelpers {
        public static DependencyObject GetScrollViewer( DependencyObject o ) {
            // Return the DependencyObject if it is a ScrollViewer
            if (o is ScrollViewer) { return o; }

            for (int i = 0; i < VisualTreeHelper.GetChildrenCount( o ); i++) {
                var child = VisualTreeHelper.GetChild( o, i );

                var result = GetScrollViewer( child );
                if (result == null) {
                    continue;
                } else {
                    return result;
                }
            }
            return null;
        }

        public static T FindVisualChild<T>( DependencyObject obj ) where T : DependencyObject {
            for (int i = 0; i < VisualTreeHelper.GetChildrenCount( obj ); i++) {
                DependencyObject child = VisualTreeHelper.GetChild( obj, i );

                if (child is T) {
                    return (T)child;
                } else {
                    child = FindVisualChild<T>( child );
                    if (child != null) {
                        return (T)child;
                    }
                }
            }
            return null;
        }

    }

    public static class UIExtensions {

        public static void Refresh( this ListBox listBox ) {
            listBox.Items.Refresh();
            listBox.FocusListBoxItem( listBox.SelectedItem );
        }

        public static void FocusListBoxItem( this ListBox listBox, object item ) {
            ListBoxItem lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            if (lbi == null) {
                listBox.ScrollIntoView( item );
                lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            }
            listBox.SelectedItem = item;
            lbi.Focus();
        }

        public static object FirstVisibleItem( this ListBox listBox ) {
            if (listBox.Items.Count == 0) return null;
            VirtualizingStackPanel panel = UIHelpers.FindVisualChild<VirtualizingStackPanel>( listBox );
            if (panel == null) return null;
            int offset = (panel.Orientation == Orientation.Horizontal) ? (int)panel.HorizontalOffset : (int)panel.VerticalOffset;
            return listBox.Items[offset];
        }

        public static void DoEvents( this Window window ) {
            window.Dispatcher.Invoke( DispatcherPriority.Background, new Action( delegate { } ) );
        }

        // https://stackoverflow.com/questions/2946954/make-listview-scrollintoview-scroll-the-item-into-the-center-of-the-listview-c
        public static void ScrollToCenterOfView( this ItemsControl itemsControl, object item ) {

            // Scroll immediately if possible
            if (!itemsControl.TryScrollToCenterOfView( item )) {
                // Otherwise wait until everything is loaded, then scroll
                if (itemsControl is ListBox) ((ListBox)itemsControl).ScrollIntoView( item );

                // 16.08.20 FS: no idea why use the Dispatcher.BeginInvoke - - makes the screen flicker
                itemsControl.TryScrollToCenterOfView( item );
                //itemsControl.Dispatcher.BeginInvoke( DispatcherPriority.Loaded, new Action( () => itemsControl.TryScrollToCenterOfView( item ); ) );
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


    public class WindowCommand : ICommand {
        // https://stackoverflow.com/questions/1361350/keyboard-shortcuts-in-wpf
        private Window _window;

        //Set this delegate when you initialize a new object. This is the method the command will execute. You can also change this delegate type if you need to.
        public Action ExecuteDelegate { get; set; }

        //You don't have to add a parameter that takes a constructor. I've just added one in case I need access to the window directly.
        public WindowCommand( Window window ) {
            _window = window;
        }

        //always called before executing the command, mine just always returns true
        public bool CanExecute( object parameter ) {
            return true; //mine always returns true, yours can use a new CanExecute delegate, or add custom logic to this method instead.
        }

        public event EventHandler CanExecuteChanged; //i'm not using this, but it's required by the interface

        //the important method that executes the actual command logic
        public void Execute( object parameter ) {
            if (ExecuteDelegate != null) {
                ExecuteDelegate();
            } else {
                throw new InvalidOperationException();
            }
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
            TextBlock textBlock = d as TextBlock;
            if (textBlock == null) return;

            var formattedText = (string)e.NewValue ?? string.Empty;
            if (formattedText.StartsWith( "<")) {
                formattedText = string.Format( "<Span xml:space=\"preserve\" xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\">{0}</Span>", formattedText );

                textBlock.Inlines.Clear();
                using (var xmlReader = XmlReader.Create( new StringReader( formattedText ) )) {
                    var result = (Span)XamlReader.Load( xmlReader );
                    textBlock.Inlines.Add( result );
                }
            } else {
                textBlock.Text = formattedText;
            }
        }
    }
}
