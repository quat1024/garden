*Part of the [OSTEP notes](./index)*

# Processes

Virtualizing the CPU means more than one thing can run on it. We need some notion of "a thing which can run on the CPU for a little while". And we want a process scheduler, which can allow each process to have its turn on the CPU.

You need some operating system-level API to spawn and delete processes, check the current status (running? stopped? waiting on something?), maybe ask to pause or resume it or change its importance.

## Loading

Programs exist as files on the hard drive. The CPU runs instructions from memory. The hard drive is not memory.

So of course, starting a program requires copying its code from the hard drive and dumping it somewhere in memory. Programs also require data

There's lots of subtopics to drill into. An example: it would be silly if a program that required 20mb of scratch memory needed 20mb of blank space in the file. So there are ways to tell the loader "allocate X amount of memory for me and fill it with zeroes" without literally including a template for that memory in the file. 

## `fork`

Linux has a very silly way to make processes. If you call `fork` the OS more-or-less copies and pastes your process control block into a new process.

That's why `fork` "returns twice" - from the original process, `fork` returns just like any other function call, and in the copied process, execution *begins in the middle of `fork`*, and the first thing the new process does is return from `fork`.

In the main process `fork` returns with the pid of the new, child process. The child process returns with `0` (if it wants to know the pid of the parent, there are separate APIs for that).

### Other linux process syscalls

There's `wait`, which waits for a process to stop, and `exec`, which replaces the current process with another one (it invokes the loader).

Yes `fork` and `exec` are weird; you can't just ask the OS to come up with a new process for you. Say you're a desktop and you want to start a program. First you `fork` the desktop process, then in the fork you `exec` the program you want to run.

The trick is that `exec` doesn't overwrite *everything*, so between calling `fork` and `exec` you have the opportunity to configure the child process (environment variables, where stdin and stdout are wired...). Critically, you configure the child process the same way you'd configure your own process -- you are about to *become* the child process, after all -- and so they didn't need to pack a bunch of configuration options into `exec` itself.

Compare the Windows API which packs a bunch of settings into `CreateProcessW`, and allows you to create already-suspended processes if you want to configure even more settings about them before they run. Nothing wrong with the Windows approach, it's just a different one!

Then there's signals, process groups, owning users...

## Scheduling policies

[Scheduling](./scheduling)