*Part of the [OSTEP notes](./index)*

# Timeslicing

They demonstrate a small program which waits for 1 second in a busy loop, prints `argv[1]`, waits another second, prints `argv[1]`, forever.

```c
while(1) {
  sleep(1);
  printf("%s\n", argv[1]);
}
```

As-written, it looks like this program would hog the whole CPU in a busy loop. But you can actually run several copies of the program and they will interleave their output, because the operating system dedicates a certain amount of time to each program.

## Multitasking

They bring up the shortcomings of *cooperative multitasking*, in reference to Mac OS v9. Under cooperative multitasking, programs take exclusive control of the CPU for as long as they want and yield control to other programs when they're ready to take a break. But if you write a busy loop that never yields, you freeze the whole system.

Later systems invented *preemptive multitasking*, which introduces a *context switch* mechanism. All of the CPU registers (including the program counter) are dumped into the process's *process control block* and execution returns to the process scheduler. The process scheduler picks a different process to run, loads *its* saved registers out of its process control block, and jumps back to where it was. The process continues, none the wiser it was interrupted for a bit.

\[Include a link to the scheduling page, when I make one.\]