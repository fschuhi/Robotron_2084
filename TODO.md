see also [README](README.md)

https://github.com/Dwedit/DW1NsfInjector/blob/master/Assembler.cs
https://github.com/informedcitizenry/6502.Net

https://github.com/jacobslusser/ScintillaNET
https://github.com/robinrodricks/ScintillaNET.Demo

## Workbench continuous refactoring

* Program.cs -> workbench
	* nicht add/remove tracer wenn -silent command line switch
* move logging to out.log to standalone class RLog

## asm source

* Leventhal subroutine documentation: description, input + output parameters, registeres and memory locations used, sample case
* types of subroutines => find relocateable, closed, compact, shallow
	* deep / shallow (has JSR / no JSR)
	* relocateable (must be shallow) vs fixed
	* compact
	* for compact: narrow / wide
		* narrow: just 1 JSR entry point, no JMP entry points
		* wide: multiple JSR and/or JMP entry points
	* reentrant (irrelevant)
	* tail-sometimes, tail-always
	* types of parameter passing
		* stash
		* stack
		* registers
		* zp
	* "environment"
		* parameters zählen nicht zum environment
		* load/save to memory
	* types of memory usage
		* read-clean, write-clean (possibly distinguish into -zp, -nonzp)
		* read-dirty, write-diry
	* types of depth
		* always at certain level
		* always called from certain ancestor(s) - - nur dynamisch
* types of calls
	* Monitor,  Applesoft
	* JSR to compact
	* JSR/JMP to JSR/JMP (4 combos)
	* JMP to tail
* collect addresses
	* non-zeropage
		* absolute operand only - - **wie nenne ich das?**
		* indexed operand (eigentlich egal ob X oder Y, oder?)  - - **wie nenne ich das?**
		* in code
			* stash
			* self-modifying code
		* monitor (z.B. KEYIN)
	* zeropage
		* pre-indexed indirect: ($zp,X)
		* post-indexed indirect: ($zp), Y
		* interesting
			* es sollte eigentlich kein mixed usage pre/post geben
			* static kann man nicht sagen, ob $zp / $zp+1 auch keine addr hat, dynamisch: vermutlich temporär
* memory map
	* code
	* stashes
	* 

## potential refactoring targets

* make MachineOperator independent from WPF, which means possibly making it independent from Virtu itself
* rewrite @loop and the @lessThan with macros
	* http://wilsonminesco.com/StructureMacros/STRUCMAC.ASM

## StackTracker

* design objects
	* stack memory bytes
	* stack entry w/ varying length
* can be used to switch off tracing for (compact only?) subroutines
* determine entry into and exit from a subroutine
* hook into OnJSR, OnRTS
* hook into PLx, PHx
* add OnTXS and pull off return addresses until we get to the new stack pointer
* indent / unindent should also work w/ stack level

## L4C00

* test case 
	* use Cpu for the commands and flag management
	* collect those test cases in RobotronTests
* checks in the test
	* it's not enough to just have entry/exit values, need also intermediate logging / checking
	* we should be able to check for bitflags, too, or at least display them
* ROL vs ASL
	* start with a 6502.md
* determine entry into and exit from a subroutine => StackTracker
	* do not remove current JSR/RTS hooks
	* add state InL4C00, entered on JSR, exited on first RTS after that (which works in this case only, later use StackTracker)
	* change _operator.OnPaused() so that it can fire both unnamed and named breakpoints (which probably will need to have a different class - - derive?)


## breakpoints

* show cycle count for log line (at the end?)
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
* Serilog
	* https://serilog.net/
	* https://github.com/serilog/serilog/wiki/Configuration-Basics