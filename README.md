# Robotron_2084
reverse engineering Robotron 2084 for the Apple ][

From the first post of a first [development blog on 6502.org](http://forum.6502.org/viewtopic.php?t=5517):
> With the proliferation of really good emulators for the Apple II, I have recently been re-introduced to the games I played decades ago. Then, in school, there were 6502 wizards who not only cracked the copy protection on those games but were actually able to understand and change them. Awesome! Since then it has always bugged me that I shied away from learning 6502 and diving into 8bit game design. I don't know why I have finally decided to try this myself, maybe it was just a critical mass thing. Anyways, here I am, all set.

Commenters on the above thread have given a lot of really good advice, for which I am grateful.

[The game on different platforms](https://www.youtube.com/watch?v=ejA0w-PmBZY)
[Apple II gameplay](https://www.youtube.com/watch?v=8fgwpn17gDQ)
[Review from 1984](https://archive.org/stream/Computer_Games_Vol_3_No_1_1984-04_Carnegie_Publications_US#page/n55/mode/1up)
[Robotron 2084 Arcade Guidebook](http://www.robotron2084guidebook.com/)

# Virtu
Main project dependency is with Sean Fausett's [Virtu](https://github.com/digital-jellyfish/Virtu), actually the [hex-ray branch](https://github.com/sicklittlemonkey/Virtu/tree/hex-ray) by Nick Westgate, his collaborator. Nick has been really helpful in rekindling my interest in this reverse engineering project. He also provided a partial assembly which was helpful for making progress.

Virtu has been abstracted to a software framework which can take advantage of the various implementations, namely WPF, Silverlight and XNA. It's a really nice piece of software, and it works like a charm.

If you want to run the C# software in this repo you'll need to clone [my fork](https://github.com/fschuhi/Virtu/tree/hex-ray).

# Usage

The goal of sotware in this repo is to reverse engineer Robotron 2084 for the Apple II. In this regard, Virtu and emulator/debugger features built on top of it are an important part of the toolbox.

As of now, everything in this repo is work in progress. The software is supposed to further my understanding of the executable. This repo collects my own progress; it does not want to be more than that.
