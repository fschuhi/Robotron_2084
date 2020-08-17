using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.VisualBasic;

namespace Robotron {

    public class AsmListBoxItem {
        public AsmLine AsmLine { get; set; }
        public int ItemIndex { get; set; }
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

        public Window1() {
            InitializeComponent();

            AsmReader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );

            PaddingConverter.Window = this;
            IndentConverter.Window = this;
            OperandConverter.Window = this;

            PopulateListbox();

            listBox.ItemsSource = _items;
            listBox.SelectedIndex = 0;
            listBox.Focus();

            CreateKeyboardShortcuts();
        }

        #region populate listbox
        List<AsmListBoxItem> _items = new List<AsmListBoxItem>();

        Dictionary<AsmLine, AsmListBoxItem> _itemsByAsmLine = new Dictionary<AsmLine, AsmListBoxItem>();

        public void PopulateListbox() {
            int itemIndex = 0;
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

                    newItem.ItemIndex = itemIndex;
                    itemIndex++;

                    if (asmLine.HasOperandArgument()) {
                        AddressItem addressItem = newItem as AddressItem;
                        Debug.Assert( asmLine.OperandArgument != null );
                        string operand = asmLine.OperandArgument.Operand ?? "";
                        operand = operand.PadRight( 40 );
                        if (asmLine.OperandArgument.HasLabel()) {
                            if (!(asmLine.IsJumpOperation() || asmLine.IsBranchOperation() || asmLine.Opcode == "rts")) {
                                string label = asmLine.OperandArgument.Label;
                                operand = "<Span>" + operand.Replace( label, "<Run Foreground=\"DarkOrange\">" + label + "</Run>" ).Replace( "&", "&amp;" ) + "</Span>";
                            }
                        }
                        addressItem.Operand = operand;
                    }
                }
            }


        }

        string InstructionColor( AsmLine asmLine ) {
            if (asmLine.IsBranchOperation()) return "Blue";
            if ("jmp jsr rts".Contains( asmLine.Opcode )) return "Red";
            return "Black";
        }
        #endregion


        #region scrolling

        bool _scrolling = false;

        public void ScrollToAddress( int address, bool center = true ) {
            AsmLine asmLine;
            if (!AsmReader.AsmLineByAddressDictionary().TryGetValue( address, out asmLine )) return;
            AsmListBoxItem scrollItem = _itemsByAsmLine[asmLine];
            ScrollToItem( scrollItem, center );
        }

        private void FocusItem( AsmListBoxItem item ) {
            ListBoxItem lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            if (lbi == null) {
                listBox.ScrollIntoView( item );
                lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            }
            lbi.Focus();
        }

        private void ScrollToItem2( AsmListBoxItem item, bool center = true ) {
            if (item == null) return;

            if (center) {
                listBox.ScrollToCenterOfView( item );
            } else {
                listBox.ScrollIntoView( item );
            }

            FocusItem( item );
        }

        private void ScrollToItem( AsmListBoxItem scrollItem, bool center = true ) {
            if (_scrolling) return;
            try {
                _scrolling = true;

                var scrollViewer = UIHelpers.GetScrollViewer( listBox ) as ScrollViewer;
                AsmListBoxItem firstItem = listBox.FirstVisibleItem() as AsmListBoxItem;
                int firstItemIndex = firstItem.ItemIndex;

                int lastItemIndex = firstItemIndex + (int)scrollViewer.ViewportHeight;
                AsmListBoxItem lastItem = _items[lastItemIndex];

                int scrollIndex = scrollItem.ItemIndex;
                bool alreadyVisible = scrollIndex >= firstItemIndex && scrollIndex <= lastItemIndex;
                if (alreadyVisible) {
                    FocusItem( scrollItem );
                } else {
                    int offsets = scrollIndex - firstItemIndex;
                    int originalStep = offsets > 0 ? 20 : -20;
                    int step = originalStep;
                    for (int offset = 0; Math.Abs( offset ) < Math.Abs( offsets ); offset += step) {
                        if (Math.Abs( step ) > 1) {
                            double share = 1 - (double)offset / (double)offsets;
                            step = (int)(share * originalStep);

                            // make sure we always have a valid step
                            if (step == 0) step = originalStep / Math.Abs(originalStep);
                            //Console.WriteLine( step );
                        }
                        scrollViewer.ScrollToVerticalOffset( scrollViewer.VerticalOffset + step );
                        this.DoEvents(); 
                    }
                    listBox.ScrollIntoView( scrollItem );
                    for (int offset = 0; offset < 10; offset++) {
                        scrollViewer.ScrollToVerticalOffset( scrollViewer.VerticalOffset - 1 );
                        this.DoEvents();
                    }
                    FocusItem( scrollItem );
                }
            } finally {
                _scrolling = false;
            }
        }
        #endregion


        #region keyboard shortcuts
        private void RegisterGesture( Action executeDelegate, KeyGesture gesture) {
            InputBindings.Add( new KeyBinding( new WindowCommand( this ) { ExecuteDelegate = executeDelegate }, gesture ) );
        }

        public void CreateKeyboardShortcuts() {

            //add a new key-binding, and pass in your command object instance which contains the Execute method which WPF will execute
            RegisterGesture( GotoAddress, new KeyGesture( Key.G, ModifierKeys.Control ) );
            RegisterGesture( GotoMainEntryPoint, new KeyGesture( Key.E, ModifierKeys.Control ) );
            RegisterGesture( FollowJump, new KeyGesture( Key.Right, ModifierKeys.Alt ) );
            RegisterGesture( ReturnFromJump, new KeyGesture( Key.Left, ModifierKeys.Alt ) );
            RegisterGesture( GotoNextLabel, new KeyGesture( Key.Down, ModifierKeys.Alt ) );
            RegisterGesture( GotoPreviousLabel, new KeyGesture( Key.Up, ModifierKeys.Alt ) );
        }

        private void GotoAddress() {
            if (_scrolling) return;
            string input = Interaction.InputBox( "Address (hex)", "Goto Address", "", 100, 100 ).Trim();
            int address = input.ToDecimal();
            ScrollToAddress( address );
        }

        private void GotoMainEntryPoint() {
            ScrollToAddress( 0x4000 );
        }

        // TODO: nicht Stack sondern List für jump navigation
        Stack<int> _addressStack = new Stack<int>();

        private AsmLine SelectedAsmLine() {
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            return item.AsmLine;
        }

        private void FollowJump() {
            if (_scrolling) return;
            AsmLine asmLine = SelectedAsmLine();
            if (!asmLine.IsJumpOperation()) return;
            _addressStack.Push( asmLine.DecimalAddress );

            string label = asmLine.OperandArgument.Label;
            int address;
            if (!AsmReader.AddressByLabelDictionary().TryGetValue( label, out address )) return;
            ScrollToAddress( address );
        }

        private void ReturnFromJump() {
            if (_scrolling) return;
            if (_addressStack.Count == 0) return;
            int address = _addressStack.Pop();
            ScrollToAddress( address );
        }

        private void GotoNextLabel() {
            if (_scrolling) return;
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            AsmLine asmLine = item.AsmLine;
            int index = asmLine.Index+1;
            while (index < AsmReader._asmLines.Count) {
                asmLine = AsmReader._asmLines[index];
                if (asmLine.IsMemoryMapped() && asmLine.HasLabel()) {
                    ScrollToAddress( asmLine.DecimalAddress, false );
                    return;
                }
                index++;
            }
        }

        private void GotoPreviousLabel() {
            if (_scrolling) return;
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            AsmLine asmLine = item.AsmLine;
            int index = asmLine.Index - 1;
            while (index >= 0) {
                asmLine = AsmReader._asmLines[index];
                if (asmLine.IsMemoryMapped() && asmLine.HasLabel()) {
                    ScrollToAddress( asmLine.DecimalAddress, false );
                    return;
                }
                index--;
            }
        }
        #endregion


        #region events
        private void TextBlock_MouseUp( object sender, MouseButtonEventArgs e ) {
            MessageBox.Show( "yes" );
        }

        private void listBox_KeyDown( object sender, KeyEventArgs e ) {
            bool IsShiftKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Shift );
            bool IsAltKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Alt );
            bool IsControlKey = Keyboard.Modifiers.HasFlag( ModifierKeys.Control );
            if (IsShiftKey && IsAltKey && IsControlKey) {
                AsmListBoxItem item = (AsmListBoxItem)listBox.SelectedItem;
                if (item is AddressItem) {
                    AddressItem addressItem = (AddressItem)item;
                    MessageBox.Show( addressItem.Address );
                    int addr = AsmReader.AddressByLabelDictionary()["chooseControls"];
                    ScrollToAddress( addr );
                }
            }
        }
        #endregion
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
            return int.TryParse( parameter.ToString(), out padding ) 
                ? (str.Length < padding ? str.PadRight( padding ) : str.Substring( 0, padding - 1 ) + "…")
                : str;
        }
    }


    public class IndentConverter : AsmListBoxItemConverter {
        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            string str = (string)value ?? "";
            int padding;
            return int.TryParse( parameter.ToString(), out padding ) 
                ? (new String( ' ', padding )) + str 
                : str;
        }
    }


    public class OperandConverter : AsmListBoxItemConverter {

        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            var lbi = (ListBoxItem)value;
            AsmListBoxItem item = (AsmListBoxItem)lbi.Content;

            AddressItem addressItem = item as AddressItem;
            string operand = addressItem.Operand ?? "";

            Console.WriteLine( operand );

            int padding;
            operand = int.TryParse( parameter.ToString(), out padding ) ? operand.PadRight( padding ) : operand;

            AsmLine asmLine = item.AsmLine;
            if (asmLine.HasOperandArgument()) {
                if (asmLine.OperandArgument.HasLabel()) {
                    if (!(asmLine.IsJumpOperation() || asmLine.IsBranchOperation() || asmLine.Opcode == "rts" )) {
                        string label = asmLine.OperandArgument.Label;
                        operand = operand.Replace( label, "<Run Foreground=\"DarkOrange\">" + label + "</Run>" );
                    }
                }
            }
            

            return operand.Replace( "&", "&amp;" );
        }
    }
    #endregion

}
