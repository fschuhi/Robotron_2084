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
using System.Diagnostics;
using FastColoredTextBoxNS;
using System.Text.RegularExpressions;
using WindowsInput;
using WindowsInput.Native;
using System.Reflection;

namespace Robotron {
    public partial class AsmForm : Form {
        public AsmForm() {
            InitializeComponent();
        }

        Style GreenStyle = new TextStyle( Brushes.Green, null, FontStyle.Italic );
        Style LightBlueStyle = new TextStyle( Brushes.LightBlue, null, FontStyle.Regular );
        Style LightPinkStyle = new TextStyle( Brushes.LightPink, null, FontStyle.Regular );
        Style OrangeStyle = new TextStyle( Brushes.Orange, null, FontStyle.Regular );


        private void fastColoredTextBox1_Load( object sender, EventArgs e ) {
            fctb.Text = File.ReadAllText( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            fctb.AllowInsertRemoveLines = false;
            fctb.CommentPrefix = ";|*";            
        }

        public AsmService AsmService { get; set; }

        private int iLine { get { return fctb.Selection.Start.iLine; } }
        private string Line { get { return fctb.Lines[iLine]; } }
        Func<string, bool> isWhitespace = ( line ) => line.Trim() == "" || line.StartsWith( " " );

        private int GetAddressFromCurrentLine() {
            string line = Line;
            Match match = Regex.Match( Line, @"^\+[0-9a-f]+ ([0-9a-f][0-9a-f][0-9a-f][0-9a-f])" );
            return !match.Success ? -1 : match.Groups[1].Value.ToDecimal();
        }

        Stack<int> _browseStack = new Stack<int>();

        private void fastColoredTextBox1_KeyDown( object sender, KeyEventArgs e ) {

            if (e.Control && (e.KeyCode == Keys.Down || e.KeyCode == Keys.Up)) {

                bool currentLineIsWhitespace = isWhitespace( fctb.Lines[iLine] );
                Func<string, bool> skipLine = ( line ) => currentLineIsWhitespace ? isWhitespace( line ) : ! isWhitespace( line );
                
                int ixLine = iLine;

                if (e.KeyCode == Keys.Down) {
                    while (ixLine < fctb.Lines.Count && skipLine( fctb.Lines[ixLine] )) 
                        ixLine++;
                } else {
                    while (ixLine > 0 && skipLine( fctb.Lines[ixLine] ))
                        ixLine--;
                }

                fctb.Selection.Start = new Place( 0, ixLine );
            }

            if (e.Alt && (e.KeyCode == Keys.Left || e.KeyCode == Keys.Right)) {

                if (e.KeyCode == Keys.Right) {
                    int opcodeAddr = GetAddressFromCurrentLine();
                    if (opcodeAddr == -1) return;
                    if (! "jsr jmp".Contains( AsmService.Opcode( opcodeAddr ))) return;
                    string label = AsmService.OperandLabel( opcodeAddr );
                    int targetAddr = AsmService.GetAddress( label );
                    if (targetAddr == -1) return;
                    int iline = FindEditorLineIndexByAddress( targetAddr );
                    if (iline == -1) return;
                    fctb.Navigate( iline );

                    _browseStack.Push( opcodeAddr );
                } else {

                    if (_browseStack.Count == 0) return;
                    int opcodeAddr = _browseStack.Pop();
                    int iline = FindEditorLineIndexByAddress( opcodeAddr );
                    if (iline == -1) return;
                    fctb.Navigate( iline );
                }

            }
        }

        private int FindEditorLineIndexByAddress( int addr ) {
            string search = AsmService.OpcodeLineKey( addr );
            List<int> lines = fctb.FindLines( search, System.Text.RegularExpressions.RegexOptions.IgnoreCase );
            return (lines != null && lines.Count > 0) ? lines[0] : -1;
        }

        private void fctb_TextChanged( object sender, FastColoredTextBoxNS.TextChangedEventArgs e ) {

            // ; comment
            e.ChangedRange.ClearStyle( GreenStyle );
            e.ChangedRange.SetStyle( GreenStyle, @";.*$", RegexOptions.Multiline );

            // * comment
            e.ChangedRange.ClearStyle( LightBlueStyle );
            e.ChangedRange.SetStyle( LightBlueStyle, @"^\s*.+\*\s*$", RegexOptions.Multiline );

            // immediate
            e.ChangedRange.ClearStyle( LightPinkStyle );
            e.ChangedRange.SetStyle( LightPinkStyle, @"#\$?[0-9a-f][0-9a-f]", RegexOptions.IgnoreCase );

            // immediate
            e.ChangedRange.ClearStyle( OrangeStyle );
            e.ChangedRange.SetStyle( OrangeStyle, @"\s(jsr|jmp|rts)(\s|$)", RegexOptions.IgnoreCase );


        }
    }
}
