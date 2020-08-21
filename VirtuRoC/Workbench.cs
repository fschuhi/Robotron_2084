using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using WindowsInput.Native;
using WindowsInput;
using Stateless;
using System.IO;
using CommandLine;
using System.Runtime.InteropServices;
using FastColoredTextBoxNS;
using System.Windows.Forms;
using CsvHelper;
using System.Globalization;
using System.Threading;
using System.Linq;

// TODO: how to use the Asm-Button on the MainPage? Probably an event...


namespace Robotron {

    #region recording
    public enum RecordedOperationType { Executed, Read, Write }

    public class RecordedOperation {
        public long Cycles { get; set; }
        public RecordedOperationType Type { get; set; }
        public long OpcodeRPC { get; set; }
    }

    public class RecordedMemoryOperation : RecordedOperation {
        public int Address { get; set; }
        public int Value { get; set; }
        public int OldValue { get; set; }
    }

    public class RecordedExecutedOperation : RecordedOperation {
        public int Opcode { get; set; }
        public int EA { get; set; }
        public int RPC { get; set; }
        public int RA { get; set; }
        public int RX { get; set; }
        public int RY { get; set; }
        public int RP { get; set; }
        public int RS { get; set; }
    }

    public class RecordedOperations {

        public List<RecordedOperation> Operations = new List<RecordedOperation>();
        Cpu _cpu;

        public RecordedOperations( Machine machine ) {
            _cpu = machine.Cpu;
        }

        public void Store( RecordedOperationType type, int address, int value, int oldValue = 0 ) {
            Operations.Add( new RecordedMemoryOperation() {
                Cycles = _cpu.Cycles,
                OpcodeRPC = _cpu.OpcodeRPC,
                Type = type,
                Address = address,
                Value = value,
                OldValue = type == RecordedOperationType.Write ? oldValue : value,
            } );
        }

        public void Read( int address, int value ) {
            Store( RecordedOperationType.Read, address, value );
        }

        public void Write( int address, int value, int oldValue ) {
            Store( RecordedOperationType.Write, address, oldValue );

            // TODO: hier delegates (oder events? nochmal das GC Thema suchen), RecordedOperations -> Workbench
            // TODO: track opcodes (R..., auch OpcodeRPC und Cycles)
            // TODO: breakpoint @ cycles => MessageBox in regelmäßigen Abständen, damit wir uns nicht totsammeln
        }

        public void Executed( Cpu cpu ) {
            Operations.Add( new RecordedExecutedOperation() {
                Cycles = _cpu.Cycles,
                OpcodeRPC = _cpu.OpcodeRPC,
                Type = RecordedOperationType.Executed,
                Opcode = _cpu.OpCode,
                EA = _cpu.EA,
                RPC = _cpu.RPC,
                RA = _cpu.RA,
                RX = _cpu.RX,
                RY = _cpu.RY,
                RP = _cpu.RP,
                RS = _cpu.RS,
            } );
        }

        public IEnumerable<RecordedMemoryOperation> MemoryOperations {
            get { return Operations.Where( x => x is RecordedMemoryOperation ).Select( x => x as RecordedMemoryOperation ); }
        }
        public IEnumerable<RecordedExecutedOperation> ExecutedOperations {
            get { return Operations.Where( x => x is RecordedExecutedOperation ).Select( x => x as RecordedExecutedOperation ); }
        }
    }
    #endregion
    
    
    class Workbench : RobotronObject {

        public MachineOperator _mo;
        public Memory _mem;
        public Cpu _cpu;

        public AsmService AsmService { get; private set; }
        public Options _options;
        WorkbenchScript1 _script;

        public RecordedOperations RecordedOperations;

        AsmLinesWindow _window1;

        public Workbench( MachineOperator mo, Options options ) {
            _mo = mo;
            _mo.OnLoaded += mo_OnLoaded;
            _mo.OnClosing += mo_OnClosing;
            _mo.OnPaused += mo_OnPause;
            _options = options;
            AsmService = new AsmService();
            RecordedOperations = new RecordedOperations( _mo.Machine );

            _mem = _mo.Machine.Memory;
            _cpu = _mo.Machine.Cpu;

            /*
            _mem.OnRead += mem_OnRead;
            _mem.OnReadZeroPage += mem_OnRead;
            _mem.OnWrite += mem_OnWrite;
            _mem.OnWriteZeroPage += mem_OnWrite;
            _cpu.OnExecuted += cpu_OnExecuted;
            */
        }

        private void DoAction() {
            _window1 = new AsmLinesWindow();
            _window1.Show();
        }

        private void mo_OnLoaded( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnLoaded" );

            _mo.MainPage.AsmAction = DoAction;

            _window1 = new AsmLinesWindow();
            _window1.Show();
            _window1.ScrollToAddress( 0x4000 );

            _script = new WorkbenchScript1( this );
        }

        private void mo_OnClosing( MachineOperator mo ) {
            TraceLine( "Workbench: mo_OnClosing" );
            _script.TearDown( mo );
        }

        private void mo_OnPause( MachineOperator mo, PausedEventArgs e ) {
            _script.mo_OnPause( mo, e );

            /*
            TraceLine( $"executed: {_executed}, reads: {_reads}, writes: {_writes}" );
            using (var writer = new StreamWriter( @"s:\source\repos\Robotron_2084\VirtuRoC\tmp\Operations.csv" ))
            using (var csv = new CsvWriter( writer, Thread.CurrentThread.CurrentCulture )) {
                csv.WriteRecords( RecordedOperations.MemoryOperations );
                //csv.WriteRecords( RecordedOperations.ExecutedOperations );
            }
            */

            _window1.ScrollToAddress( e.BreakpointRCP );

            // TODO: Warum brauchen wir hier auch ein MainPage.Focus() ?
            _mo.MainPage.Focus();
        }


        long _reads;
        long _writes;
        long _executed;

        private void mem_OnRead( int address, int value ) {
            _reads++;
            RecordedOperations.Read( address, value );
        }

        private void mem_OnWrite( int address, int value, int oldValue ) {
            _writes++;
            RecordedOperations.Write( address, value, oldValue );
        }

        private void cpu_OnExecuted( Cpu cpu ) {
            _executed++;
            RecordedOperations.Executed( cpu );
        }

    }
}