using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Reflection;
using System.Linq;
using System.Windows.Navigation;
using System.Security.AccessControl;
using System.Threading;
using System.Runtime.CompilerServices;
using System.Windows;

namespace Robotron {

    public class AsmReader : RobotronObject {

        List<string> _inputLines;
        public List<AsmLine> _asmLines = new List<AsmLine>();

        Dictionary<string, int> _addressByLabel;
        Dictionary<int, string> _labelByAddress;

        public AsmReader( string filename ) {
            _inputLines = new List<string>( File.ReadAllLines( filename ) );

            foreach (string line in _inputLines) {
                AsmLine asmLine = new AsmLine( line, _asmLines.Count );
                _asmLines.Add( asmLine );
            }

            _addressByLabel = AddressByLabelDictionary();
            _labelByAddress = LabelByAddressDictionary();

            // all JSR have labels as subroutine address
            ValidateJsrCalls();
        }

        public string CanonicalStringAddress( string address ) {
            int decimalAddress = HexToDecimal( address );
            if (_labelByAddress.ContainsKey( decimalAddress )) {
                return _labelByAddress[decimalAddress];
            } else {
                return "$" + address;
            }
        }

        public Dictionary<int,AsmLine> AsmLineByAddressDictionary() {
            return _asmLines.Where( c => c.IsMemoryMapped() ).ToDictionary( x => x.DecimalAddress, x => x );
        }

        public Dictionary<string, int> AddressByLabelDictionary() {
            return _asmLines
                .Where( c => c.IsMemoryMapped() && c.HasLabel() )
                .ToDictionary(
                    c => c.IsLocalLabel() ? c.Label + "-" + c.Address : c.Label,
                    c => c.DecimalAddress );
        }

        public Dictionary<int, string> LabelByAddressDictionary() {
            return _asmLines
                .Where( c => c.IsMemoryMapped() && c.HasLabel() )
                .ToDictionary(
                    c => c.DecimalAddress,
                    c => c.IsLocalLabel() ? c.Label + "-" + c.Address : c.Label );
        }

        public void ValidateJsrCalls() {
            IEnumerable<AsmLine> nullLines = _asmLines.Where( l => l.Opcode == "jsr" && l.OperandArgument.Label == null );
            Debug.Assert( nullLines.Count() == 0 );
        }

        public IEnumerable<(int, string)> JsrCalls() {
            return _asmLines.Where( c => c.Opcode == "jsr" ).Select( c => (c.DecimalAddress, c.OperandArgument.Label) );
        }

        public List<string> UniqueJsrTargets() {
            return JsrCalls().Select( c => c.Item2 == null ? "<null - shouldn't happen>" : c.Item2 ).Distinct().ToList();
        }

        public ILookup<string, int> JsrCallersLookup() {
             return JsrCalls().ToLookup( c => c.Item2, c => c.Item1 );
        }

        public Dictionary<string, List<int>> JsrCallersByTargetDictionary() {
            //Dictionary<string, List<string>> dict1 = calls.GroupBy( x => x.Item2 ).ToDictionary( g => g.Key, l => l.Select( j => j.Item1 ).ToList() );
            Dictionary<string, List<int>> dict2 = JsrCallersLookup().ToDictionary( g => g.Key, l => l.ToList() );
            return dict2;
        }

