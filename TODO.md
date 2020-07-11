see also [README](README.md)

## breakpoints

* break on # of cycles, "stopwatch" (e.g. reset to stop at offset)
* switch trace on/off on breakpoints
* single-stepping
* have breakpoints using labels, not addresses

... concept of "guard" = non-breaking breakpoint

=> OnBreakpoint, OnGuard events

## watches

* switch watch on/off on breakpoints, guards 

## misc

* fake result from random number generator ($4C36)
* import labels from SourceGen
* grid view for selected memory locations
* ListBox w/ code
* multiples code ListBoxes which spring into action on PC in certain range
* constrain code ListBox for PC range
* sync w/ ListBox on breakpoint / single-stepping
* savepoints
