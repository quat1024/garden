*Part of the [OSTEP notes](./index)*

# Virtual memory

The authors write another small program which `malloc`s some memory, prints the location of that memory, then sets the memory to 0 and counts up every second. Running multiple copies of *this* program reveals that each copy has its own independent counter, even though each copy *believes* the counter is at `0x200000`.

This is virtual memory at work. Each process has its own address space, and inside each space, `0x200000` maps to different locations on the physical memory chip.

Also handy for guarding against shitty C programs that write memory out of bounds. Pre-memory protection, a memory corruption bug in one program could crash other programs or even the kernel.