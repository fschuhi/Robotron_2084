using Jellyfish.Virtu;
using Jellyfish.Virtu.Services;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// https://stackoverflow.com/questions/37825662/how-to-save-the-whole-windows-form-as-image-vb-net

namespace VirtuRoC {
    
    class SpriteTableEntry {
        int _index;
        int _baseAddr;

        public SpriteTableEntry( int index, int baseAddr ) {
            _index = index;
            _baseAddr = baseAddr;
        }

        private byte ReadByte( int addr ) {
            return (byte)SpriteTable.Memory.ReadDebug( addr );
        }

        private byte ReadEntryByte( int offset ) {
            return ReadByte( _baseAddr + offset );
        }

        int GetStrobeAddr( int strobe ) {
            Debug.Assert( strobe >= 0 && strobe < 7 );
            int offset = (strobe + 1) * 2;
            return ReadEntryByte( offset ) | (ReadEntryByte( offset+1 ) << 8);
        }

        private void SaveStrobeToFile(int strobe, StreamWriter strobeFile) {
            int strobeAddr = GetStrobeAddr( strobe );
            for (byte offset = 0; offset < Length; offset++) {
                int addr = strobeAddr + offset;
                byte decimalValue = ReadByte( addr );
                // string line = string.Format( CultureInfo.InvariantCulture, "strobe;{0};{1};{2};{3}", addr, strobe, offset, b );
                string line = string.Join( ";", new int[] { _index, _baseAddr, strobe, offset, addr, decimalValue } );
                strobeFile.WriteLine( line );
            }
        }

        public void SaveStrobesToFile( StreamWriter strobesFile ) {
            for ( int strobe=0; strobe < 7; strobe++ ) {
                SaveStrobeToFile( strobe, strobesFile );
            }
        }

        public void SaveToFile( StreamWriter entriesFile ) {
            int[] strobeAddr = new int[7];
            for ( int strobe=0; strobe < 7; strobe++ ) {
                strobeAddr[strobe] = GetStrobeAddr( strobe );
            }
            string line = string.Join( ";", new int[] { _index, _baseAddr, Width, Height, Length } ) + ";" + string.Join( ";", strobeAddr );
            entriesFile.WriteLine( line );
        }

        byte Width { get { return ReadEntryByte( 0 ); } }
        byte Height { get { return ReadEntryByte( 1 ); } }
        int Length { get { return Width * Height; } }

    }


    class SpriteTable {
        public static Memory Memory;
        public List<SpriteTableEntry> Entries = new List<SpriteTableEntry>();

        public SpriteTable( Memory memory, int baseAddr ) {

            // for now we don't work with different sprite tables, just the one starting at $7a00
            Debug.Assert( baseAddr == 0x7a00 );

            // we cannot used fixed [] memory, because the ram in Memory is partioned in pieces which are accessed via ReadBanked()
            // thus make the Memory available for the entries, so that we do not have to pass the Memory in the constructor
            Memory = memory;

            // each sprite entry is #$0F bytes long; last byte of the last entry if $7ddf
            int index = 0;
            for ( ; baseAddr < 0x7de0; baseAddr += 0x10 ) {
                Entries.Add( new SpriteTableEntry( index, baseAddr ) );
                index++;
            }
        }

        public void SaveEntriesToFile( string filename ) {
            using (StreamWriter entriesFile = new StreamWriter( filename )) {
                foreach ( SpriteTableEntry entry in Entries ) {
                    entry.SaveToFile( entriesFile );
                }
            }
        }

        public void SaveStrobesToFile( string filename ) {
            using (StreamWriter strobesFile = new StreamWriter( filename )) {
                foreach (SpriteTableEntry entry in Entries) {
                    entry.SaveStrobesToFile( strobesFile );
                }
            }
        }

    }
}
