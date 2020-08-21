using CsvHelper;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace Robotron {

    class XlWorkbench {

        AsmReader _reader;
        List<RecordedMemoryOperation> _records;
        Dictionary<int, Tuple<int, int>> _readCountsByAddress;
        Dictionary<int, Tuple<int, int>> _writeCountsByAddress;

        public XlWorkbench() {
            _reader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );
            
            using (var reader = new StreamReader( @"s:\source\repos\Robotron_2084\VirtuRoX\tmp\MemoryOperations.csv" ))
            using (var csv = new CsvReader( reader, Thread.CurrentThread.CurrentCulture )) {
                _records = csv.GetRecords<RecordedMemoryOperation>().ToList();
            }

            _readCountsByAddress =_records
                .Where( info => info.Type == RecordedOperationType.Read)
                .GroupBy( info => info.Address)
                .Select( group => new Tuple<int, int>( group.Key, group.Count() ) )
                .OrderBy( x => x.Item1 )
                .ToDictionary( x => x.Item1 );

            _writeCountsByAddress = _records
                .Where( info => info.Type == RecordedOperationType.Write )
                .GroupBy( info => info.Address )
                .Select( group => new Tuple<int, int>( group.Key, group.Count() ) )
                .OrderBy( x => x.Item1 )
                .ToDictionary( x => x.Item1 );
        }

        public object[,] GetReadCounts( int baseAddress, int bytes ) {
            object[,] counts = new object[1, bytes];
            for (int offset = 0; offset < bytes; offset++) {
                int address = baseAddress + offset;
                Tuple<int, int> tuple;
                counts[0, offset] = _readCountsByAddress.TryGetValue( address, out tuple ) ? tuple.Item2 : 0;
            }
            return counts;
        }

        public object[,] GetWriteCounts( int baseAddress, int bytes ) {
            object[,] counts = new object[1, bytes];
            for (int offset = 0; offset < bytes; offset++) {
                int address = baseAddress + offset;
                Tuple<int, int> tuple;
                counts[0, offset] = _writeCountsByAddress.TryGetValue( address, out tuple ) ? tuple.Item2 : 0;
            }
            return counts;
        }

        public string GetAsmLine( int index ) {
            AsmLine line = _reader._asmLines[index];
            return line.Line;
        }

        public object[,] GetArray( int rows, int columns ) {
            object[,] result = new object[rows, columns];
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < columns; j++) {
                    result[i, j] = i + j;
                }
            }
            return result;
        }
    }

}
