# Robotron_2084
The goal of the software in this repo is to reverse engineer Robotron 2084 for the Apple II. 

As of now, everything in this repo is work in progress. The software (emulators and debuggers in Python and C#) is supposed to further my understanding of the Robotron executable. The repo tracks  my progress. It doesn't want to be more than that.

From the first post of a first [development blog on 6502.org](http://forum.6502.org/viewtopic.php?t=5517):
> With the proliferation of really good emulators for the Apple II, I have recently been re-introduced to the games I played decades ago. Then, in school, there were 6502 wizards who not only cracked the copy protection on those games but were actually able to understand and change them. Awesome! Since then it has always bugged me that I shied away from learning 6502 and diving into 8bit game design. I don't know why I have finally decided to try this myself, maybe it was just a critical mass thing. Anyways, here I am, all set.

I'm really a newbie when it comes to 6502 assembler (or any assembler, for that matter). Commenters on 6502.org are very helpful and have given me a lot of [really good advice](pages/advice from 6502.org.md), for which I'm really grateful. 

## Papple2

I did the first run on disassembling Robotron using Python. The Papple2 workbench is derived from [ApplePy](https://github.com/jtauber/applepy), an Apple II emulator in Python, written by James Tauber. The emulator uses Pygame for screen output. You might want to check out [James' intro on YouTube](https://www.youtube.com/watch?v=EhK5JNx0irA).

Using Python as an emulator is of course an odd choice, because (I believe) all emulators in Python, including ApplePy, are slower than the original Apple II. At least in the beginning of the reengineering project that was not a problem at all. Compared to the more complete C# emulator Virtu (see below), ApplePy is very compact, easy to adapt and generally also easy to understand (which was important in the beginning, because I didn't know anything about Python in the beginning.)

I ported ApplePy to Python 3, removed some code (like all the interfacing with the emulator from the outside via sockets) and added a number of features:
* an assembler
* breakpoints, hooks
* execution tracer
* memory inspection tools
* statemachines
* call trees (using Graphviz)
* interface with Excel as a workbench (via xlwings)

There are tests (in tests.py), both the set from ApplePy as well as new ones using the assembler, as part of the effort of learning 6502.

I'm currently not developing on Papple2, but I can very well see myself coming back to it at a later point in time.

## Virtu
The replacement for Papple2 is Sean Fausett's [Virtu](https://github.com/digital-jellyfish/Virtu), or more precisely the [hex-ray branch](https://github.com/sicklittlemonkey/Virtu/tree/hex-ray) authored by Nick Westgate, his collaborator. Nick has been really helpful in rekindling my interest in this reverse engineering project. He also provided a partial assembly for Robotron (incorporated in my asm), which was helpful for making progress.

Virtu has been abstracted to a software framework which can take advantage of the various implementations, namely WPF, Silverlight and XNA. It's a really nice piece of software, and it works like a charm. If you want to run the C# software in this repo you'll need to clone [my fork](https://github.com/fschuhi/Virtu/tree/hex-ray).

## SourceGen
Python become too slow for the kind of debugging I wanted to engage in, which was the reason why I hibernated the project for two years. I've never really abandoned it, though. Due to an unrelated reason, I've recently become interested in C#. The reverse engineering project was a nice learning experience when it came to Python, so why not try the same for C#?

On the 6502.org forum Andy McFadden pointed me to his [SourceGen](https://6502bench.com/) disassembled which is written in C#. This was the signal to come back to the project and give it another try.

My  current disassembly is **Robotron (Apple).asm**, in the _Disassemblies_ folder.

Right now I don't intend to work on [SourceGen]([https://github.com/fadden/6502bench/](https://github.com/fadden/6502bench/)), but that might change, depending on the course the project takes. I'm certainly interested in symbolic debugging, so I'll at least work with SourceGen's JSON configuration file for the Robotron source.



	
