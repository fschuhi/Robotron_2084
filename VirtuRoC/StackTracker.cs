using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;

/*
 * OnJSR at the end of ExecuteJsr()
 * OnRTS at the beginning of ExecuteRts()
 * 
 * Problem: RPC at beginning of RTS is 1 after RTS opcode address, verfällt
 * 
 * ... both give me the possibility to change something on the stack, manipulate RPC etc.
 * 
 * JSR:
 * ----
 * RPC steht auf 1. Byte vom operand
 * RPC+1 => stack (1. push H, 2. push L)
 * set RPC to operand
 * 
 * TODO: derive return address from stack
 * 
 * RTS:
 * ----
 * address on stack is on 2. byte of operand
 * RPC = (Pull() + 1) + (Pull() << 8)
 * 
 * Push()
 * ------
 * start w/ #$3F, grows downward
 * 1. WriteZeroPage( 0x0100 + RS, data )
 * 2. RS = RS - 1
 * 
 * Pull()
 * ------
 * 1. RS = RS + 1
 * 2. ReadZeroPage( 0x100 + RS )
 * 
 */


namespace Robotron {

    public class JsrInfo {
        public int JsrOpcodeAddr { get; set; }
        public int JsrTargetAddr { get; set; }
        public int StackPtrAfterJsr { get; set; }
        public int StackPtrH { get { return StackPtrAfterJsr + 2; } }
        public int StackPtrL { get { return StackPtrAfterJsr + 1; } }

        public long CyclesAfterJsr { get; set; }
        public long CyclesAtRetire { get; set; }

        public StackByte JsrReturnAddrL { get; set; }
        public StackByte JsrReturnAddrH { get; set; }

        public int ReturnAddrOnStack { get { return JsrOpcodeAddr + 2; } }
        public int ExpectedRPCAfterRts { get { return ReturnAddrOnStack + 1; } }

        public bool Retired { get; set; }
    }


    public class StackByte : RobotronObject {
        public int StackPtr { get; private set; }
        public int Addr { get { return 0x100 + StackPtr; } }
        public long LastAssignedCycles { get; private set; }
        public long LastRetiredCycles { get; private set; }

        Memory _memory;
        public int Value { get { return _memory.ReadDebug( Addr ); } }

        public JsrInfo JsrInfo { get; private set; }
        public bool IsPartOfReturnAddr { get { return JsrInfo != null; } }
        public AddressPart ReturnAddrPart { get; private set; }

        public Stack<JsrInfo> _retiredJsrInfos = new Stack<JsrInfo>(); // TODO: make private
        public bool HasRetiredJsrInfos { get { return _retiredJsrInfos.Count > 0; } }

        public StackByte( Memory memory, int stackPtr ) {
            _memory = memory;
            StackPtr = stackPtr;
            LastAssignedCycles = -1;
        }

        public void ClearJsrPartInfo() {
            JsrInfo = null;
            ReturnAddrPart = AddressPart.NA;
        }

        public void SignalPH( long cycles ) {
            // semantics: in order to PH sth into here ("coming from above"), we needed to have a PL or RTS first ("going upwards")
            // PL and RTS clear jsr part info in the stack byte
            Debug.Assert( JsrInfo == null );
            Debug.Assert( ReturnAddrPart == AddressPart.NA );
            LastAssignedCycles = cycles;
        }

        public void NotifyNewJsrInfo( JsrInfo info, AddressPart addressPart, long cycles ) {
            Debug.Assert( info != null );
            Debug.Assert( JsrInfo == null );
            Debug.Assert( addressPart != AddressPart.NA );
            Debug.Assert( addressPart == AddressPart.High ? info.JsrReturnAddrH == this : info.JsrReturnAddrL == this );
            Debug.Assert( cycles == info.CyclesAfterJsr );
            JsrInfo = info;
            ReturnAddrPart = addressPart;
            LastAssignedCycles = cycles;
        }

        public JsrInfo NotifyJsrInfoRetired( long cycles ) {
            Debug.Assert( IsPartOfReturnAddr );
            JsrInfo jsrInfoToRetire = JsrInfo;
            _retiredJsrInfos.Push( jsrInfoToRetire );
            LastRetiredCycles = cycles;
            ClearJsrPartInfo();
            TraceLine( "retired", StackPtr.ToHex(), _retiredJsrInfos.Count );
            return jsrInfoToRetire;
        }
    }


    class StackWrapper : RobotronObject {

        Cpu _cpu;
        Memory _memory;
        StackByte[] _stackBytes = new StackByte[0x100];
        private int StackPtr { get { return _cpu.RS; } }
        private StackByte CurrentStackByte { get { return _stackBytes[StackPtr]; } }

        Stack<JsrInfo> _jsrInfoStack = new Stack<JsrInfo>();
        private int TopStackPtrH { get { return _jsrInfoStack.Peek().StackPtrH; } }
        private int CallDepth { get { return _jsrInfoStack.Count();  } }

        public StackWrapper( MachineOperator mo ) {
            _cpu = mo.Machine.Cpu;

            _cpu.OnJSR += cpu_OnJSR;
            _cpu.OnRTS += cpu_OnRTS;
            _cpu.OnPH += cpu_OnPH;
            _cpu.OnPL += cpu_OnPL;
            _cpu.OnTXS += cpu_OnTXS;

            _memory = mo.Machine.Memory;
            for (int stackPtr = 0xff; stackPtr >= 0; stackPtr--) {
                _stackBytes[stackPtr] = new StackByte( _memory, stackPtr );
            }
        }


