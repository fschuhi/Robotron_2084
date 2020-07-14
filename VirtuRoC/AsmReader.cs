using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms.VisualStyles;
using Microsoft.VisualBasic.FileIO;
using System.Text.RegularExpressions;
using System.Reflection.Emit;

// add tests for MemoryLocation

namespace Robotron {


    class AsmLine {

        public enum LineTypeEnum { asm, EQ, ORG, BULK, BULK_CONT, DD1, DD2, STR, VAR, FILL, LongComment, BoxComment }

        int _lineno;

        public int Address = -1;
        public int BaseAddr = -1;
        public int ByteData = -1;
        //public int WordData = -1;
        public string WordData = "";

        public string Label = "";
        public string Identifier = "";
        public string EqValue = "";  // TODO: convert to object
        public string Opcode = "";
        public string Operand = "";
        public string BulkData = "";
        public string StringData = "";
        public string VariableName = "";
        public string VariableValue = "";   // TODO: convert to decimal, or tuple
        public string FillData = "";
        public string LongComment = "";
        public string BoxComment = "";

        public bool HasAddress { get { return Address != -1; } }
        public bool HasLabel { get { return Label != ""; } }
        public bool HasLocalLabel { get { return HasLabel && Label.StartsWith( "@" ); } }
        public bool HasGlobalLabel { get { return HasLabel && !HasLocalLabel; } }

        string[] _branches = { "BPL", "BMI", "BVC", "BVS", "BCC", "BCS", "BNE", "BEQ" };

        public bool IsBranch { get { return _branches.Contains( Opcode ); } }
        public bool IsJump { get { return Opcode == "JSR" || Opcode == "JMP"; } }

        public LineTypeEnum LineType { get; private set; }

        public string RawOffset { get; private set; }
        public string RawAddress { get; private set; }
        public string RawBytes { get; private set; }
        public string RawLabel { get; private set; }
        public string RawOpcode { get; private set; }
        public string RawOperand { get; private set; }
        public string RawComment { get; private set; }

        public AsmLine( int lineno, string[] fields ) {
            _lineno = lineno;

            this.RawOffset = fields[0].Trim();
            this.RawAddress = fields[1].Trim();
            this.RawBytes = fields[2].Trim();
            this.RawLabel = fields[3].Trim();
            this.RawOpcode = fields[4].Trim();
            this.RawOperand = fields[5].Trim();
            this.RawComment = fields[6].Trim();

            Update();
        }


        public static int StringToDecimal( string s ) {
            if (s == "") return -1;
            if (s.StartsWith( "$" ))
                return int.Parse( s.Substring( 1 ), System.Globalization.NumberStyles.HexNumber );
            else if (s.StartsWith( "#$" ))
                return int.Parse( s.Substring( 2 ), System.Globalization.NumberStyles.HexNumber );
            else if (s.StartsWith( "#" ))
                return Int32.Parse( s.Substring( 1 ) );
            else
                return Int32.Parse( s );
        }

        public static string DecimalToHexAddress( int addr ) {
            return $"${addr:X04}";
        }


        private void Update() {
            if (RawOpcode.StartsWith( "." ) || (RawOpcode == "+")) {
                UpdateSpecialOpcode();
                return;
            }

            if (RawOpcode == "") {
                if (RawAddress == "") {
                    if (RawLabel.StartsWith( ";" )) {
                        LineType = LineTypeEnum.LongComment;
                        LongComment = RawLabel;
                    } else if (RawLabel.StartsWith( "*" )) {
                        LineType = LineTypeEnum.BoxComment;
                        BoxComment = RawLabel;
                    }
                } else {
                    Debug.Assert( false );
                }
                return;
            } 

            UpdateNormalOpcode();
        }


        private void UpdateNormalOpcode() {
            // RawAddress doesn't have a leading $, add it because otherwise it is interpreted as decimal
            Address = StringToDecimal( "$" + RawAddress.ToUpper() );
            Opcode = RawOpcode.ToUpper();
            Label = RawLabel;
            Operand = RawOperand;
        }


