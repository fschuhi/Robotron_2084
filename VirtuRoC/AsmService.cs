using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Robotron {

    public class AsmService {
        AsmReader _asmReader;
        Dictionary<string, int> _addressByLabel;
        Dictionary<int, string> _labelByAddress;

        public AsmService() {
            _asmReader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            _addressByLabel = _asmReader.AddressByLabelDictionary();
            _labelByAddress = _asmReader.LabelByAddressDictionary();
        }

        public string SafeGetLabel( int address ) {
            return _labelByAddress.ContainsKey( address ) ? _labelByAddress[address] : $"${address:X4}";
        }

        public int GetAddress( string label ) {
            return _addressByLabel[label];
        }
    }

}
