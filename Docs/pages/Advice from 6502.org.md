[cont](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=75)

[Bid Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67235)

* You've already met with the creative use of the stack: pushing and RTS is often used for a table-driven dispatch.
* sometimes conditional branches can be proved to be always taken, so they become branch-always
* It's unusual to see more than one TXS in a program. I suppose that can work as a setjmp/longjmp, or a cold vs warm restart.
* I think you're right to try to see how zero page is used - you'll find single bytes as values, pairs of bytes as values, and also find pairs of bytes acting as pointers.

[Whartung](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67245)

What are your overall goals from this project? What are you trying to learn, and what are you expecting this to teach you?

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67247)

> Is there value in trying to identify blocks of instructions and grouping them into macros, to speed up the understanding?
I'd suspect not. Good names for routines and for locations will be a big help, and note that you might need to rename them too, as you figure things out. It's also possible that locations will be time-multiplexed so one location serves several temporary purposes.

[Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67249)

From a structural point of view, you may find that classifying subroutines into four classes will aid understanding:

1. Where there is no stack manipulation (PHA/PLA/PHP/PLP/TXS) between entry and RTS. You've already done this, I think. (In 65C02 code, you'd also look for PHX/PHY/PLX/PLY.)
2. Where there are pushes balanced by pops later in the same routine, and no manipulation of the stack beyond the level at entry.
3. Where there are pushes *not* fully balanced by pops before RTS, or return is via an RTI instead of RTS. This is one sign of "clever code" which will need deeper analysis.
4. Where there are pops of the return address *from* the stack. This is normally done to access "inline data" placed immediately after the entry JSR. Expect the address to be transferred to zero-page, incremented during access, and then used in an indirect-JMP for return. You should be able to decipher (or use trace data to observe) where the return actually ends up. The gap between there and the JSR will contain inline data which may be revealing (it may be ASCII text).

[fschuhi](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67255)

* I run the code with an emulator, so I know with certainty where the opcodes and their operands are. I am also able to resolve a lot of cases which are difficult (if not impossible) to infer from the code alone, e.g. detecting RTS jump tables and other stack-based wizardry. Because I know everything about the execution flow it is easy to annotate the assembly listing.
* WFDis uses a "flooding" algorithm to try to detect the instructions to disassemble. This idea can be used to detect relocatable code, or what I called "compact subroutines" in the OP. Those are important building blocks and it's good to pinpoint them as early as possible.
*  I already know the parts of the code which are responsible to throwing the stuff onto the screen, by watching which parts of the code STA to pages $20 and following. I don't know but I would guess that I'll find the LDA to the sprite tables in the vicinity.

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517#p67258)

I think for the most part you'll be able to understand the clever code so long as you can zoom out far enough to see the whole picture of what it's doing. If you do find anything you can't get your head around, I'm sure there are many here who would be more than pleased to have a 6502 puzzle to solve.

[Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67261)

* I would advise looking at a "leaf function" first, perhaps one of the subroutines that does nothing or only simple things with the stack, and try to work out what it does. Especially you want to look at leaf functions that hit frequently at runtime (since you have traces, you can identify those easily). You might not get much of a high-level overview at first, but the gestalt will begin to emerge over time.
* You could also statistically correlate accesses to memory areas by sections of code. Do this at the byte level for zero-page and device addresses, and the page level (high byte of the address) elsewhere, then drill down as required. For zero-page in particular, you might distinguish between addressing modes used for access, as indirect accesses signify use of that location as a pointer, while direct accesses may just be for temporary storage (but also for updating pointers). For example, this should help you identify code and zero-page pointers associated with the screen drawing process.
* Also pay attention to subroutines that call into the ROM. Those routines will be documented in Apple literature and offer more clues as to what is intended by the game's programmer. Modify your tracer to log the parameters passed to (and maybe results returned from) these standard routines, while skipping the actual instructions making them up.

[Whartung](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67264)

* I would focus on the largest, clearest chunks of code as I can to (ideally) eliminate them from the prospective code base of "unknown code". The more you know earlier, the better it will go, and it can very well help in understanding the complicated code.
* One of the hardest, yet in many ways very important, things to suss out is the use of the global variables, since those will likely point to the important internal data structures. From there you can work on the code the manipulates those structures, and then the code above that.
* You can also start at the inputs (I have no idea how Robotron worked on the Apple II), and go from there. What's reading the joysticks? What do they do with the data?

[Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67265)

Self-modifying code might seek to increase speed by replacing the operand bytes of instructions to gain the flexibility of Indirect addressing modes without the performance penalty normally associated with them. Detect this by watching for writes to addresses that have previously been executed.

[White Flame](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67320)

Discovering code vs data is actually quite a small part of the work, though it's nice when it's automatic. Figuring out why a piece of code/data is in there and what it's doing is the real reverse engineering.

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67343)

* an operand byte might be best viewed as an expression, which you'll only be able to conjure up as you get to appreciate the code. It's not too unusual for an index not to be zero-based - if the valid values for an index are 10-25 then the index might well be used to point a little below the data in question.
* Being very clear about byte values and their interpretation either as signed or unsigned numbers, or as an enumerated type, or a character, or other things, could be an important watershed.
* Likewise, the idioms for performing arithmetic or comparisons on two-byte or multi-byte values, the idioms for using the carry bit as a boolean variable or as an accessory in multi-byte shifts, are important to understand. They are not exactly macros, but they are idioms larger than single instructions.

[sark02](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67385)

* his "object oriented" style is a pretty natural way of writing games with many different "actors" that have their own lifespan, behavior, and graphics/animation.
* Start with a two-pass disassembly that creates labels for all the trivial branch/jump destinations. This identified the 'direct-call' subroutines (called via JSR) and the intrafunction logic (control flow / loops).
* Make a list of all the JSR destinations. This is the "known function list".
* For each RTS instruction that isn't followed by a known function or an intrafunction label, take the address of the next byte and look through the binary for (LO-BYTE, HI-BYTE) references to that address. This becomes the "possible function list". If there a multiple bytes between the RTS and the next known-function, search for those too. The locations of the (LO, HI) references are "possible function pointers". Keep those.
* For each "possible function", disassemble it and see if it looks like garbage or an actual function. If you know 6502 then it's pretty easy to tell the difference.
* With the known-function-list you can create a call-graph. There will likely be many call graphs - they won't all neatly form one big tree. The call-graph lets to see structure. There will be many shared nodes on the graph. These help identify utility functions.
* Using a graphical utility, locate the sprite patterns for the program.
* Find all the sprite data and record the start address of each pattern.
*  Find all the draw and erase functions. Defender did not use a double-buffered screen, rather it would erase an object from its old position just before drawing it at its new one.
* Reference to the draw/erase functions should be in your (LO, HI) function pointer lists, so with that you should be able to find the sprite descriptors (data structures that describe a sprite, what it looks like, how wide and high it is, and where its draw/erase functions are).
* Find the object lists. Objects in Defender come in different sizes and are allocated and free using utlity functions. Want a new alien? Call the allocate function for a "type 1" object, and then fill in its fields. The object comes to life on the next iteration of the main loop.
* Find the hardware manipulations. These are reads/writes to hardware registers, which you find out by studying the Apple II reference manuals. Every time there's a register read, understand what that does. Every time there's a write, know what it does. It is changing a color register? Is it starting a timer? Is it clearing an interrupt? Is the read getting a joystick value? A key value? Find all these and try to understand their enclosing function.
* The hardest thing with reverse-engineering is figuring out intent. Not _what_ something does, mechanically, but _why_. Why is the code comparing this to that? What's the significance of the literal value #$CE in this CMP? With an emulator you can change these values and see if you observe a difference. That's playing on hard mode, for sure... but you can do it.

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=15#p67386)

The use of two tables for the high and low bytes of pointers (or other values) so the same index can be used for both bytes - that's a fairly common idiom, and not an obvious one.

[sark02](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67392)

If anyone is interested in Williams Robotron and its object management, a chap called Scott Tunstall has done a very detailed disassembly of the code. Find it via Sean Riddle's (very interesting) website: https://seanriddle.com/robomame.asm

[Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67396)

* [Combination from Hackers](https://www.youtube.com/watch?v=2_7N8NsU4jQ)
* multiplication $4c4f

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67398)

*  a tracing disassembler can only reach code which is executed, so we become interested in code coverage.
* (takeaway from static vs execution tracing disassembler: start w/ static, set up guards for code and data in the second which generate hints for first)