        public void cpu_OnJSR( Cpu cpu ) {
            Debug.Assert( cpu.OpCode == 0x20 ); // JSR

            // 6502 JSR semantics
            StackByte jsrReturnAddrH = _stackBytes[StackPtr + 2];
            StackByte jsrReturnAddrL = _stackBytes[StackPtr + 1];

            JsrInfo info = new JsrInfo {
                JsrOpcodeAddr = cpu.OpcodeRPC,
                JsrTargetAddr = cpu.RPC,   
                StackPtrAfterJsr = StackPtr,
                CyclesAfterJsr = cpu.Cycles,
                JsrReturnAddrH = jsrReturnAddrH,
                JsrReturnAddrL = jsrReturnAddrL,
            };

            // check integrity of JsrInfo (ReturnAddrOnStack is calculated property)
            Debug.Assert( (jsrReturnAddrL.Value | jsrReturnAddrH.Value << 8) == info.ReturnAddrOnStack );

            _jsrInfoStack.Push( info );

            jsrReturnAddrH.NotifyNewJsrInfo( info, AddressPart.High, cpu.Cycles );
            jsrReturnAddrL.NotifyNewJsrInfo( info, AddressPart.Low, cpu.Cycles );

            TraceLine( "JSR", info.JsrOpcodeAddr.ToHex() );
            Trace.Indent();
        }


        private void PopJsrInfo( Action<JsrInfo> action ) {
            JsrInfo info = _jsrInfoStack.Pop();
            if (info.Retired) {
                JsrInfo retiredInfoL = info.JsrReturnAddrL._retiredJsrInfos.Pop();
                JsrInfo retiredInfoH = info.JsrReturnAddrH._retiredJsrInfos.Pop();
                Debug.Assert( retiredInfoL == retiredInfoH && retiredInfoL == info );
            } else {
                info.JsrReturnAddrH.ClearJsrPartInfo();
                info.JsrReturnAddrL.ClearJsrPartInfo();
            }
            action?.Invoke( info );
        }

        public void cpu_OnRTS( Cpu cpu) {
            Debug.Assert( cpu.OpCode == 0x60 ); // RTS
            // RTS has already been executed, so we might as well unindent here

            Trace.Unindent();

            // RTS adds 1 to RPC, so return address needs to be one byte less than target RPC
            // this how RTS is defined, so we can safely assert (6502 semantics, not StackWrapper semantics)
            StackByte highRtsPart = _stackBytes[StackPtr];
            StackByte lowRtsPart = _stackBytes[StackPtr-1];
            Debug.Assert( lowRtsPart.Value + (highRtsPart.Value << 8) + 1 == cpu.RPC );

            if (StackPtr == TopStackPtrH) {

                // StackPtr is at the level where the matching JSR happened
                PopJsrInfo( info => {
                    TraceLine( $"<- RTS /{CallDepth} {cpu.RPC.ToHex()}" + (info.Retired ? $" (retired {info.JsrOpcodeAddr.ToHex()})" : "" ) );
                } );

            } else {
                Debug.Assert( false, "UNTESTED" );
                if (StackPtr < TopStackPtrH) {
                    // probably a RTS jump table
                    // nothing to do for us here
                    // we could probably assert that StackPtr is 2 below exectedStackPtr, but maybe caller wants to pass sth on the stack?
                } else {
                    // probably an "exception", i.e. returning not to the caller but to the caller's caller
                    Debug.Assert( StackPtr > TopStackPtrH );

                    while (_jsrInfoStack.Count > 0 && StackPtr > TopStackPtrH) {
                        PopJsrInfo( info => {
                            TraceLine( $"<- ignored RTS /{CallDepth} {cpu.RPC.ToHex()}" + (info.Retired ? $" (retired {info.JsrOpcodeAddr.ToHex()})" : "") );
                        } );
                    }
                }
            }
        }

        public void cpu_OnPH( Cpu cpu) {
            TraceLine( "PH!!" );
            _stackBytes[StackPtr + 1].SignalPH( cpu.Cycles );
        }

        public void cpu_OnPL( Cpu cpu ) {
            TraceLine( "PL!!" );
            if (CurrentStackByte.IsPartOfReturnAddr) { 
                JsrInfo info = CurrentStackByte.JsrInfo;
                TraceLine( $"PL, retire{info.JsrOpcodeAddr.ToHex()}, {StackPtr.ToHex()}" );
                info.JsrReturnAddrL.NotifyJsrInfoRetired( cpu.Cycles );
                info.JsrReturnAddrH.NotifyJsrInfoRetired( cpu.Cycles );
                info.CyclesAtRetire = cpu.Cycles;
                info.Retired = true;
            } else {
                // ignore PL from stack which doesn't affect any return address on the stack
            }
        }

        public void cpu_OnTXS( Cpu cpu ) {
            Debug.Assert( false, "UNHANDLED TXS" );
        }
    }


    class StackTracker : RobotronObject {

        Cpu _cpu;
        Memory _memory;
        StackWrapper _stackBytes;

        private int ReadByteFromStack( int stackPtr ) {
            return _memory.ReadDebug( 0x100 + stackPtr );
        }

        public StackTracker( MachineOperator mo ) {
            _cpu = mo.Machine.Cpu;
            _memory = mo.Machine.Memory;
            _stackBytes = new StackWrapper( mo );
        }

        public void DumpStack() {
            for (int ptr = 0x3F; ptr >= 0; ptr-- ) {
                TraceLine( ptr == _cpu.RS ? ">" : " ", ptr.ToHex( true ), _memory.ReadDebug( 0x100 + ptr ).ToHex( true ) );
            }
        }
    }
}
