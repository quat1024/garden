*Part of the [OSTEP notes](./index)*

# Virtualization

When I think of "virutalization" I think of VirtualBox, hypervisors, Docker, and the like. This book encourages a broader definition: virtualization is taking a physical resource and making it into a virtual resource.

Virtual resources are resources that are easier to share:

* [*Timeslicing*](./timeslicing), allowing dozens of programs to have exclusive control over the CPU
  * Each process is given a turn on the [scheduler](./scheduling)
* [*Memory protection*](./virtualmemory) or *virtual memory*, allowing dozens of programs to think they have exclusive control over the memory

and easier to work with:

* *Hardware abstraction*, where a program doesn't need to know the specifics of your hard drive in order to write files to it, or the specifics of your video card to draw pixels to the screen
  * Historical counterexample: In the DOS era "device drivers" did not exist to the same degree they do now. DOS games had to individually build in support for dozens of sound cards
* *System calls*, allowing programs to ask the OS to do something on the program's behalf
  * Program can leverage functionality inside of the operating system

The operating system is a resource manager, doling out access to the limited physical resources as it sees fit.

## Persistence

The OS provides access to a file system, but unlike other resources programs don't get their own private file system. (It's easy enough to emulate one by making a temporary folder with a random name.)

The file system is also a good opportunity to talk about system calls. Your program doesn't have to tell the hard drive to spin up. (Device drivers!)

## Permissions

You can ask the OS to read a file with a system call, and it can refuse. How does that work? What prevents me from accessing the sectors of the hard disk myself?

This is managed at the level of syscalls with "hardware privilege levels", sometimes called "rings". Instead of the OS being a simple library of functions, the OS contains privileged areas that you can only access with a special "trap" instruction. The OS decides when and where you can perform traps, and in user mode you can only call existing traps; you cannot create your own or modify them.

Invoking a trap is the only way to enter "kernel mode" where the CPU is allowed to do more things. But invoking a trap also jumps to the location of the trap handler, outside of your control, and when the kernel returns from a trap it also drops back into user mode. So you cannot ever run user code in kernel mode.