        private void UpdateSpecialOpcode() {
            bool labelAllowed = true;

            switch (RawOpcode) {
                case "":
                    break;

                case ".eq":
                    LineType = LineTypeEnum.EQ;
                    Identifier = RawLabel;
                    EqValue = RawOpcode;
                    labelAllowed = false;
                    break;

                case ".org":
                    LineType = LineTypeEnum.ORG;
                    BaseAddr = StringToDecimal( RawOperand );
                    labelAllowed = false;
                    break;

                case ".bulk":
                    LineType = LineTypeEnum.BULK;
                    BulkData = RawOperand;
                    break;

                case "+":
                    LineType = LineTypeEnum.BULK_CONT;
                    BulkData = RawOperand;
                    labelAllowed = false;
                    break;

                case ".dd1":
                    LineType = LineTypeEnum.DD1;
                    ByteData = StringToDecimal( RawOperand );
                    break;

                case ".dd2":
                    LineType = LineTypeEnum.DD2;
                    // WordData = StringToDecimal( RawOperand );
                    WordData = RawOperand;
                    break;

                case ".str":
                    LineType = LineTypeEnum.STR;
                    StringData = RawOperand;
                    break;

                case ".var":
                    LineType = LineTypeEnum.VAR;
                    VariableName = RawLabel;
                    VariableValue = RawOperand;
                    labelAllowed = false;
                    break;

                case ".fill":
                    LineType = LineTypeEnum.FILL;
                    FillData = RawOperand;
                    break;

                default:
                    Debug.Assert( false, "unknown opcode " + RawOpcode );
                    break;

            }

            if (labelAllowed) {
                Label = RawLabel;
            }
        }
    }

    class AsmReader {

        public List<AsmLine> AsmLines = new List<AsmLine>();
        public Dictionary<int, AsmLine> AsmLinesByAddress = new Dictionary<int, AsmLine>();
        public Dictionary<string, AsmLine> AsmLinesByGlobalLabel = new Dictionary<string, AsmLine>();

        public Dictionary<string, Regex> OperandRegexesByPattern = new Dictionary<string, Regex>();

        private void AddRegex( string pattern ) {
            Regex rx = new Regex( pattern, RegexOptions.Compiled | RegexOptions.IgnoreCase );
            OperandRegexesByPattern.Add( pattern, rx );
        }

        private void AddRegexes() {
            // indirekt JMP
            AddRegex( @"^\$[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]$" );
            AddRegex( @"^\$[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9][A-Za-z0-9],x$" );
            AddRegex( @"^\$[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9][A-Za-z0-9],y$" );
            AddRegex( @"^#\$[A-Za-z0-9][A-Za-z0-9]$" );
            AddRegex( @"^\$[A-Za-z0-9][A-Za-z0-9]$" );
            AddRegex( @"^A$" );
            AddRegex( @"^\([^$]+\),y$" );
            AddRegex( @"^\([^$]+,x\)$" );
            AddRegex( @"^[^$]+,x$" );
            AddRegex( @"^[^$]+,y$" );
            AddRegex( @"^[^$]+[+-][0-9]+$" );
            AddRegex( @"^#[^$]+$" );
        }

        private bool MatchesOperandRegex( string operand ) { 
            foreach ( KeyValuePair<string,Regex> entry in OperandRegexesByPattern ) {
                Regex rx = (Regex)entry.Value;
                if (rx.IsMatch(operand)) {
                    return true;
                }
            }
            return false;
        }

        public AsmReader( string filename ) {

            AddRegexes();

            var fs = new FileStream( filename, FileMode.Open, FileAccess.Read );
            TextFieldParser parser = new TextFieldParser( fs );
            parser.Delimiters = new string[] { "," };

            int lineno = 0;

            while (!parser.EndOfData) {
                string[] fields = parser.ReadFields();
                AsmLine asmLine = new AsmLine( ++lineno, fields );
                AsmLines.Add( asmLine );

                if (asmLine.HasAddress)
                    AsmLinesByAddress.Add( asmLine.Address, asmLine );

                if (asmLine.HasGlobalLabel) {
                    // Trace.WriteLine( asmLine.Label );
                    AsmLinesByGlobalLabel.Add( asmLine.Label, asmLine );
                }

                if (asmLine.Operand != "") {
                    if ( !MatchesOperandRegex( asmLine.Operand )) {

                        if (asmLine.IsBranch || asmLine.IsJump) {
                            //
                        } else {
                            Trace.WriteLine( asmLine.Operand );
                        }

                        // uppercase opcode
                    }
                }

            }
            parser.Close();

            // ResolveLocalLabels();

            // link branches and jumps
            // resolve operands

            Trace.WriteLine( AsmLine.DecimalToHexAddress( AsmLinesByGlobalLabel["roboNoises"].Address ) );

        }

        private void ResolveLocalLabels() {
            Trace.WriteLine( AsmLines.Count );
            int lineno = 0;
            foreach (AsmLine asmLine in AsmLines) {
                ++lineno;
                if (asmLine.Label.StartsWith( "@" )) {
                    Trace.WriteLine( lineno.ToString() + " " + asmLine.Label );
                }
            }
        }

    }
}