        public void SaveToFile( string jsonfilename ) {
            string output = JsonConvert.SerializeObject( _inputLines );
            File.WriteAllText( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\asm.json", output );
        }


        public void Test1() {
            var list2 = AsmLineByAddressDictionary();
            var line = list2[0x4610];
            Debug.Assert( !line.Bytes.Contains( "+" ) );
            var bytes = line.Bytes.Trim();

            //bytes.Split( ' ' ).Select( b => b.ToDecimal() ).ToList().ForEach( c => TraceLine( c ) );

            line.BytesList.ForEach( c => TraceLine( c ) );
            TraceLine();

            line = list2[0x800];
            line.BytesList.ForEach( c => TraceLine( c ) );

            var branches = _asmLines.Where( l => l.IsBranchOperation() ).Select( c => (c.DecimalAddress, c.Opcode, c.BranchTarget()) );
            var calls = _asmLines.Where( l => l.Opcode == "jsr" ).Select( c => (c.DecimalAddress, c.Opcode, c.JsrTarget()) );
            var returns = _asmLines.Where( l => l.Opcode == "rts" ).Select( c => (c.DecimalAddress, c.Opcode, -1) );
            var jumps = _asmLines.Where( l => l.Opcode == "jmp" ).Select( c => (c.DecimalAddress, c.Opcode, c.JmpTarget()) );

            //jumps.ToList().ForEach( c => TraceLine( c.Item1.ToHex(), c.Item2, c.Item3.ToHex() ) );

            var RPCchanges = branches.Concat( calls ).Concat( returns ).Concat( jumps ).ToList();
            TraceLine( branches.Count(), calls.Count(), returns.Count(), jumps.Count(), RPCchanges.Count() );
            RPCchanges.Sort();

            RPCchanges.ToList().ForEach( c => TraceLine( c.Item1.ToHex(), c.Item2, c.Item3.ToHex() ) );

            //Test2();
        }

        public void Test2() {
            var targets = UniqueJsrTargets();
            TraceNewLine( targets.Count(), string.Join( ", ", targets.ToArray() ) );

            var calls = JsrCalls();
            TraceNewLine( calls.Count() );

            var lookup = JsrCallersLookup();
            var lookupResult = lookup["eraseHulk"];
            TraceNewLine( "eraseHulk:", string.Join( ", ", lookupResult.ToArray() ) );
        }
    }


    public enum AsmLineType { CommentLine, AssignmentLine, DirectiveLine, OpcodeLine, OrgLine };

    public class AsmLineTemplate {
        public AsmLineType LineType { get; set; }
        public Regex Regex { get; set; }
        public string[] Values { get; set; }
    }

    public class AsmLine {

        public AsmLineType LineType { get; set; }

        public int Index { get; set; }
        public string Line { get; set; }
        public bool Matched { get; set; }
        public bool Empty { get; set; }

        public string Offset { get; set; }
        //public string Address4 { get; set; }
        public string Address { get; set; }
        public string Bytes { get; set; }
        public string Label { get; set; }
        public string Opcode { get; set; }
        public string Directive { get; set; }
        public string Type { get; set; }
        public string Comment { get; set; }

        public string Operation { get { return Opcode != "" ? Opcode : Directive; } }

        private int _decimalAddress = -1;
        public int DecimalAddress { get {
                if (_decimalAddress == -1 ) {
                    _decimalAddress = Address.ToDecimal();
                }
                return _decimalAddress;
            } }

        public AsmArgument Argument { get; set; }
        public bool HasArgument() { return Argument != null; }
        public bool HasDirectiveArgument() { return HasArgument() && Argument is DirectiveArgument; }
        public bool HasOperandArgument() { return HasArgument() && Argument is OperandArgument; }
        public bool IsMemoryMapped() { return Offset != null; }
        public bool Is6502Operation() { return Opcode != null; }
        public bool IsDirective() { return Directive != null; }

        public bool HasLabel() { return Label != ""; }
        public bool IsGlobalLabel() { return HasLabel() && Label.StartsWith( "@" ); }
        public bool IsLocalLabel() { return HasLabel() && Label.StartsWith( "@" ); }
        public bool IsBranchOperation() { return Is6502Operation() && "beqbnebccbcsbmibpl".Contains( Opcode ); }
        public bool IsJumpOperation() { return Is6502Operation() && (Opcode == "jsr" || Opcode == "jmp"); }

        public DirectiveArgument DirectiveArgument { get { return HasDirectiveArgument() ? (DirectiveArgument)Argument : null; } }
        public OperandArgument OperandArgument { get { return HasOperandArgument() ? (OperandArgument)Argument : null; } }

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
        static string address4 = @"(?<Address>[0-9a-f]{4})";  // intentionally also "Address"
        static string address = @"(?<Address>[0-9a-f]{1,4})"; // intentionally also "Address"
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

