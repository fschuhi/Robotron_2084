using Jellyfish.Library;
using Jellyfish.Virtu;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;

namespace Robotron {

    class StackNode {

    }

    class StackTracker : RobotronObject {

        Workbench _workbench;
        Cpu _cpu;
        Memory _memory;
        StackWrapper _stackWrapper;

        public StackTracker( Workbench workbench ) {
            _workbench = workbench;
            MachineOperator mo = workbench._mo;
            _cpu = mo.Machine.Cpu;
            _memory = mo.Machine.Memory;
            _stackWrapper = new StackWrapper( mo );
            _stackWrapper.OnJSR += wrapper_OnJsr;
            _stackWrapper.OnRTS += wrapper_OnRts;
            _stackWrapper.OnPH += wrapper_OnPH;
            _stackWrapper.OnPL += wrapper_OnPL;
        }

        public void wrapper_OnJsr( JsrInfo info ) {
            TraceLine( "JSR", info.JsrOpcodeAddr.ToHex() );
            // 0x20 address - JsrOpcodeAddr
            // wir wollen auch target info sehen
            // beides als labels

            Trace.Indent();
        }

        public void wrapper_OnRts( JsrInfo info ) {
            // RTS has already been executed, so we might as well unindent here
            Trace.Unindent();

            int CallDepth = _stackWrapper.CallDepth;
            string returnAddr = (_cpu.RPC - 3).ToHex();
            string JsrOpcodeAddr = info.JsrOpcodeAddr.ToHex();
            if (info.Retired) {
                TraceLine( $"<- {(info.Ignored ? "ignored " : "")} RTS /{CallDepth}, {returnAddr} (retired {JsrOpcodeAddr})" );

            } else {
                TraceLine( $"<- {(info.Ignored ? "ignored " : "")} RTS /{CallDepth}, {JsrOpcodeAddr}" );
            }
        }

        public void wrapper_OnPH( JsrInfo info ) {
            TraceLine( "PH!!" );
        }

        public void wrapper_OnPL( JsrInfo info ) {
            TraceLine( "PL!!" );
        }

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

        public void DumpInfoList() {
            // see log.log
            StringBuilder sb = new StringBuilder();
            foreach ( JsrInfo info in _stackWrapper.JsrInfoList ) {

                sb.Append( info.JsrOpcodeAddr.ToHex() + ": " );

                string indent = new String( ' ', info.CallDepthAtJsr * 4 );
                string JsrTargetAddr = _workbench.SafeGetLabel( info.JsrTargetAddr );
                string ReturnAddr = _workbench.SafeGetLabel( info.ReturnAddr );
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
