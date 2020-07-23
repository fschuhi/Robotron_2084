using System;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Reflection;
using System.Linq;

namespace Robotron {

    class AsmReader2 {

        List<string> _inputLines;
        List<AsmLine2> _asmLines = new List<AsmLine2>();

        public AsmReader2( string filename ) {
            _inputLines = new List<string>( File.ReadAllLines( filename ) );

            foreach (string line in _inputLines) {
                AsmLine2 asmLine = new AsmLine2();
                asmLine.MatchLine( line );
                _asmLines.Add( asmLine );
            }

            IEnumerable<AsmLine2> list = _asmLines.Where( c => c.HasOperandArgument() && (c.OperandAsmArgument.MatchedOperandType == MatchedOperandType.AbsoluteY) );
            Trace.WriteLine( list.Count() );
        }

        public void SaveToFile( string jsonfilename ) {
            string output = JsonConvert.SerializeObject( _inputLines );
            File.WriteAllText( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\asm.json", output );
        }
    }


    enum AsmLineType { CommentLine, AssignmentLine, DirectiveLine, OpcodeLine, OrgLine };

    class AsmLineTemplate {
        public AsmLineType LineType { get; set; }
        public Regex Regex { get; set; }
        public string[] Values { get; set; }
    }

    class AsmLine2 {

        public AsmLineType LineType { get; set; }

        public string Line { get; set; }
        public bool Matched { get; set; }
        public bool Empty { get; set; }

        public string Offset { get; set; }
        public string Address4 { get; set; }
        public string Address { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }
        public string Opcode { get; set; }
        public string Directive { get; set; }
        public string Type { get; set; }
        public string Comment { get; set; }

        public string Operation { get { return Opcode != "" ? Opcode : Directive; } }

        public AsmArgument Argument { get; set; }
        public bool HasArgument() { return Argument != null; }
        public bool HasDirectiveArgument() { return HasArgument() && Argument is DirectiveAsmArgument; }
        public bool HasOperandArgument() { return HasArgument() && Argument is OperandAsmArgument; }
        public DirectiveAsmArgument DirectiveAsmArgument { get { return HasDirectiveArgument() ? (DirectiveAsmArgument)Argument : null; } }
        public OperandAsmArgument OperandAsmArgument { get { return HasOperandArgument() ? (OperandAsmArgument)Argument : null; } }

        static string[] _dataDirectives = new string[] {
            @"\.bulk", @"\.dd1", @"\.dd2", @"\.fill", @"\.str"
        };

        static string[] _opcodes = new string[] {
            "lda", "ldx", "ldy",
            "sta", "stx", "sty",
            "cmp", "cpx", "cpy",
            "asl", "lsr", "rol", "ror",
            "and", "ora", "eor", "bit",
            "adc", "sbc",
            "clc", "sec",
            "beq", "bne", "bcc", "bcs", "bmi", "bpl",
            "inc", "inx", "iny", "dec", "dex", "dey",
            "pha", "pla", "php", "plp",
            "tax", "tay", "tya", "txa", "txs",
            "jmp", "jsr", "rts"
        };

        static string commentLine = @"(?<Comment>[;*].*)";
        static string directive = $@"(?<Directive>{string.Join( "|", _dataDirectives )})";
        static string opcode = $@"(?<Opcode>{ string.Join( "|", _opcodes )})";
        static string offset = @"(?<Offset>[0-9a-f]{6})";
        static string address4 = @"(?<Address4>[0-9a-f]{4})";
        static string address = @"(?<Address>[0-9a-f]{1,4})";
        static string bytes = @"(?<Bytes>([0-9a-f][0-9a-f][ +]){1,4})";
        static string label = @"(?<Label>@?_?[A-Za-z0-9_]+\??)";
        static string org = @"(?<Directive>\.org)";
        static string assignment = @"(?<Directive>\.(eq|var))";

        protected static List<AsmLineTemplate> _templates = new List<AsmLineTemplate>();

        static Regex CommentRegex = new Regex( @"(?<Comment>;.*)", RegexOptions.Compiled );

        public static AsmLineTemplate AddTemplate( AsmLineType lineType, string pattern, params string[] values ) {
            AsmLineTemplate template = new AsmLineTemplate {
                LineType = lineType,
                Regex = new Regex( pattern, RegexOptions.Compiled ),
                Values = values
            };
            _templates.Add( template );
            return template;
        }

