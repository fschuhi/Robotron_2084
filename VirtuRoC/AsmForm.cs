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

        private void fastColoredTextBox1_Load( object sender, EventArgs e ) {
            fctb.Text = File.ReadAllText( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            fctb.AllowInsertRemoveLines = false;
            fctb.CommentPrefix = ";|*";            
        }

        private int CurrentLine { get { return fctb.Selection.Start.iLine; } }
        Func<string, bool> isWhitespace = ( line ) => line.Trim() == "" || line.StartsWith( " " );

        private void fastColoredTextBox1_KeyDown( object sender, KeyEventArgs e ) {

            if (e.Control && (e.KeyCode == Keys.Down || e.KeyCode == Keys.Up)) {

                bool currentLineIsWhitespace = isWhitespace( fctb.Lines[CurrentLine] );
                Func<string, bool> skipLine = ( line ) => currentLineIsWhitespace ? isWhitespace( line ) : ! isWhitespace( line );
                
                int ixLine = CurrentLine;

                if (e.KeyCode == Keys.Down) {
                    while (ixLine < fctb.Lines.Count && skipLine( fctb.Lines[ixLine] )) 
                        ixLine++;
                } else {
                    while (ixLine > 0 && skipLine( fctb.Lines[ixLine] ))
                        ixLine--;
                }

                fctb.Selection.Start = new Place( 0, ixLine );
            }
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
        }
    }
}
