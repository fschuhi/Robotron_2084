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
        List<RecordedExecutedOperation> _executed;
        Dictionary<int, List<RecordedMemoryOperation>> _readsByAddress;
        Dictionary<int, Tuple<int, int>> _readCountsByAddress;
        Dictionary<int, Tuple<int, int>> _writeCountsByAddress;
        Dictionary<int, Tuple<int, int>> _executedCountsByAddress;


        public XlWorkbench() {
            _reader = new AsmReader( @"s:\source\repos\Robotron_2084\Disassemblies\Robotron (Apple).asm" );

            using (var reader = new StreamReader( @"s:\source\repos\Robotron_2084\VirtuRoX\tmp\MemoryOperations.csv" ))
            using (var csv = new CsvReader( reader, Thread.CurrentThread.CurrentCulture )) {
                _records = csv.GetRecords<RecordedMemoryOperation>().ToList();
            }

            _readsByAddress = _records
                .Where( info => info.Type == RecordedOperationType.Read )
                .GroupBy( info => info.Address )
                .ToDictionary( group => group.Key, group => group.ToList() );

            _readCountsByAddress = _records
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

            using (var reader = new StreamReader( @"s:\source\repos\Robotron_2084\VirtuRoX\tmp\ExecutedOperations.csv" ))
            using (var csv = new CsvReader( reader, Thread.CurrentThread.CurrentCulture )) {
                _executed = csv.GetRecords<RecordedExecutedOperation>().ToList();
            }
            _executedCountsByAddress = _executed
                .Where( info => info.Type == RecordedOperationType.Executed )
                .GroupBy( info => info.OpcodeRPC )
                .Select( group => new Tuple<int, int>( group.Key, group.Count() ) )
                .OrderBy( x => x.Item1 )
                .ToDictionary( x => x.Item1 );
        }

        public object[,] GetReads( long firstCycles, long lastCycles ) {
            var bla = _records
                .Where( info => info.Type == RecordedOperationType.Read && info.Cycles >= firstCycles && info.Cycles <= lastCycles )
                .GroupBy( info => info.Address )
                .OrderBy( x => x.Key )
                .ToDictionary( group => group.Key, group => group.ToList() );
            object[,] result = new object[bla.Count, 2];
            int row = 0;
            foreach (KeyValuePair<int,List<RecordedMemoryOperation>> keyValuePair in bla) {
                result[row, 0] = keyValuePair.Key.ToHex( true );
                result[row, 1] = string.Join( ", ", keyValuePair.Value.Select( x => RobotronObject.DecimalToHexNum( x.Value, true )));
                row++;
            }
            return result;
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

        public object[,] GetExecutedCounts( int baseOpcodeRPC, int bytes ) {
            object[,] counts = new object[1, bytes];
            for (int offset = 0; offset < bytes; offset++) {
                int address = baseOpcodeRPC + offset;
                Tuple<int, int> tuple;
                counts[0, offset] = _executedCountsByAddress.TryGetValue( address, out tuple ) ? tuple.Item2 : 0;
            }
            return counts;
        }

        public string GetAsmLineByIndex( int index ) {
            AsmLine line = _reader._asmLines[index];
            return line.Line;
        }

        public string GetAsmLineByAddress( int address ) {
            try {
                return _reader.AsmLineByAddressDictionary()[address].Line;
            } catch {
                return $"#unknown address {address}";
            }
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
