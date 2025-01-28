# "Operating Systems: Three Easy Pieces" notes

Honestly I'm not in the mood for studying, but if I can pass it off as "filling out my ✨ *digital garden* ✨" then maybe I'll want to do it!

I'm [reading OSTEP](https://pages.cs.wisc.edu/~remzi/OSTEP/) for an operating systems class ("Systems 2" here at OSU). This is an open access book and apparently it's pretty famous if you can get past the jokes.

(These notes aren't chapter-by-chapter.)

* A main theme of the book is ["virtualization"](./virtualization); the operating system pretending limited physical resources are more plentiful, or fooling programs into believing they have exclusive access over something they don't.
  * Accomplished with [timeslicing](./timeslicing), [virtual memory](./virtualmemory), and other techniques.
* A [process](./processes) is some task that can have a turn on the CPU.