        static AsmLine() {
            AddTemplate( AsmLineType.OpcodeLine, $@"^\+{offset} {address4}: {bytes} *(\s{label})?\s *{opcode}($|\s+)", "Offset", "Address", "Bytes", "Label", "Opcode" );
            AddTemplate( AsmLineType.CommentLine, $@"^ *{commentLine}$", "Comment" );
            AddTemplate( AsmLineType.OrgLine, $@"^ *{org} +\${address}", "Address" );
            AddTemplate( AsmLineType.AssignmentLine, $@"^ *{label} +{assignment} +\${address}", "Label", "Directive", "Address" );
            AddTemplate( AsmLineType.DirectiveLine, $@"^\+{offset} {address4}: {bytes} *(\s{label})?\s *{directive}($|\s+)", "Offset", "Address", "Bytes", "Label", "Directive" );
        }

        public AsmLine( string line, int index ) {
            Index = index;
            Line = line;
            MatchLine();
        }

        private void MatchLine() {
            Empty = Line.Trim() == "";
            if (Empty) {
                Matched = false;
                return;
            }

            bool success = false;

            foreach (AsmLineTemplate template in _templates) {

                Match match = template.Regex.Match( Line );
                success = match.Success;
                if (success) {

                    // step 1: save information about line (up to opcode/directive)
                    LineType = template.LineType;
                    RegexHelpers.Transfer( this, match, template.Values );

                    // step 2: save argument of opcode/directive
                    string rest = Line.Substring( match.Length ).Trim();
                    switch (LineType) {
                        case AsmLineType.DirectiveLine:
                            Argument = new DirectiveArgument( Directive, ref rest );
                            Dump();
                            break;
                        case AsmLineType.OpcodeLine:
                            Argument = new OperandArgument( Opcode, ref rest );
                            break;
                    }

                    // We use "Comment" for both the complete comment line, as well as tailing ; comments
                    // must not overwrite the comment line w/ an (then empty/null) tailing comment
                    if (LineType != AsmLineType.CommentLine) 
                        Comment = RegexHelpers.MatchValue( CommentRegex, rest, "Comment" );
                    break;
                }

            }
            Matched = success;
        }

        private List<int> _bytesList;

        public List<int> BytesList {
            get {
                if (_bytesList == null) {
                    List<int> bytesList;
                    if (Is6502Operation()) {
                        bytesList = Bytes.Trim().Split( ' ' ).Select( b => b.ToDecimal() ).ToList();
                    } else {
                        Debug.Assert( IsDirective() );
                        switch (Directive) {
                            case ".bulk":
                                string str = DirectiveArgument.Bytes.Trim();
                                int chunkSize = 2;
                                IEnumerable<string> bulkBytes = Enumerable.Range( 0, str.Length / chunkSize ).Select( i => str.Substring( i * chunkSize, chunkSize ) );
                                bytesList = bulkBytes.Select( b => b.ToDecimal() ).ToList();
                                break;
                            default:
                                bytesList = null;
                                break;
                        }
                        if (Directive == ".bulk") {
                        } else {
                        }
                    }
                    _bytesList = bytesList;
                }
                return _bytesList;
            }
        }

        public int BranchTarget() {
            if (!IsBranchOperation()) return -1;
            int operandRPC = DecimalAddress + 1;
            int operand = BytesList[1];
            return (operandRPC + 1 + (sbyte)operand) & 0xFFFF;
        }

        public int JsrTarget() {
            return BytesList[1] | (BytesList[2] << 8);
        }
        public int JmpTarget() {
            return BytesList[1] | (BytesList[2] << 8);
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
                    DirectiveArgument arg = (DirectiveArgument)Argument;
                    if (Directive == ".fill") {
                        //Trace.WriteLine( $"${this.Address4} .fill {arg.FillCount},{arg.FillValue}" );
                    }
                    break;
            }
        }
    }


