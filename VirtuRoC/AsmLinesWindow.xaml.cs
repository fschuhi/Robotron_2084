﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Microsoft.VisualBasic;

namespace Robotron {

    public enum ScrollMode { Default, Smooth, ScrollToCenterOfView, ScrollIntoView }

    public class AsmListBoxItem {
        public AsmLine AsmLine { get; set; }
        public int ItemIndex { get; set; }
        public string LineStatus { get; set; }
    }

    public class AddressItem : AsmListBoxItem {
        public string Address { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }

        public string Instruction { get; set; }
        public string InstructionColor { get; set; }

        public string Operand { get; set; }

        public string Comment { get; set; }
        public string CommentColor { get; set; }

        public bool IsEvaluated { get; set; }
        public string Evaluation { get; set; }
        public string EvaluationColor { get; set; }
    }

    public class CommentItem : AsmListBoxItem {
        public string CommentLine { get; set; }
    }

    /// <summary>
    /// Interaction logic for Window1.xaml
    /// </summary>
    public partial class AsmLinesWindow : Window {

        public AsmReader AsmReader;
        ScrollMode _defaultScrollMode = ScrollMode.ScrollToCenterOfView;

        public AsmLinesWindow() {
            InitializeComponent();

            AsmReader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );

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
                            CommentLine = asmLine.Comment,
                        };
                        break;

                    case AsmLineType.OpcodeLine:
                    case AsmLineType.DirectiveLine:
                        newItem = new AddressItem() {
                            Address = Padded( asmLine.Address, 5 ),
                            Bytes = Padded( asmLine.Bytes, 15 ),
                            Label = Padded( asmLine.Label, 20 ),
                            Comment = Padded( asmLine.Comment, 60 ),
                            CommentColor = "Gray",
                            EvaluationColor = "Blue",
                        };
                        break;

