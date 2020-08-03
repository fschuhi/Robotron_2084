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
            return _addressByLabel[label];
        }

        private AsmLine GetAsmLineByAddress( int addr ) {
            return _asmLineByAddress[addr];
        }

        public string OpcodeLineKey( int addr ) {
            AsmLine line = GetAsmLineByAddress( addr );
            Debug.Assert( line.Is6502Operation() );
            return line.Offset + " " + line.Address;
        }
    }

}
