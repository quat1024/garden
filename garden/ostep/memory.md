*Part of the [OSTEP notes](./index)*

# Memory

Unit of memory is the byte. Cpu can't really talk about less than a byte. (I think there are even larger practicalities, like the size of a cache line)

Cpu runs code from memory too, so programs have to get into memory before they can be ran.

Haters will say a kilobyte is 1000 bytes. Umm actually it's 1024.

$2^32$ bytes is 4gb which is max addressible memory on 32bit machines.

## how is memory used

How it used to be: No translation in effect at all. Accessing address `0xWhatever` accessed byte `0xWhatever` on the chip. Kernel usually at a known location in memory. Addresses for loads, stores, and jumps can be computed at compile time. The slide introducing this is called "Good old days"

Has problems. If we want to run multiple programs at the same time we can't just hope they use disparate memory addresses. Need the ability to relocate them. Processes can also scribble over each other's memory (which can crash them, or these days, we think about the security implications).

Programs might not even use all the memory they are allocated. Often programs have a stack and a heap and a big ol gap between them.  It would be a waste to allocate the same amount of physical memory "square footage" to one program that uses 5kband another program that uses 5gb of memory.

## virtual addressing

Lets keep it simple on the process side. Processes *think* they access memory from 0 to some maximum amount of memory in a big contiguous block. Between the process and the chip, though, we have a translation layer from that "virutal address" to a physical address on the chip.

Physical addresses don't necessarily have to be contiguous. They also don't even need to actually be in memory (swapping).

"OS and CPU collaborate to translate a virtual address to a physical address".

## pages

Generally we work in "pages", aka shift the memory address right a few times. Don't need to micromanage memory at the level of bytes, but dividing memory into chunks of, say, 4kb is a little more reasonable.

One page belongs to one process. "Huge pages" exist on some linux systems, as large as 2mb, but the page size is planck's constant for memory usage. You can't allocate less than a page without getting the whole page. Also other attributes are attached to the page such as whether the page is swapped out, memory protection info, rwx, etc so it doesnt make sense to grab less than a page.

## address translation

Turning a virtual address into a physical address.

You can imagine a simple scheme (without any pages, assuming contiguous memory) as a simple offset. If a process's offset is `0x1234`, then accessing virtual address `0` accesses physical address `0x1234`, accessing virtual address `1` accesses `0x1235` etc.

Implement memory protection by adding a "bounds" to each process. If the virtual address is greater than `bounds`, then trigger some kind of fault and quit the process instead of actually accessing the memory. Now processes can't scribble over each other.

The base address and the bounds become more things that are saved and restored across context switches. They need to cooperate closely with the cpu and memory management unit so they are kind of special.  Changing these memory registers is a privileged operation.

## problem with that simple scheme

* Again, it's a waste to allocate x mb for each process regardless of how much memory it actually uses
* What if it gets fragmented. Allocate a bunch of processes that ask for 1mb of memory, terminate every other process, then you can't allocate one that asks for 2mb even though there's enough free memory, just not in the right shape...
  * "Compaction" (moving processes around in memory) is very very hard. Need some way to fix up all the internal pointers (and not accidentally fix up numbers that happen to look like pointers). Not done in practice.

Could try segmentation. Code, heap, and stack all get their own segments which can have their own sizes. Well at least the chunks are smaller and can be appropriately-sized for each program, but fragmentation is still an issue.

Btw if you use high bits of the address to encode what segment it's in (aka "placing the segments REALLY far apart"), going from address -> segment is basically free

## how programs use memory

* `malloc`. Ask how many bytes you want. You get that many bytes.
  * Usually uninitialized
* `free`. Mark that memory previously returned by malloc is reclaimable.
* `sizeof` (in C). Compile-time magic for determining how big some datatype is, useful for passing to malloc.

Due to the "elegance" and "beauty" of the C memory allocator api 😒 malloc needs lots of bookkeeping. Specifically `free` has no way of telling how big the allocation was

This is also a fully general api and it's expected to do enough bookkeeping to handle any sequence of mallocs and frees. Needs to know where to put stuff. Very difficult algorithms are behind this, active area of research...

## free lists

Linked list data structure.

* Each node is placed at the start of a "free" block of memory and contains the size of the segment
* When allocating, make the previous freelist node point to the next freelist node (unlinking the current node from the list) and then overwrite the freelist  node with whatever the memory is allocated for
* When freeing, overwrite whatever was there with a freelist node and point it (at the head of the freelist?)
  * "Coalescing" - look for adjacent free blocks and merge them  into one big free block
  * can be hard if the free blocks are not contiguous in the list

## header

Because of the shitty malloc/free api malloc keeps a "header" which contains the size of the block (and other random crap). `malloc(size)` actually allocates `size + header` bytes and puts its stuff in the header

Freelist nodes and malloc headers occupy the same space, one is overwritten with the other when mallocating and freeing

You can put a "magic number" in the malloc header. When you free you can check that the magic number is still the same and a stupid C programmer hasn't clobbered it.

This is all academic I think real malloc implementations are fancier but u get the idea

## policies

User calls `malloc(100)` and there are 5 big-enough slots in the freelist. Which one to return.

* Best fit. The smallest one that fits.
  * expensive
  * but reduces fragmentation
* Worst fit (lol). The largest one that fits.
  * still expensive
  * leaves big empty spaces, i guess
* First fit. The first slot that's big enough. (greedy algorithm)
  * beginning of freelist becomes a little cluttered
  * Terminates early usually
* Next fit?
* "Segregated lists", specific list for objects of a certain size
* Buddy allocation - space partitioning
  * Fragmenty
  * Easy to coalesce though
* Not in the slides but I think a lot of production mallocators use "size classes", items of a certain size are rounded up into the nearest bucket that fits
  * Taking advantage of the idea that it's easier to work with objects of the same size (fewer headers, can use a bitmap to keep track of free slots etc)
  * Just remember not to allocate 65 bytes cause whoah there bucko youre gettin all 128 whether you want em or not

Thought balloon: How do freelists interact with parallelism?

## fragmentation

Malloc 3kb, malloc 1kb, malloc 3kb, malloc 1kb, repeat. Free all the 3kb stuff. Then malloc 4kb.

Assume all the 3kb/1kb allocations were placed back-to-back. Now we're in a situation where we have more than 4kb available but we don't have any *contiguous* 4kb region to put this 4kb allocation