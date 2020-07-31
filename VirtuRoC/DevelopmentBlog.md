29.07.20 
- StackTracker

30.07.20 
- Stack<> for StackByte (probably a bit of an overkill)
- can it ever work?

types of RTS
1. regular return
2. return to after stash
3. jump table
4. exception to higher caller

31.07.20 
- refactoring
- 1. + 2. work
- 3. + 4. in code but not yet tested

=> StackWrapper does not need any annotations from the source

BUT: it is still useful to make a subroutine w/ e.g. #has_stash (or "#HasStash"?).
