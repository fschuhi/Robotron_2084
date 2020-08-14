using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace Robotron {

    public class AsmService {
        AsmReader _asmReader;
        Dictionary<string, int> _addressByLabel;
        Dictionary<int, string> _labelByAddress;
        Dictionary<int, AsmLine> _asmLineByAddress;

        public AsmService() {
            _asmReader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            _addressByLabel = _asmReader.AddressByLabelDictionary();
            _labelByAddress = _asmReader.LabelByAddressDictionary();
            _asmLineByAddress = _asmReader.AsmLineByAddressDictionary();
        }

        public string SafeGetLabel( int address ) {
            return _labelByAddress.ContainsKey( address ) ? _labelByAddress[address] : $"${address:X4}";
        }

        public int GetAddress( string label ) {
            int addr = -1;
            _addressByLabel.TryGetValue( label, out addr );
            return addr;
        }

        private AsmLine GetAsmLineByAddress( int addr ) {
            AsmLine line = null;
            _asmLineByAddress.TryGetValue( addr, out line );
            return line;
        }

        public string OpcodeLineKey( int addr ) {
            AsmLine line = GetAsmLineByAddress( addr );
            Debug.Assert( line.Is6502Operation() );
            return line.Offset + " " + line.Address;
        }

        public string Opcode( int addr ) {
            AsmLine line = GetAsmLineByAddress( addr );
            Debug.Assert( line.Is6502Operation() );
            return line.Opcode;
        }

        public string OperandLabel( int addr ) {
            AsmLine line = GetAsmLineByAddress( addr );
            Debug.Assert( line.Is6502Operation() );
            return line.OperandArgument.Label;
        }
    }

}
