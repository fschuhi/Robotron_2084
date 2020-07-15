using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace Robotron {

    abstract class RStretch {
        public abstract int FirstAddress();
        public abstract int LastAddress();
        public abstract bool IsFirstInStretch();
        public abstract bool IsLastInStretch();
    }

    class RByte : RStretch {
        //private RMemory _memory;
        private string _label = null;

        public int Address { get; private set; }

        public override int FirstAddress() { return Address; }
        public override int LastAddress() { return Address; }
        public override bool IsFirstInStretch() { return true; }
        public override bool IsLastInStretch() { return true; }

        public string Label { get { return _label; } }
        
        //public HashSet<string> Labels;

        public RByte( int address, int value = 0 ) {
            Address = address;
        }

        public void AssignLabel( string label ) {

        }
    }

    class RMemory {
        SortedList<int, RByte> _bytes = new SortedList<int, RByte>();
        Dictionary<string, RByte> _labels = new Dictionary<string, RByte>();

        public RByte AddByte( int address ) {
            RByte value;
            if (!_bytes.TryGetValue( address, out value )) {
                value = new RByte( address );
            }
            return value;
        }
    }

    class MemoryLocation {

        public string Label = "";
        public int Address = -1;

        static Regex _rxSimpleAddress = new Regex( @"^\$([0-9A-Z][0-9A-Z][0-9A-Z]?[0-9A-Z])?$", RegexOptions.Compiled | RegexOptions.IgnoreCase );
        static Regex _rxAddressWithOffset = new Regex( @"^\$([0-9A-Z][0-9A-Z][0-9A-Z]?[0-9A-Z]?)([+-])([0-9]+)$", RegexOptions.Compiled | RegexOptions.IgnoreCase );
        static Regex _rxSimpleLabel = new Regex( @"^([A-Z_])+$", RegexOptions.Compiled | RegexOptions.IgnoreCase );
        static Regex _rxLabelWithOffset = new Regex( @"^([A-Z_]+)([+-])([0-9]+)$", RegexOptions.Compiled | RegexOptions.IgnoreCase );

        public MemoryLocation( string loc ) {
            Debug.Assert( !loc.StartsWith( "#" ), "not a memory location " );

            loc = loc.Trim();

            if (_rxSimpleAddress.IsMatch( loc )) {

            } else {
                // must be a label
                Label = loc;
            }
        }
    }
}