    public abstract class AsmArgument { }

    public enum MatchedDirectiveType { dd1, dd2, str, bulk, fill }

    public class DirectiveArgument : AsmArgument {
        public string Operand { get; set; }
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

        static DirectiveArgument() {
            AddRegex( MatchedDirectiveType.dd1, ".dd1", number, "Number" );
            AddRegex( MatchedDirectiveType.dd2, ".dd2", $@"{number}|{label}", "Number", "Label" );
            AddRegex( MatchedDirectiveType.str, ".str", stringArgument, "String" );
            AddRegex( MatchedDirectiveType.bulk, ".bulk", bytes, "Bytes" );
            AddRegex( MatchedDirectiveType.fill, ".fill", fillArgument, "FillCount", "FillValue" );
        }

        public DirectiveArgument( string operation, ref string rest ) {
            (MatchedDirectiveType type, Regex re, string[] values) = _regexes[operation];
            Match match = re.Match( rest );
            if (match.Success) {
                Operand = match.Value.Trim();
                MatchedDirectiveType = type;
                RegexHelpers.Transfer( this, match, values );
                rest = rest.Substring( match.Length ).Trim();
            }
        }
    }


    public enum MatchedOperandType { Immediate, IndirectX, IndirectY, AbsoluteX, AbsoluteY, Absolute, Accumulator }

    public class OperandArgument : AsmArgument {

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
                new Regex( $@"^{pattern}(\s|$)", RegexOptions.Compiled ), 
                values));
        }

        static string hexNumber = @"(?<Hexnum>\$[0-9a-f]+)";
        static string decimalNumber = @"(?<Decnum>[0-9]+)";
        static string label = @"(?<Label>@?_?[A-Za-z0-9_]+\??)";
        static string address = @"(?<Address>\$[0-9a-f]{1,4})";
        static string labelOraddress = $@"({label}|{address})(?<Offset>[+-][0-9$]+)?";

        static string immediate = $@"(?<Immediate>#({hexNumber}|{decimalNumber}|{label}))";  // lda #$00
        static string indirectX = $@"(?<IndirectX>\({labelOraddress},x\))";
        static string indirectY = $@"(?<IndirectY>\({labelOraddress}\),y)";
        static string absoluteX = $@"(?<AbsoluteX>{labelOraddress},x)";
        static string absoluteY = $@"(?<AbsoluteY>({labelOraddress}),y)";
        static string absolute = $@"(?<Absolute>{labelOraddress})";
        static string accumulator = @"(?<Accumulator>A)";

        static OperandArgument() {
            AddRegex( MatchedOperandType.Immediate, immediate, "Immediate", "Hexnum", "Decnum", "Label" );
            AddRegex( MatchedOperandType.IndirectX, indirectX, "IndirectX", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.IndirectY, indirectY, "IndirectY", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.AbsoluteX, absoluteX, "AbsoluteX", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.AbsoluteY, absoluteY, "AbsoluteY", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.Absolute, absolute, "Absolute", "Label", "Address", "Offset" );
            AddRegex( MatchedOperandType.Accumulator, accumulator, "Accumulator" );
        }

        public bool HasLabel() {
            return Label != null && Label != "";
        }

        public OperandArgument( string opcode, ref string rest ) {
            for (int index = 0; index < _regexes.Count; index++ ) {
                (MatchedOperandType type, Regex re, string[] values) = _regexes[index];
                Match match = re.Match( rest );
                if (match.Success) {
                    Operand = match.Value.Trim();
                    MatchedOperandType = type;
                    RegexHelpers.Transfer( this, match, values );
                    if (rest.StartsWith( "kbdMovementDir,y" )) {
                        //Trace.WriteLine( "yes" );
                    }
                    rest = rest.Substring( match.Length ).Trim();
                    return;
                }
            }
            if (rest != "" && !rest.StartsWith(";")) MessageBox.Show( "/" + rest + "/" );
        }
    }
}