using System;
using System.Collections.Generic;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using Microsoft.VisualBasic;

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


        }

        string InstructionColor( AsmLine asmLine ) {
            if (asmLine.IsBranchOperation()) return "Blue";
            if ("jmp jsr rts".Contains( asmLine.Opcode )) return "Red";
            return "Black";
        }
        #endregion


        #region scrolling
        private void ScrollToAddress( int address, bool center = true ) {
            AsmLine asmLine;
            if (!AsmReader.AsmLineByAddressDictionary().TryGetValue( address, out asmLine )) return;
            AsmListBoxItem scrollItem = _itemsByAsmLine[asmLine];
            ScrollToItem( scrollItem, center );
        }

        private void ScrollToItem( AsmListBoxItem item, bool center = true ) {
            if (item == null) return;

            if (center) {
                listBox.ScrollToCenterOfView( item );
            } else {
                listBox.ScrollIntoView( item );
            }

            ListBoxItem lbi = (ListBoxItem)listBox.ItemContainerGenerator.ContainerFromItem( item );
            lbi.Focus();
        }
        #endregion


        #region keyboard shortcuts
        private void RegisterGesture( Action executeDelegate, KeyGesture gesture) {
            InputBindings.Add( new KeyBinding( new WindowCommand( this ) { ExecuteDelegate = executeDelegate }, gesture ) );
        }

        public void CreateKeyboardShortcuts() {

            //add a new key-binding, and pass in your command object instance which contains the Execute method which WPF will execute
            RegisterGesture( GotoAddress, new KeyGesture( Key.G, ModifierKeys.Control ) );
            RegisterGesture( FollowJump, new KeyGesture( Key.Right, ModifierKeys.Alt ) );
            RegisterGesture( ReturnFromJump, new KeyGesture( Key.Left, ModifierKeys.Alt ) );
            RegisterGesture( GotoNextLabel, new KeyGesture( Key.Down, ModifierKeys.Alt ) );
            RegisterGesture( GotoPreviousLabel, new KeyGesture( Key.Up, ModifierKeys.Alt ) );
        }

        private void GotoAddress() {
            string input = Interaction.InputBox( "Address (hex)", "Goto Address", "", 100, 100 ).Trim();
            int address = input.ToDecimal();
            ScrollToAddress( address );
        }

        Stack<int> _addressStack = new Stack<int>();

        private void FollowJump() {
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            AsmLine asmLine = item.AsmLine;
            if (!asmLine.IsJumpOperation()) return;

            _addressStack.Push( asmLine.DecimalAddress );
            string label = asmLine.OperandArgument.Label;
            int address;
            if (!AsmReader.AddressByLabelDictionary().TryGetValue( label, out address )) return;
            ScrollToAddress( address );
        }

        private void ReturnFromJump() {
            if (_addressStack.Count == 0) return;
            int address = _addressStack.Pop();
            ScrollToAddress( address );
        }

        private void GotoNextLabel() {
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