        static AsmLine2() {
            AddTemplate( AsmLineType.OpcodeLine, $@"^\+{offset} {address4}: {bytes} *(\s{label})?\s *{opcode}($|\s+)", "Offset", "Address4", "Bytes", "Label", "Opcode" );
            AddTemplate( AsmLineType.CommentLine, $@"^ *{commentLine}$", "Comment" );
            AddTemplate( AsmLineType.OrgLine, $@"^ *{org} +\${address}", "Address" );
            AddTemplate( AsmLineType.AssignmentLine, $@"^ *{label} +{assignment} +\${address}", "Label", "Directive", "Address" );
            AddTemplate( AsmLineType.DirectiveLine, $@"^\+{offset} {address4}: {bytes} *(\s{label})?\s *{directive}($|\s+)", "Offset", "Address4", "Bytes", "Label", "Directive" );
        }

        public void MatchLine( string line ) {
            Debug.Assert( Line == null );
            Line = line;
            Empty = line.Trim() == "";
            if (Empty) {
                Matched = false;
                return;
            }

            bool success = false;

            foreach (AsmLineTemplate template in _templates) {

                Match match = template.Regex.Match( line );
                success = match.Success;
                if (success) {

                    // step 1: save information about line (up to opcode/directive)
                    LineType = template.LineType;
                    RegexHelpers.Transfer( this, match, template.Values );

                    // step 2: save argument of opcode/directive
                    string rest = Line.Substring( match.Length ).Trim();
                    switch (LineType) {
                        case AsmLineType.DirectiveLine:
                            Argument = new DirectiveAsmArgument( Directive, ref rest );
                            Dump();
                            break;
                        case AsmLineType.OpcodeLine:
                            Argument = new OperandAsmArgument( Opcode, ref rest );
                            break;
                    }

                    Comment = RegexHelpers.MatchValue( CommentRegex, rest, "Comment" );
                    break;
                }

            }
            Matched = success;
        }

        public void Dump() {
            switch (LineType) {
                case AsmLineType.AssignmentLine:
                    Trace.Write( $"{Label} {Directive} ${Address}" );
                    if (Type != "") Trace.Write( " " + Type );
                    if (Comment != "") Trace.Write( " " + Comment );
                    Trace.WriteLine( "" );
                    break;

                case AsmLineType.DirectiveLine:
                    DirectiveAsmArgument arg = (DirectiveAsmArgument)Argument;
                    if (Directive == ".fill") {
                        //Trace.WriteLine( $"${this.Address4} .fill {arg.FillCount},{arg.FillValue}" );
                    }
                    break;
            }
        }
    }


    abstract class AsmArgument { }

    public enum MatchedDirectiveType { dd1, dd2, str, bulk, fill }

    class DirectiveAsmArgument : AsmArgument {
        public string Number { get; set; }
        public string String { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }
        public string FillCount { get; set; }
        public string FillValue { get; set; }

        public MatchedDirectiveType MatchedDirectiveType;

        protected static Dictionary<string, (MatchedDirectiveType, Regex, string[])> _regexes = new Dictionary<string, (MatchedDirectiveType, Regex, string[])>();

        public static void AddRegex( MatchedDirectiveType type, string operation, string pattern, params string[] values ) {
            _regexes.Add( operation, (
                type,
                new Regex( $@"{pattern}(\s|$)", RegexOptions.Compiled ),
                values ));
        }

        static string hexNumber = @"(\$[0-9a-f]+)";
        static string decimalNumber = @"([0-9]+)";
        static string number = $@"{hexNumber}|{decimalNumber}";
        static string label = @"(?<Label>@?_?[A-Za-z0-9_]+\??)";
        static string stringArgument = @"“(?<String>[^”]*)”";
        static string bytes = @"(?<Bytes>[0-9a-f]+)";
        static string fillArgument = $@"(?<FillCount>{decimalNumber}),(?<FillValue>{number})";

        static DirectiveAsmArgument() {
            AddRegex( MatchedDirectiveType.dd1, ".dd1", number, "Number" );
            AddRegex( MatchedDirectiveType.dd2, ".dd2", $@"{number}|{label}", "Number", "Label" );
            AddRegex( MatchedDirectiveType.str, ".str", stringArgument, "String" );
            AddRegex( MatchedDirectiveType.bulk, ".bulk", bytes, "Bytes" );
            AddRegex( MatchedDirectiveType.fill, ".fill", fillArgument, "FillCount", "FillValue" );
        }

