using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
    class StackTracker {



    }
}