[fschuhi](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67405)

* [discussion of Leventhal](http://forum.6502.org/viewtopic.php?f=2&t=5415&p=65393&hilit=multiplication#p65389)
* [faster lysator.se](https://www.lysator.liu.se/~nisse/misc/6502-mul.html)

> Yes, that's a nicer looking algorithm. It saves a branch and increment by sucking the overflow carry bit back into the accumulator as soon as it's produced, which in turn is made possible by processing everything LSB first instead of MSB first. But it's still fundamentally performing an add of one operand for each set bit in the other operand, so is recognisable as a multiply on the same basis.

[Big Ed](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67406)

> I haven't started w/ a repository of 6502 idioms and algorithms yet, maybe it's time to contemplate that.

I can imagine that could be a very useful resource for future adventurers.

[sark02](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67423)

* [Atari-Version](https://github.com/OpenSourcedGames/Atari-7800/tree/master/ROBOTRON)
* I didn't find the multiply subroutine that Chromatix analyzed, so it was likely an independent implementation. Still, it's an excellent, documented, reference for a real 6502 implementation of the game.

[White Flame](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67511)

* [WFDis video](https://vimeo.com/321905818), password: wfdis
* prepending labels w/ S and L (why not J?)
* break apart (w/ empty lines) chunks of code which looks&feels cohesive
* stack is usually not used extensively in 6502
* nest/indent loops
![image](https://user-images.githubusercontent.com/47814647/86475680-6bf78c80-bd45-11ea-8269-85692f1f3a4b.png)
* develop sense of where I am in the document
* in a runtime capture, the disassembling may not go through all paths
* (very fast insert/delete lines)
* (free positioning of cursor in .dd)

[GARTHWILSON](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=30#p67533)

* ["6502 STACKS: More than you thought"](http://wilsonminesco.com/stacks/index.html)

[White Flame](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=45#p67551)

* When it comes to either pre-run snapshots (static analysis) or post-run snapshots (emulation), it's important to understand there is a flow of behavior beyond just the byte dump you happen to be seeing at one time. There might have been intermediate states in the memory footprint before/after, and that requires knowing what the code is actually doing, and why. Just looking at 1 state of memory might not reveal everything.
* Old code written way back in the 1000s was often on platforms with only uppercase available, or only uppercase by default, so there was little choice, and it created an ad-hoc standard. For most actual modern-written code bases, I believe most of them use lowercase. However, when posting code snippets and stating things inline in text (like here talking about LDA label,Y), it visually helps to distinguish the code from normal labels & prose by using uppercase, as ye olde code did. Automated output sometimes keeps uppercase to distinguish it from human-written code.
* In order to get any level of this type of work done, you need to be able to just look at a few instructions at a time to see what they do, independent of the code that surrounds it. Each piece performs some deterministic mechanical step, and doesn't necessarily require the full structure to understand. The small basic blocks that I split up in the video are only like 2-4 instructions long, and are pretty representative of what you need to determine the lowest granularity of documentable functionality. At that point, you should start looking at those small blocks as whole units that interact with each other, instead of always at the instruction level.
* I so far find structural analysis to be a bit of a red herring with 8-bit code. There is no ABI or anything that code needs to follow, except maybe calls to ROM routines. The control flow especially in games is convoluted for speed, not clarity, and most code takes shortcuts to make it easier to write as well. Since there are so few registers, lots of transient state is passed around in memory, reusing memory locations for multiple purposes at multiple times. So it doesn't make a lot of sense to me to try to map all of this hand-wrangled bit banging into some clean single model of execution. But that also depends on what you mean by "structural analysis".

I don't believe that the code/data separation is a significant portion of the work. Having static tracing or emulation traces really assists in those steps, though not without their faults (both can miss code areas, for instance), but it's relatively easy to deduce which portions of the data are code:
* "Holes" of uncalled data surrounded by large code areas are often also code.
* A9 is "LDA #xx" which very commonly starts code paths.
* In my video example where one of the pointers went to an area with something like "00 00 10 20 30 ff ff ff" I assumed that it was not code, because it appears more structured like bitwise data.

What I find the most useful by far is giving names to things, especially variables and subroutines. Even when they're just guesstimates, once you name something and look at its various uses you can piece together a picture of what it's for, in a somewhat bottom-up fashion, but you need to focus on things that will reveal the most. There's a few good starting points to look at that can anchor some of this understanding:
* Accesses to well-known I/O addresses (keyboard/joystick inputs, video registers)
* Accesses to screen memory
* Functions that are called from many places (usually indicates main loop or small utility functions)
* Writes to known system or software vectors (which will generally point to code)
* Calls into ROM
* Initialization code can reveal the overall memory layout

These can help to name some of the primitives that the program is constructed from, which can start to make the overall structure more visible/readable.

[GARTHWILSON)[http://forum.6502.org/viewtopic.php?f=3&t=5517&start=45#p67552)

In prose, the lines on the page exist because a book is more manageable than a mile-long ribbon with a lump here and there for pictures. In programming however, the separation into lines becomes very significant for visual factoring, and having ascenders and descenders (as lower-case does) blurs those divisions. Similarly, numerals 0-9 are always "capitals." Do not mix lower-case a-f into them in hEx nUmBErS! Write for example $3EA9, not $3ea9. Here on the forum where the non-code sections are in proportional spacing, when someone writes for example 3fff, in whatever font is used here, it initially looks like 3111 to me because the f's are so narrow. (Actually now in the preview, they're showing up even narrower than 1's, which is backwards.) It's no harder to type capitals with the caps lock on. (I do take it off for comments.) If you feel like the computer is yelling at you, then turn the font size down. Easy enough. People who look through my code have said they like my style.

[BigEd](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=45#p67598)

(BTW I think perhaps the 'basic block' might be found in any code, which is to say straight-line sections in between entry points, branches, and returns. Backward branches are always good to see because they are often loops, and studying the setup and loop body can be quite illuminating.)

[BigEd](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=45#p67628)

* Might be worth pointing out that skilled 6502 programmers will often be able to make an always-branch by using higher-order understanding of the preceding code. For example, knowing that something is never zero, or never negative, or that carry will always (or will never) be set by some preceding operation.
* It's probably clear to you by now, but one aspect of the 6502 flags is that they are not updated by all instructions. Therefore, a branch being taken or not taken can be a consequence of something which happened several instructions earlier, possibly prior to a branch or even a call. So, there are four bits of state, in effect, which kind of act like short-lived variables. The Z flag is relatively often affected, the V flag relatively rarely. When the flag is affected prior to an RTS and then affects control flow in the parent routine, it's being used as a return code - but that's just one example. If you ever see PHP and PLP then of course that makes the flag values persist for much longer - perhaps around a complex section of code, or even around some subroutine calls.

[BigEd](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=60#p67673)

It might be interesting to note that the usual unsophisticated approach is to run the disassembler over everything, and then to examine the failures, which might be code blocks or misaligned disassembly, and only eventually to distinguish any code which might be unreachable. (I would think unreachable code would be rather unlikely, and data which successfully disassembles also unlikely. But both could happen, especially on a fine-grained view.)

[Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=60#p67826)

Now might be a good time to mention another idiom, not restricted to the 6502: a subroutine may be entered using JMP instead of using JSR immediately followed by RTS. This is known as a tail-call optimisation. On the 6502 it saves 1 byte and 6 cycles.

[GARTHWILSON](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=60#p67828)

actually 9 cycles, since JMP is 3 cycles shorter than JSR (3 versus 6), and the saved RTS is another 6.

[BigEd](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=60#p67837)

* a routine can fall through into the routine that it would have tail-called, if it is positioned right afterwards. Just the same, but without the JMP.
* a routine which needs to be run twice, such as a nibble-processing routine, can be called immediately before falling through:
* and even again for something to be done four times (and I do believe I've seen this done, perhaps to deal with 4 bytes of a 32-bit value)

[cjs](http://forum.6502.org/viewtopic.php?f=3&t=5517&start=90#p71028)

That increment of the high byte is vital, and nothing to do with the length of the stash. If the stash crosses a page boundry, even if it's only two bytes long, the low byte will wrap around to 0 and, if the high byte is not incremented when that happens, you'll end up reading from an address 256 bytes less than the one you should be reading from. (And what you see above is of course the common idiom for 16-bit increments.)