        public DirectiveAsmArgument( string operation, ref string rest ) {
            (MatchedDirectiveType type, Regex re, string[] values) = _regexes[operation];
            Match match = re.Match( rest );
            if (match.Success) {
                MatchedDirectiveType = type;
                RegexHelpers.Transfer( this, match, values );
                rest = rest.Substring( match.Length ).Trim();
            }
        }
    }

    public enum MatchedOperandType { Immediate, IndirectX, IndirectY, AbsoluteX, AbsoluteY, Absolute, Accumulator }

    class OperandAsmArgument : AsmArgument {

        public string Operand { get; set; }
        public string Hexnum { get; set; }
        public string Decnum { get; set; }
        public string Label { get; set; }
        public string Address { get; set; }
        public string Immediate { get; set; }
        public string Index { get; set; }
        public string IndirectX { get; set; }
        public string IndirectY { get; set; }
        public string AbsoluteX { get; set; }
        public string AbsoluteY { get; set; }
        public string Absolute { get; set; }
        public string Accumulator { get; set; }
        public string Offset { get; set; }

        public MatchedOperandType MatchedOperandType;
        protected static List<(MatchedOperandType, Regex,string[])> _regexes = new List<(MatchedOperandType, Regex,string[])>();

        public static void AddRegex( MatchedOperandType type, string pattern, params string[] values ) {
            _regexes.Add( (
                type,
                new Regex( $@"{pattern}(\s|$)", RegexOptions.Compiled ), 
                values));
        }

        static string hexNumber = @"(?<Hexnum>\$[0-9a-f]+)";
        static string decimalNumber = @"(?<Decnum>[0-9]+)";
        static string label = @"(?<Label>@?_?[A-Za-z0-9_]+\??)";
        static string address = @"(?<Address>[0-9a-f]{1,4})";
        static string labelOraddress = $@"({label}|{address})(?<Offset>[+-][0-9$]+)";

        static string immediate = $@"(?<Immediate>#({hexNumber}|{decimalNumber}))";  // lda #$00
        static string indirectX = $@"(?<IndirectX>\({labelOraddress},x\))";
        static string indirectY = $@"(?<IndirectY>\({labelOraddress}\),y)";
        static string absoluteX = $@"(?<AbsoluteX>{labelOraddress},x)";
        static string absoluteY = $@"(?<AbsoluteY>({label}|{address}),y)";
        static string absolute = $@"(?<Absolute>{label}|{address})";
        static string accumulator = @"(?<Accumulator>A)";

        static OperandAsmArgument() {
            AddRegex( MatchedOperandType.Immediate, immediate, "Immediate", "Hexnum", "Decnum" );
            AddRegex( MatchedOperandType.IndirectX, indirectX, "IndirectX", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.IndirectY, indirectY, "IndirectY", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.AbsoluteX, absoluteX, "AbsoluteX", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.AbsoluteY, absoluteY, "AbsoluteY", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.Absolute, absolute, "Absolute", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.Accumulator, accumulator, "Accumulator" );
        }

        public OperandAsmArgument( string opcode, ref string rest ) {
            for (int index = 0; index < _regexes.Count; index++ ) {
                (MatchedOperandType type, Regex re, string[] values) = _regexes[index];
                Match match = re.Match( rest );
                if (match.Success) {
                    Operand = match.Value.Trim();
                    MatchedOperandType = type;
                    RegexHelpers.Transfer( this, match, values );
                    if (rest.StartsWith( "kbdMovementDir,y" )) {
                        Trace.WriteLine( "yes" );
                    }
                    rest = rest.Substring( match.Length ).Trim();
                    return;
                }
            }
        }
    }


    class RegexHelpers {
        public static void Transfer( object obj, Match match, params string[] values ) {
            Type type = obj.GetType();
            foreach (string value in values) {
                PropertyInfo prop = type.GetProperty( value );
                Debug.Assert( prop != null, $"unknown property {value}" );
                prop.SetValue( obj, match.Groups[value].Value, null );
            }
        }

        public static string MatchValue( Regex regex, string target, string value ) {
            Match match = regex.Match( target );
            return match.Groups[value].Value;
        }
    }

}