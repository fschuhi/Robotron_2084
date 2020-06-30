#!/usr/bin/env python

import sys

from util import *

INSTRUCTION = 1
OPERAND     = 2
LABEL       = 3
BYTE        = 4
DATA        = 5
BASE        = 6
DEFINE      = 7
RESOLVE     = 8
WORD        = 9


def ParseHex(hexstr):
    h = hexstr.strip()
    if h.startswith('$'):
        hint = int(h[1:],16)
    elif h.startswith('#$'):
        hint = int(h[2:],16)
    elif h.startswith('#"'):
        hint = ord(h[2])
    elif h.startswith('"'):
        # 29.03.19
        hint = ord(h[1])
    else:
        # 29.03.19
        # hint = int(h)
        hint = int(h,16)
    return hint

def Is2ByteBranch(op):
    return op in ["BCC","BCS","BEQ","BMI","BNE","BPL","BVC","BVS","BRA"]

def Is3ByteBranch(op):
    return op in ["JMP","JMP","JMP","JSR","BBR0","BBR1","BBR2","BBR3","BBR4","BBR5","BBR6","BBR7","BBS0","BBS1","BBS2","BBS3","BBS4","BBS5","BBS6","BBS7"]


class Assembler:
    def __init__(self):
        self.instinfo = {}
        self.instructions = set()
        self.load_ops()
        self.labels = None

    def load_ops(self):
        ops = [
            (0x69,'ADC','IMM',2,2),
            (0x65,'ADC','ZP',2,3),
            (0x75,'ADC','ZPX',2,4),
            (0x6d,'ADC','ABS',3,4),
            (0x7d,'ADC','ABSX',3,4),
            (0x79,'ADC','ABSY',3,4),
            (0x61,'ADC','INDX',2,6),
            (0x71,'ADC','INDY',2,5),

            (0x29,'AND','IMM',2,2),
            (0x25,'AND','ZP',2,3),
            (0x35,'AND','ZPX',2,4),
            (0x2d,'AND','ABS',3,4),
            (0x3d,'AND','ABSX',3,4),
            (0x39,'AND','ABSY',3,4),
            (0x21,'AND','INDX',2,6),
            (0x31,'AND','INDY',2,5),

            (0x0a,'ASL','ACC',1,2),
            (0x06,'ASL','ZP',2,5),
            (0x16,'ASL','ZPX',2,6),
            (0x0e,'ASL','ABS',3,6),
            (0x1e,'ASL','ABSX',3,7),

            (0x90,'BCC','REL',2,2/3),
            (0xB0,'BCS','REL',2,2/3),
            (0xF0,'BEQ','REL',2,2/3),
            (0x30,'BMI','REL',2,2/3),
            (0xD0,'BNE','REL',2,2/3),
            (0x10,'BPL','REL',2,2/3),
            (0x50,'BVC','REL',2,2/3),
            (0x70,'BVS','REL',2,2/3),

            (0x24,'BIT','ZP',2,3),
            (0x2c,'BIT','ABS',3,4),

            (0x00,'BRK','IMP',1,7),
            (0x18,'CLC','IMP',1,2),
            (0xd8,'CLD','IMP',1,2),
            (0x58,'CLI','IMP',1,2),
            (0xb8,'CLV','IMP',1,2),
            (0xea,'NOP','IMP',1,2),
            (0x48,'PHA','IMP',1,3),
            (0x68,'PLA','IMP',1,4),
            (0x08,'PHP','IMP',1,3),
            (0x28,'PLP','IMP',1,4),
            (0x40,'RTI','IMP',1,6),
            (0x60,'RTS','IMP',1,6),
            (0x38,'SEC','IMP',1,2),
            (0xf8,'SED','IMP',1,2),
            (0x78,'SEI','IMP',1,2),
            (0xaa,'TAX','IMP',1,2),
            (0x8a,'TXA','IMP',1,2),
            (0xa8,'TAY','IMP',1,2),
            (0x98,'TYA','IMP',1,2),
            (0xba,'TSX','IMP',1,2),
            (0x9a,'TXS','IMP',1,2),

            (0xc9,'CMP','IMM',2,2),
            (0xc5,'CMP','ZP',2,3),
            (0xd5,'CMP','ZPX',2,4),
            (0xcd,'CMP','ABS',3,4),
            (0xdd,'CMP','ABSX',3,4),
            (0xd9,'CMP','ABSY',3,4),
            (0xc1,'CMP','INDX',2,6),
            (0xd1,'CMP','INDY',2,5),

            (0xe0,'CPX','IMM',2,2),
            (0xe4,'CPX','ZP',2,3),
            (0xec,'CPX','ABS',3,4),

            (0xc0,'CPY','IMM',2,2),
            (0xc4,'CPY','ZP',2,3),
            (0xcc,'CPY','ABS',3,4),

            (0xc6,'DEC','ZP',2,5),
            (0xd6,'DEC','ZPX',2,6),
            (0xce,'DEC','ABS',3,6),
            (0xde,'DEC','ABSX',3,7),

            (0xca,'DEX','IMP',1,2),
            (0x88,'DEY','IMP',1,2),
            (0xe8,'INX','IMP',1,2),
            (0xc8,'INY','IMP',1,2),

            (0x49,'EOR','IMM',2,2),
            (0x45,'EOR','ZP',2,3),
            (0x55,'EOR','ZPX',2,4),
            (0x4d,'EOR','ABS',3,4),
            (0x5d,'EOR','ABSX',3,4),
            (0x59,'EOR','ABSY',3,4),
            (0x41,'EOR','INDX',2,6),
            (0x51,'EOR','INDY',2,5),

            (0xe6,'INC','ZP',2,5),
            (0xf6,'INC','ZPX',2,6),
            (0xee,'INC','ABS',3,6),
            (0xfe,'INC','ABSX',3,7),

            (0x4c,'JMP','ABS',3,3),
            (0x6c,'JMP','IND',3,5),
            (0x20,'JSR','ABS',3,6),

            (0xa9,'LDA','IMM',2,2),
            (0xa5,'LDA','ZP',2,3),
            (0xb5,'LDA','ZPX',2,4),
            (0xad,'LDA','ABS',3,4),
            (0xbd,'LDA','ABSX',3,4),
            (0xb9,'LDA','ABSY',3,4),
            (0xa1,'LDA','INDX',2,6),
            (0xb1,'LDA','INDY',2,5),

            (0xa2,'LDX','IMM',2,2),
            (0xa6,'LDX','ZP',2,3),
            (0xb6,'LDX','ZPY',2,4),
            (0xae,'LDX','ABS',3,4),
            (0xbe,'LDX','ABSY',3,4),

            (0xa0,'LDY','IMM',2,2),
            (0xa4,'LDY','ZP',2,3),
            (0xb4,'LDY','ZPX',2,4),
            (0xac,'LDY','ABS',3,4),
            (0xbc,'LDY','ABSX',3,4),

            (0x4a,'LSR','ACC',1,2),
            (0x46,'LSR','ZP',2,5),
            (0x56,'LSR','ZPX',2,6),
            (0x4e,'LSR','ABS',3,6),
            (0x5e,'LSR','ABSX',3,7),

            (0x09,'ORA','IMM',2,2),
            (0x05,'ORA','ZP',2,3),
            (0x15,'ORA','ZPX',2,4),
            (0x0d,'ORA','ABS',3,4),
            (0x1d,'ORA','ABSX',3,4),
            (0x19,'ORA','ABSY',3,4),
            (0x01,'ORA','INDX',2,6),
            (0x11,'ORA','INDY',2,5),

            (0x2a,'ROL','ACC',1,2),
            (0x26,'ROL','ZP',2,5),
            (0x36,'ROL','ZPX',2,6),
            (0x2e,'ROL','ABS',3,6),
            (0x3e,'ROL','ABSX',3,7),

            (0x6a,'ROR','ACC',1,2),
            (0x66,'ROR','ZP',2,5),
            (0x76,'ROR','ZPX',2,6),
            (0x7e,'ROR','ABS',3,6),
            (0x6e,'ROR','ABSX',3,7),

            (0xe9,'SBC','IMM',2,2),
            (0xe5,'SBC','ZP',2,3),
            (0xf5,'SBC','ZPX',2,4),
            (0xed,'SBC','ABS',3,4),
            (0xfd,'SBC','ABSX',3,4),
            (0xf9,'SBC','ABSY',3,4),
            (0xe1,'SBC','INDX',2,6),
            (0xf1,'SBC','INDY',2,5),

            (0x85,'STA','ZP',2,3),
            (0x95,'STA','ZPX',2,4),
            (0x8d,'STA','ABS',3,4),
            (0x9d,'STA','ABSX',3,5),
            (0x99,'STA','ABSY',3,5),
            (0x81,'STA','INDX',2,6),
            (0x91,'STA','INDY',2,6),

            (0x86,'STX','ZP',2,3),
            (0x96,'STX','ZPY',2,4),
            (0x8e,'STX','ABS',3,4),
            (0x84,'STY','ZP',2,3),
            (0x94,'STY','ZPX',2,4),
            (0x8c,'STY','ABS',3,4),

            # .word will be 2 bytes
            # we need to fake an operation w/ 3 bytes, to resolve the label correctly
            (0x00, '.WORD','ABS',3,0),

        ]

        for (opcode, mnemonic, addressing, bytes, cycles) in ops:
            self.instinfo[opcode] = [mnemonic, addressing, bytes, cycles, 'CZidbVN']
            self.instructions.add(mnemonic)

    def tokenize( self, program_string, verbose=False ):
        """program is a list of the source of a program broken up into
            a list, like will be returned from readlines() of a file

           expects the global "instructions" to be defined as a set of
             keywords recognized as assembler instructions

           instruction .byte handled specially

           Returns a dictionary with the lines tokenized.
        """
        program = program_string.splitlines()
        linenum = 0
        programtokens = []

        while linenum < len(program):
            error = False
            if verbose: print("%d: %s" % (linenum, program[linenum].strip()))
            # strip out comment
            linesrc = program[linenum].strip().split(';')[0].upper()
            if len(linesrc) == 0:
                linenum = linenum + 1
                continue
            line    = linesrc.split()

            if len(line) == 3 and (line[1] == '=' or line[1] == 'EQU'):
                t = [linenum, [(DEFINE, line[0], line[2])]]
                programtokens.append(t)
                if verbose: print(str(t))
                linenum = linenum + 1
                continue

            haveinstruction = False
            linetokens = []

            while len(line) > 0:
                token = line[0]
                if token[0] == '*':
                    #if this is a code base change, process it as one whole chunk
                    # and move to the next line
                    basestr = linesrc.split('=')
                    if len(basestr) != 2:
                        if verbose: print("Unrecognized base define")
                        error = True
                    else:
                        num = basestr[1].strip().split()[0]
                        linetokens.append((BASE, ParseHex(num)))
                    line =[]
                elif token == '.BYTE':
                    # if this is a data definition, process all at once
                    linetokens.append((BYTE, token))
                    dataoffset = linesrc.find(token)+5
                    datastr    = linesrc[dataoffset:].lstrip()
                    if datastr[0] == '"':
                        ds = datastr
                        while ds[-1] != '"':
                            #consume lines until the end quote
                            linenum = linenum + 1
                            ds = ds + program[linenum].rstrip()
                            if verbose: print("%d: (continuing) %s" % (linenum, program[linenum].strip()))
                        stringbytes = []
                        for char in ds:
                            if char != '"':
                                stringbytes.append(ord(char))
                        linetokens.append((DATA, stringbytes))
                        line = []
                    else:
                        datastr = datastr.split(';')[0]
                        datastr = datastr.replace(" ", "")
                        datastr = datastr.replace("\t", "")
                        datastr_elems = datastr.split(',')
                        data = []
                        for d in datastr_elems:
                            data.append(ParseHex(d))
                        linetokens.append((DATA, data))
                        line = []
                elif token in self.instructions:
                    linetokens.append((INSTRUCTION, token))
                    haveinstruction = True
                elif haveinstruction:
                    linetokens.append((OPERAND, token))
                else:
                    if token[-1] == ':':
                        token = token[:-1]
                    linetokens.append((LABEL, token))

                if len(line) > 0:
                    #move to next token
                    line.pop(0)

            if error:
                print("An error occurred on line %d" % (linenum))
                print(linesrc)
                sys.exit(1)

            if linetokens:
                #save the source line number for debugging
                t = [linenum,linetokens]
                if verbose: print(str(t))
                programtokens.append(t)
            linenum = linenum + 1

        if verbose:
            i = 0
            for line in programtokens:
                print("%04d %-80s %s" % (i, line, program[line[0]].strip()))
                i = i + 1
        return programtokens

    def find_info( self, mnemonic, addressmode, operand ):
        """Figure out which opcode to use for this instruction based on
        addressing mode.  The text doesn't definitively determine the addressing
        mode, so use the text along with what is available for that mnemonic to
        decide which mode to pick.
        """
        if operand is None:
            operand = "z"
        for ii in self.instinfo:
            info = self.instinfo[ii]
            am = addressmode
            if info[0] == mnemonic:
                #['LDA', 'INDX', '2', '6', 'cZidbvN']
                if addressmode == "XXX":
                    if len(operand) < 6:
                        am = "ZPX"
                    else:
                        am = "ABSX"
                elif addressmode == "YYY":
                    if len(operand) < 6:
                        am = "ZPY"
                    else:
                        am = "ABSY"
                if am == info[1]:
                    ret = [ii]
                    ret.extend(info)
                    return ret

        #If I'm still here, and searching for ,x ,y modes
        # or an opcode without a operand that could be ACC, try
        # the others
        for ii in self.instinfo:
            info = self.instinfo[ii]
            am = addressmode
            if info[0] == mnemonic:
                #['LDA', 'INDX', '2', '6', 'cZidbvN']
                if addressmode == "XXX":
                    am = "ABSX"
                elif addressmode == "YYY":
                    am = "ABSY"
                elif addressmode == "IMP":
                    am = "ACC"
                if (am == info[1]):
                    ret = [ii]
                    ret.extend(info)
                    return ret
        return None

    def handle_operation( self, s, defines ):
        """
        This is here mostly to handle special cases like using symbols
        with offsets "value+16".
        """
        if s[0] == '#':
            return s

        offset = 0
        suffix = ""
        base   = ""
        us = s

        ussplit = us.split(',')
        if len(ussplit) > 1:
            suffix = ","+ussplit[1]
        base = ussplit[0]

        if s.rfind('+') != -1:
            t = base.split('+')
            offset = int(t[1])
            base = t[0]
        elif s.rfind('-') != -1:
            # FS: was '+'
            t = base.split('-')
            offset = -1*int(t[1])
            base = t[0]

        if base not in defines:
            # FS: return complete
            # return base+suffix
            return s

        else:
            # FS: defines is {str,str}, labels is {str,int}
            define = defines[base]
            if isinstance(define, int):
                # assumption: suffix == ''
                base = define
                return "$%x%s" % (base+offset,suffix)
            else:
                # FS: define might be immediate, i.e. do not do any math here
                # TODO: we might do math here as well
                if define[0] == '#':
                    return define

                base = ParseHex(define)
                return "$%x%s" % (base+offset,suffix)


    def generate_code( self, lexed_program, verbose=False ):
        """Transforms the token list from Tokenize into a list that contains
        the machine code for each line.
        Grammar recognizes the following lines
            LABEL
            BYTE DATA
            LABEL BYTE DATA
            BASE
            INSTRUCTION
            INSTRUCTION OPERAND
            LABEL INSTRUCTION
            LABEL INSTRUCTION OPERAND
        """
        defines = {}
        labels  = {}
        lexidx = 0

        #Pass #1
        #Find labels and defines
        # labels are identifiers on the beginning of lines
        # defines are structures like
        # IOPORT  =  $34
        #  usually these are zero page registers of one byte
        #  sometimes they are absolute code addresses

        for line in lexed_program:
            instr = line[1]
            if instr[0][0] == DEFINE:
                d = line[1][0]
                name = instr[0][1]
                value = instr[0][2]
                defines[name] = value
            if instr[0][0] == LABEL:
                labels[instr[0][1]] = lexidx
            lexidx = lexidx + 1

        ir      = []  #ir is ordered
        pc      = 0
        errors  = {}
        lexedPgmIdx  = 0

    #INSTRUCTION = 1
    #OPERAND     = 2
    #LABEL       = 3
    #BYTE        = 4
    #DATA        = 5
    #BASE        = 6
    #DEFINE      = 7
        #Pass #2
        # generate machine code
        # for each tokenized line
        # recognize the instruction and pick an opcode
        #   use defines{} struture to resolve symbols
        #
        while lexedPgmIdx < len(lexed_program):
            lpline = lexed_program[lexedPgmIdx]
            if verbose: print(str(lpline)+"\n")
            tokens = lpline[1]
            i = 0
            while i < len(tokens):
                token = lpline[1][i]
                if (i+1 == len(tokens)):
                    nexttoken = None
                else:
                    nexttoken = lpline[1][i+1]

                if token[0] == LABEL:
                    # Labels reference forward and backward, so I haven't seen
                    # them all yet.  For now, write down the line number where the label occurs.
                    # Then after all instruction addresses are recorded, I can go back
                    # and give each label an address.
                    labels[token[1]] = len(ir)
                    i = i + 1
                elif token[0] == BYTE:
                    # BYTE is just data to be put into the machine code stream
                    # likely these are referenced by a label
                    if nexttoken == None or nexttoken[0] != DATA:
                        errors[lexedPgmIdx] = str(lpline[0]) + " .byte not followed by data"
                        break
                    pl = (pc, len(ir), DATA, nexttoken[1])
                    ir.append(pl)
                    pc = pc + len(nexttoken[1])
                    i = i + 2
                elif token[0] == DEFINE:
                    #already handled these above
                    i = i + 1
                elif token[0] == BASE:
                    #just reset the PC to whatever the program wants it to be
                    pc = token[1]
                    i = i + 1
                elif token[0] == INSTRUCTION:
                    # this is a line of code
                    if token[1] not in self.instructions:
                        i = i + 1
                        errors[lexedPgmIdx] = str(lpline[0]) + " instruction not recognized"
                        break
                    mnemonic = token[1]
                    addressmode = None
                    if nexttoken != None and nexttoken[0] != OPERAND:
                        #if there are more tokens after INSTRUCTION, my grammar says
                        # it has to be an OPERAND, otherwise error
                        i = i + 1
                        errors[lexedPgmIdx] = str(lpline[0]) + " illegal token following instruction"
                        break
                    #determine addressing mode based on the format of any operand
                    if nexttoken == None:
                        addressmode = "IMP"
                    else:
                        operand = nexttoken[1]

                        # FS: handle_operation() originally only for defines, also for labels (below)
                        operand = self.handle_operation( operand, defines )

                        if operand[0] == '#':
                            addressmode = "IMM"
                        elif operand[0] == '(':
                            # FS:
                            #print("don't know how to handle indirect")
                            #print(str(lexed_program[lexedPgmIdx]))
                            #sys.exit(1)
                            bracket = operand.rfind(")")
                            if bracket == -1:
                                errors[lexedPgmIdx] = str(lpline[0]) + " indirect closing bracket missing"
                                break
                            if operand.endswith(",X)"):
                                addressmode = "INDX"
                                operand = operand[1:bracket-2]
                            elif operand.endswith("),Y"):
                                addressmode = "INDY"
                                operand = operand[1:bracket]
                            elif operand.endswith(")"):
                                addressmode = "IND"
                                operand = operand[1:bracket]
                            else:
                                errors[lexedPgmIdx] = str(lpline[0]) + " invalid indirect"
                                break
                        elif operand.endswith(",X"):
                            addressmode = "XXX"
                        elif operand.endswith(",Y"):
                            addressmode = "YYY"
                        elif Is2ByteBranch(mnemonic):
                            addressmode = "REL"
                        elif Is3ByteBranch(mnemonic):
                            addressmode = "ABS"
                        elif operand in labels:
                            addressmode = "ABS"
                        elif operand.startswith("$"):
                            if len(operand) < 4:
                                addressmode = "ZP"
                            else:
                                addressmode = "ABS"
                        else:
                            # FS:
                            if operand.rfind('+') != -1 or operand.rfind('-') != -1:
                                addressmode = "ABS"
                            else:
                                addressmode = "UNK"
                    # using the mnemonic and address mode, pick a machine code
                    # info = (opcode, mnemonic, addressing, bytes, cycles)
                    info = self.find_info( mnemonic, addressmode, operand )

                    if info == None:
                        errors[lexedPgmIdx] = str(lpline[0]) + " instruction not found for %s address mode %s" % (mnemonic, addressmode)
                        break
                    numbytes = int(info[3])
                    #generate code
                    if numbytes == 1:
                        pl = (pc, len(ir), INSTRUCTION, [info[0]])
                    elif numbytes == 2:
                        num = operand.split(',')[0]
                        if operand[0] == '$' or operand[0] == '#':
                            pl = (pc, len(ir), INSTRUCTION, [info[0], ParseHex(num)])
                        else:
                            #if a label, note it down to resolve later
                            pl = (pc, len(ir), RESOLVE, [info[0], 0], num)
                    elif numbytes == 3:
                        num = operand.split(',')[0]
                        if operand[0] == '$':
                            addr = ParseHex(num)
                            pl = (pc, len(ir), INSTRUCTION, [info[0], addr & 0xff, (addr >> 8)&0xff]) # little endian order
                            # FS
                            if info[0] == 0x00:
                                del pl[3][0]
                        else:
                            #if a label, note it down to resolve later
                            pl = (pc, len(ir), RESOLVE, [info[0], 0, 0], num)

                    ir.append(pl)
                    pc = pc + numbytes
                    i = 100 # done with this line
                else:
                    errors[lexedPgmIdx] = str(lpline[0]) + " unhandled token %s" % (str(token))
                    i = i + 1

            if verbose and len(ir) > 0:
                print(str(ir[-1]))
            if len(errors) != 0:
                print("exiting due to error")
                print(str(errors))
                print(str(lexed_program[lexedPgmIdx]))
                sys.exit(1)
            lexedPgmIdx = lexedPgmIdx + 1

        if verbose:  #debugging info
            i = 0
            for line in ir:
                print("%04d %s" % (i, line))
                i = i + 1

        # Transform (Pass #3) to resolve labels
        # Now that we have the PC for every instruction, the labels
        #  can be resolved.
        # I have the line number for each lable, loop through the
        # labels, get the line number of the label and update the value to
        # the PC of that line.
        for name in labels:
            irline       = labels[name]
            irlinepc     = ir[irline][0]
            labels[name] = irlinepc

        self.labels = labels

        # Pass #4
        # use the resolved labels to fix all the branches to labels
        self.resolve_branches( {"ir" : ir, "labels" : labels} )

        return ir

    def resolve_branches( self, ir ):
        #each line is
        # PC, irLineNumber, [RESOLVE,INSTRUCTION], instruction bytes, optional Target Label
        for line in ir["ir"]:
            if line[2] == RESOLVE:
                if len(line[3]) == 2:
                    #all 2-bytes are relative branches
                    target = ir["labels"][line[4]]
                    mypc   = line[0]
                    # TODO: check -2 adjustment in Assembler.resolve_branches()
                    # 05.03.19 added -2
                    offset = target-mypc - 2
                    # print(hexaddr(target), hexaddr(mypc), offset)
                    line[3][1] = offset & 0xff
                else:
                    #all 3 bytes are absolute jumps (FS: no)
                    # FS: we might resolve "BEFORE+2" style operands
                    if line[4].rfind('+') != -1 or line[4].rfind('-') != -1:
                        handled = self.handle_operation(line[4], self.labels)
                        targetpc = int(handled[1:],16)
                    else:
                        targetpc = ir["labels"][line[4]]
                    line[3][1] = targetpc & 0xff
                    line[3][2] = (targetpc >> 8) & 0xff
                    if line[3][0] == 0x00:
                        # ((VHQSELL)) from here on line[0] will be incorrect
                        del line[3][0]

    @staticmethod
    def to_byte_array( code ):
        pc = code[0][0]
        byte_array = []
        for line in code:
            # FS: ignore PC because it might be wrong, see ((VHQSELL))
            #while pc < line[0]:
            #    byte_array.append(0)
            #    pc += 1
            for by in line[3]:
                byte_array.append(by)
                pc += 1
        return byte_array

    @staticmethod
    def byte_array_to_text(byte_array):
        text = ""
        for index, b in enumerate(byte_array):
            text += hexbyte(b)
            text += '\n' if (index+1) % 16 == 0 else ' '
        return text.strip()

    def dump_byte_array(self, byte_array):
        print(self.byte_array_to_text(byte_array))

