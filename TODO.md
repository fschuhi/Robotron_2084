see also [README](README.md)

## Workbench continuous refactoring

* workbench should do command line argument parsing
* workbench should deal with ConsoleTraceListener stuff, take it out of the Program.cs
* can we have different logfiles for Trace? (switch in breakpoint handlers)
* think about _operator_OnLoaded() -> mop_OnLoaded()

## L4C00

* rewrite @loop and the @lessThan with macros
	* http://wilsonminesco.com/StructureMacros/STRUCMAC.ASM
* ROL vs ASL
	* find different displays of how ROL and ASL work in books and on the web
	* start with a 6502.md
* test case 
	* use Cpu for the commands and flag management
	* be able to load the bin in a test, then call L4C00 repeatedly with different A, X and tabulate results
	* collect those test cases in RobotronTests
* checks in the test
	* it's not enough to just have entry/exit values, need also intermediate logging / checking
	* we should be able to check for bitflags, too, or at least display them
* determine entry into and exit from a subroutine => StackTracker
	* do not remove current JSR/RTS hooks
	* add state InL4C00, entered on JSR, exited on first RTS after that (which works in this case only, later use StackTracker)
	* change _operator.OnPaused() so that it can fire both unnamed and named breakpoints (which probably will need to have a different class - - derive?)

```
+001e03 4c00: 85 e0        L4C00               sta   __E0
+001e05 4c02: 86 e1                            stx   __E1
+001e07 4c04: a9 00                            lda   #$00
+001e09 4c06: 85 e2                            sta   __E2
+001e0b 4c08: a2 08                            ldx   #$08
+001e0d 4c0a: 06 e0        @loop               asl   __E0
+001e0f 4c0c: 2a                               rol   A
+001e10 4c0d: c5 e1                            cmp   __E1
+001e12 4c0f: 90 02                            bcc   @lessThan
+001e14 4c11: e5 e1                            sbc   __E1
+001e16 4c13: 26 e2        @lessThan           rol   __E2
+001e18 4c15: ca                               dex
+001e19 4c16: d0 f2                            bne   @loop
+001e1b 4c18: aa                               tax
+001e1c 4c19: a5 e2                            lda   __E2
+001e1e 4c1b: 60                               rts


STA $E0		; destroyed
STX $E1     ; immutable
LDA #$00
STA $E2

; #8 is an indicator for bitwise action
; loop endpoint: DEX/INX w/ following BNE
LDX $#08

loop
	; ASL is a "destroying" action on $E0
	ASL $E0

	; because A starts w/ 0, this captures a flag from ASL
	; how many flags can it capture?
	; what happens on different bit patterns in $E0
	ROL A

	; bcc equals "<", so branch over the implicit ">="
	if A >= $E1

		; always check ADC and SBC for C=0 resp. C=1, otherwise weird side effects
		assert C=1
		A -= $E1

		; assumption: SBC with result >= 0 => C=0
		; is this equivalent to: SBC with result != 0 => C=0  ?
		; (I think this assumption doesn't hold, because what would for the following ROL do? would just return )
		assert C=0
	endif

	assert C=0
	ROL $E2

until --X = 0

; IMPORTANT: we return not only A but also X!
TAX
LDA $E2
```

## StackTracker

* can be used to switch off tracing for (compact only?) subroutines
* determine entry into and exit from a subroutine
* hook into OnJSR, OnRTS
* add OnTXS and pull off return addresses until we get to the new stack pointer

## breakpoints

* show cycle count for log line
* concept of "guard": break and unpause
* switch trace on/off on breakpoints
* break on # of cycles, "stopwatch" (e.g. reset to stop at offset)
* single-stepping

## watches

* switch watch on/off on breakpoints, guards 

## asm management

* cont w/ AsmReader
* crossreferenceing, called by
* revisit idea w/ tiles, stretches, compactness
* which parts are traversed by which other parts? cohesiveness

## misc

* understand assembler in MemoryDebug
* fake result from random number generator ($4C36)
* grid view for selected memory locations
* ListBox w/ code
* multiples code ListBoxes which spring into action on PC in certain range
* constrain code ListBox for PC range
* sync w/ ListBox on breakpoint / single-stepping
* savepoints