                    default:
                        continue;
                }
                AddressItem addressItem = newItem as AddressItem;

                switch (asmLine.LineType) {
                    case AsmLineType.OpcodeLine:
                        addressItem.Instruction = Padded( asmLine.Opcode, 6 );
                        addressItem.Operand = Padded( asmLine.OperandArgument.Operand, 40, paddedOperand => ColorOpcodeOperand( asmLine, paddedOperand ) );
                        addressItem.InstructionColor = InstructionColor( asmLine );
                        break;

                    case AsmLineType.DirectiveLine:
                        addressItem.Instruction = Padded( asmLine.Directive, 6 );
                        addressItem.Operand = Padded( asmLine.DirectiveArgument.Operand, 40 );
                        addressItem.InstructionColor = "DarkMagenta";
                        break;
                }

                Debug.Assert( newItem != null );

                newItem.AsmLine = asmLine;
                _items.Add( newItem );
                _itemsByAsmLine.Add( asmLine, newItem );

                newItem.ItemIndex = itemIndex;

                if (itemIndex % 20 == 0 ) { 
                    newItem.LineStatus = "<Run Foreground=\"Red\">abcd</Run>"; 
                }

                itemIndex++;
            }
        }

        private string Padded( string padded, int padding, Func<string, string> convert = null ) {
            padded = padded ?? "";
            padded = (padded.Length <= padding) ? padded.PadRight( padding ) : padded.Substring( 0, padding - 1 ) + "…";
            return (convert == null) ? padded : convert( padded );
        }

        string InstructionColor( AsmLine asmLine ) {
            if (asmLine.IsBranchOperation()) return "Blue";
            if ("jmp jsr rts".Contains( asmLine.Opcode )) return "Red";
            return "Black";
        }
        
        private string ColorOpcodeOperand( AsmLine asmLine, string paddedOperand ) {
            if (asmLine.HasOperandArgument()) {
                if (asmLine.OperandArgument.HasLabel()) {
                    if (!(asmLine.IsJumpOperation() || asmLine.IsBranchOperation() || asmLine.Opcode == "rts")) {
                        string label = asmLine.OperandArgument.Label;
                        paddedOperand = "<Span>" + paddedOperand.Replace( label, "<Run Foreground=\"DarkOrange\">" + label + "</Run>" ).Replace( "&", "&amp;" ) + "</Span>";
                    }
                }
            }
            return paddedOperand.Replace( "&", "&amp;" );
        }
        #endregion


        #region scrolling

        public void ScrollToAddress( int address, ScrollMode scrollMode = ScrollMode.Default ) {
            AsmLine asmLine;
            if (!AsmReader.AsmLineByAddressDictionary().TryGetValue( address, out asmLine )) return;
            AsmListBoxItem scrollItem = _itemsByAsmLine[asmLine];
            ScrollToItem( scrollItem, scrollMode );
        }

        private void ScrollToItem( AsmListBoxItem scrollItem, ScrollMode scrollMode ) {

            if (scrollMode == ScrollMode.Default) scrollMode = _defaultScrollMode;

            switch (scrollMode) {
                case ScrollMode.ScrollIntoView:
                    listBox.ScrollIntoView( scrollItem );
                    break;

                case ScrollMode.ScrollToCenterOfView:
                    listBox.ScrollToCenterOfView( scrollItem );
                    break;

                case ScrollMode.Smooth:

                    try {
                        SuspendKeyboardShortcuts();

                        var scrollViewer = UIHelpers.GetScrollViewer( listBox ) as ScrollViewer;
                        AsmListBoxItem firstItem = listBox.FirstVisibleItem() as AsmListBoxItem;
                        int firstItemIndex = firstItem.ItemIndex;

                        int lastItemIndex = firstItemIndex + (int)scrollViewer.ViewportHeight;
                        AsmListBoxItem lastItem = _items[lastItemIndex];

                        int scrollIndex = scrollItem.ItemIndex;
                        bool alreadyVisible = scrollIndex >= firstItemIndex && scrollIndex <= lastItemIndex;
                        if (!alreadyVisible) {
                            int offsets = scrollIndex - firstItemIndex;
                            int count = Math.Abs( offsets );

                            int originalStep;
                            if (count < 20) originalStep = 1;
                            else if (count < 100) originalStep = 2;
                            else if (count < 200) originalStep = 3;
                            else if (count < 500) originalStep = 5;
                            else if (count < 1000) originalStep = 10;
                            else originalStep = 20;

                            originalStep = offsets > 0 ? originalStep : -originalStep;

                            int step = originalStep;
                            for (int offset = 0; Math.Abs( offset ) < Math.Abs( offsets ); offset += step) {
                                if (Math.Abs( step ) > 1) {
                                    double share = 1 - (double)offset / (double)offsets;
                                    step = (int)(share * originalStep);

                                    // make sure we always have a valid step
                                    if (step == 0) step = originalStep / Math.Abs( originalStep );
                                    //Console.WriteLine( step );
                                }
                                scrollViewer.ScrollToVerticalOffset( scrollViewer.VerticalOffset + step );
                                this.DoEvents();
                            }
                            listBox.ScrollIntoView( scrollItem );
                            /*
                            // TODO: remove "flicker"
                            for (int offset = 0; offset < 10; offset++) {
                                scrollViewer.ScrollToVerticalOffset( scrollViewer.VerticalOffset - 1 );
                                this.DoEvents();
                            }
                            */
                        }
                    } finally {
                        ResumeKeyboardShortcuts();
                    }
                    break;
            }
            listBox.FocusListBoxItem( scrollItem );
        }
        #endregion


        #region keyboard shortcuts
        private void RegisterGesture( Action executeDelegate, Key key, ModifierKeys modifiers ) {
            InputBindings.Add( new KeyBinding( new WindowCommand( this ) { ExecuteDelegate = executeDelegate }, new KeyGesture( key, modifiers ) ) );
        }

        public void CreateKeyboardShortcuts() {
            RegisterGesture( NavigateLabel, Key.N, ModifierKeys.Alt );
            RegisterGesture( TestToggleEvaluation, Key.V, ModifierKeys.Alt );
            RegisterGesture( GotoAddress, Key.G, ModifierKeys.Control );
            RegisterGesture( TestLiveItemChange, Key.I, ModifierKeys.Alt | ModifierKeys.Control | ModifierKeys.Shift );
            RegisterGesture( GotoMainEntryPoint, Key.E, ModifierKeys.Control );
            RegisterGesture( FollowJump, Key.Right, ModifierKeys.Alt );
            RegisterGesture( FollowJumpImmediate, Key.Right, ModifierKeys.Alt | ModifierKeys.Control );
            RegisterGesture( ReturnFromJump, Key.Left, ModifierKeys.Alt );
            RegisterGesture( ReturnFromJumpImmediate, Key.Left, ModifierKeys.Alt | ModifierKeys.Control );
            RegisterGesture( GotoNextLabel, Key.Down, ModifierKeys.Alt );
            RegisterGesture( GotoPreviousLabel, Key.Up, ModifierKeys.Alt );
        }

        public void SuspendKeyboardShortcuts() { InputBindings.Clear(); }
        public void ResumeKeyboardShortcuts() { CreateKeyboardShortcuts(); }

        AsmListBoxItem _lastItem;

        private void OnPeekLabel( string label ) {
            _lastItem = listBox.SelectedItem as AsmListBoxItem;
            int address = AsmReader.AddressByLabelDictionary()[label];
            // TODO: scrolling bedeutet eigentlich immer: Refresh() afterwards, oder?
            ScrollToAddress( address, ScrollMode.ScrollToCenterOfView );
            listBox.Refresh();
        }

        private void OnUndoPeekLabel( string label ) {
            this.ScrollToItem( _lastItem, ScrollMode.ScrollToCenterOfView );
        }

        public void NavigateLabel() {
            NavigationTargetsWindow wnd2 = new NavigationTargetsWindow( OnPeekLabel, OnUndoPeekLabel );
            List<string> labels = AsmReader.Labels();
            wnd2.PopulateListbox( labels );
            wnd2.ShowDialog();
            listBox.Refresh();
        }

        public void TestToggleEvaluation() {
            foreach (AsmListBoxItem item in _items) {
                AddressItem addressItem = item as AddressItem;
                if (addressItem != null ) {
                    if (addressItem.IsEvaluated ) {
                        addressItem.IsEvaluated = false;
                    } else {
                        addressItem.IsEvaluated = true;
                        addressItem.Evaluation = "ertwert";
                    }
                }
            }
            listBox.Refresh();
        }

        private void GotoAddress() {
            string input = Interaction.InputBox( "Address (hex)", "Goto Address", "", 100, 100 ).Trim();
            int address = input.ToDecimal();
            ScrollToAddress( address, ScrollMode.Smooth );
        }

        private void TestLiveItemChange() {
            ((CommentItem)_items[0]).CommentLine = "sdfasdf";
            listBox.Refresh();
        }

        private void GotoMainEntryPoint() {
            ScrollToAddress( 0x4000, ScrollMode.Smooth );
        }

        // TODO: nicht Stack sondern List für jump navigation
        Stack<int> _addressStack = new Stack<int>();

        private AsmLine SelectedAsmLine() {
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            return item.AsmLine;
        }

        private void FollowJump() {
            AsmLine asmLine = SelectedAsmLine();
            if (!asmLine.IsJumpOperation()) return;
            _addressStack.Push( asmLine.DecimalAddress );

            string label = asmLine.OperandArgument.Label;
            int address;
            if (!AsmReader.AddressByLabelDictionary().TryGetValue( label, out address )) return;
            ScrollToAddress( address, ScrollMode.Smooth );
        }

        private void FollowJumpImmediate() {
            AsmLine asmLine = SelectedAsmLine();
            if (!asmLine.IsJumpOperation()) return;
            _addressStack.Push( asmLine.DecimalAddress );

            string label = asmLine.OperandArgument.Label;
            int address;
            if (!AsmReader.AddressByLabelDictionary().TryGetValue( label, out address )) return;
            ScrollToAddress( address, ScrollMode.ScrollToCenterOfView );
        }

        private void ReturnFromJump() {
            if (_addressStack.Count == 0) return;
            int address = _addressStack.Pop();
            ScrollToAddress( address, ScrollMode.Smooth );
        }

        private void ReturnFromJumpImmediate() {
            if (_addressStack.Count == 0) return;
            int address = _addressStack.Pop();
            ScrollToAddress( address, ScrollMode.ScrollToCenterOfView );
        }

        private void GotoNextLabel() {
            AsmListBoxItem item = listBox.SelectedItem as AsmListBoxItem;
            AsmLine asmLine = item.AsmLine;
            int index = asmLine.Index+1;
            while (index < AsmReader._asmLines.Count) {
                asmLine = AsmReader._asmLines[index];
                if (asmLine.IsMemoryMapped() && asmLine.HasLabel()) {
                    ScrollToAddress( asmLine.DecimalAddress, ScrollMode.Smooth );
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
                    ScrollToAddress( asmLine.DecimalAddress, ScrollMode.Smooth );
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

        private void listBox_PreviewKeyDown( object sender, KeyEventArgs e ) {
            // weird effect on Ctrl-Up/Ctrl-Down: cursor moves (including selected-color) but also previously selected line stays colored
            switch (e.Key) {
                case Key.Up:
                case Key.Down:
                    e.Handled = Keyboard.IsKeyDown( Key.LeftCtrl );
                    break;
            }
        }
    }

}
