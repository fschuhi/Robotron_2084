using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Text;

namespace Robotron {

    class StackTracker : RobotronObject {

        Workbench _workbench;
        Cpu _cpu;
        Memory _memory;
        StackWrapper _stackWrapper;
        List<JsrInfo> _jsrInfoList = new List<JsrInfo>();

        public StackTracker( Workbench workbench ) {
            _workbench = workbench;
            MachineOperator mo = workbench._mo;
            _cpu = mo.Machine.Cpu;
            _memory = mo.Machine.Memory;
            _stackWrapper = new StackWrapper( mo );
        }

        public void StartTracking() {
            _stackWrapper.OnJSR += wrapper_OnJsr;
            _stackWrapper.OnRTS += wrapper_OnRts;
            _stackWrapper.OnPH += wrapper_OnPH;
            _stackWrapper.OnPL += wrapper_OnPL;
            _stackWrapper.OnTXS += wrapper_OnTXS;
            _stackWrapper.StartWrapping();
        }

        public void StopTracking() {
            _stackWrapper.StopWrapping();
            _stackWrapper.OnJSR -= wrapper_OnJsr;
            _stackWrapper.OnRTS -= wrapper_OnRts;
            _stackWrapper.OnPH -= wrapper_OnPH;
            _stackWrapper.OnPL -= wrapper_OnPL;
            _stackWrapper.OnTXS -= wrapper_OnTXS;
        }

        public void wrapper_OnJsr( JsrInfo info ) { _jsrInfoList.Add( info ); }
        public void wrapper_OnRts( JsrInfo info ) { return; }
        public void wrapper_OnPH( JsrInfo info ) { return; }
        public void wrapper_OnPL( JsrInfo info ) { return; }
        public void wrapper_OnTXS( JsrInfo info ) { return; }


        public void DumpStack() {
            StringBuilder sb = new StringBuilder();
            for (int ptr1 = 0; ptr1 < 0x40; ptr1 += 0x10 ) {
                if (ptr1 > 0) sb.Append( "\n" );
                for (int ptr2 = 0; ptr2 < 0x10; ptr2++ ) {
                    int ptr = ptr1 + ptr2;
                    bool isStackPtr = ptr == _cpu.RS;
                    sb.Append( ptr2 == 8 ? " " : "" );
                    sb.Append( isStackPtr ? ">" : " " );
                    sb.Append( _memory.ReadDebug( 0x100 + ptr ).To8BitHex() );
                    sb.Append( isStackPtr ? "<" : " " );
                }
            }
            TraceLine( sb.ToString() );
        }

        public void DumpJsrInfoList() {
            // see log.log
            StringBuilder sb = new StringBuilder();
            foreach ( JsrInfo info in _jsrInfoList ) {

                sb.Append( info.JsrOpcodeAddr.ToHex() + ": " );

                string indent = new String( ' ', info.CallDepthAtJsr * 4 );
                string JsrTargetAddr = _workbench.AsmService.SafeGetLabel( info.JsrTargetAddr );
                string ReturnAddr = _workbench.AsmService.SafeGetLabel( info.ReturnAddr );
                string RtsOpcodeAddr = info.RtsOpcodeAddr.ToHex();

                sb.Append( indent );
                sb.Append( JsrTargetAddr );
                sb.Append( " .. " + RtsOpcodeAddr );
                if (info.Retired) sb.Append( $" ( -> {ReturnAddr})" );
                sb.Append( "\n" );
            }
            TraceLine( sb.ToString() );
        }

    }
}
