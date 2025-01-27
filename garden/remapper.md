# the question of the day is, can i beat tiny-remapper?

i think there are 4 phases to remapping

* parse mappings file
  * hard to parallelize this! disk IO be like that
* read class hierarchy
  * scan every class (both in the classes-to-remap and the remap classpath), look for non-`private` methods, superclasses, and superinterfaces
  * this is embarassingly parallel. for JDK classes we can even precompute it
* compute method owners
  * if class B extends class A and both classes define "public void foo()", then we need to recognize B.foo overrides A.foo
  * for each class, walk up the superclass tree looking for someone else who defined that method
  * this is sorta embarassingly parallel? if class C extends class B, if we compute serially we can leverage knowledge of B.foo being an override of A to infer that C.foo is also an override of A
  * i think in practice class hierarchies tend to go wide not deep, so parallelizing this is probably fine. might need a profiler whack.
  * (basically the design question is should we write to methodmetadata.owner right away to reduce browsing time, or defer them all to the end to reduce contention)
* actually remap classes
  * class and field renames are easy, they're straight from the mappings. "total" set of method renames should be inferrable from the hierarchy analysis
  * what i mean by that: we have metadata for every non-private method that explains what its "true" owner is, and that can be easily fed into mappings lookup
  * this should be enough information to asm every input class and write it back in a parallel fashion

fork-join with three phases. map reduce. idk.

INTERESTING: if it is acceptable to hold everything in-memory (which is probably okay), we can read all classes from the jar then start parsing mappings in parallel while we compute method owners (i'm assuming you can only read one file at a time cause of the realities of disks). while we're doing the final remap phase we can also drop our copy of the original classes as soon as the ASM ClassReaders get their hands on them

observations

* zip processing is... weird
  * duct-tape solution: zipfilesystem like tiny-remapper use
  * non-class resources are annoying to copy with zfs though... really need a way to copy a file without recompressing it
  * fancy solution: something that reads the central directory and dispatches the decompressing work to each worker thread
  * and some way of collecting them all at the end. ideally in a stable iteration order?
    * the problem of course is that class remaps can change filenames, and in some cases order is not preserved
    * read each input class name, remap them into a treeset or something, write them back in that order
    * and by that i mean, whoever's in charge of writing holds on to a sorted list of "expected next filename", if it receives the "correct" filename, great, else store it in a temporary side map
* there is probably a lot of stuff tiny-remapper does that this does not do. especially, especially error checking.
* i have no idea how generic signatures work. are they *all* stripped? spacewalkermc/sparrow-and-raven?

some tiny-remapper options and what they do

* ignorefielddesc: fields use a class/name model instead of a class/desc/name model
  * useful for MCP which doesn't list field descs
* forcepropagation
  * ?
* knownindybsm
  * something about invokedynamics (often called "indys" here)
* propagateprivate
  * probably controls whether `private` methods still participate in the ownership dance
* propagate bridges
  * "enabled", "disabled", "compatible" options
* removeframes
  * proly strips stackmap frames (?)
* ignoreconflicts
* checkpackageaccess
* fixpackageaccess
* resolvemissing
* rebuildsourcefilenames
* skiplocalvariablemapping
* renameinvalidlocals
* invalidlvnamepattern
* nonclasscopymode
  * what to do with non .class files
  * FIX_META_INF mode removes digital signatures (the thing you "delete meta inf" for), as well as mapping Main-Class, Launcher-Agent-Class, and services
* threads
  * hehe
* mixin
  * enables a little MixinExtension that also remaps mixins

what are some non-obvious features of tiny-remapper to look at?

* can process individual `.class` files as well as jars (`TinyRemapper#readFile`)
* supports multi-release jars (this is what the `Mrj` stuff is about in the code)
* does not parse `module-info.class`
* something something, "input tags"? have to investigate those more
  * i think the purpose is so you can shove every fabric mod jar into the same tiny-remapper with different input tags, and pull them out jar-by-jar
* something about bridge methods
* it kind of has a similar structure to what im thinking of.. hmm
  * usage (as prescribed by Main) is
  * addNonClassFiles (one pass over the jar)
  * readInputs
    * filters down to read(Path[], boolean, InputTag)
    * for(Path input : inputs) futures.addAll(read(...))
    * that is read(Path, boolean, InputTag[], boolean, fsToClose)
    * walks the ZipFileSystem and adds a new CompletableFuture for each class
    * so class reading is parallelized per class..!
  * readClassPath
    * same thing but saveData is set to false
    * which doesn't seem to do anything, actually?
  * apply
    * synchronized(this), just in case
    * first call refresh()
      * ensures all pending read operations are done
      * loadMappings
      * checkClassMappings
    * sometimes remapped classes are diverted to a ConcurrentHashMap (if fixPackageAccess || inputTags) but other times the remapped class is sent directly to the immediateOutputConsumer
    * ok so class ordering is probly not stable lol
* the OutputConsumerPath (writes to the jar with zfs) has a "threadSyncWrites" option, if enabled a reentrantlock prevents writes from more than one thread
  * unused in org:fabricmc. apparently unused on all of github! ok

but yeah it basically has the same structure as i'm proposing :skull: read in parallel (with zipfs), propagate in parallel, write classes in parallel (with zipfs). i guess the main differences in mine are that i want to read mappings concurrently with propagation, i want propagation to be unidirectional, and i want to use plain java instead of zipfilesystem

tiny-remapper propagation is kinda weird, i think it renames at the same time. some insightful comments left in the source

```c
/*
 * initial private member or static method in interface: only local
 * non-virtual: up to matching member (if not already in this), then down until matching again (exclusive)
 * virtual: all across the hierarchy, only non-private|static can change direction - skip private|static in interfaces
 */
```

* "down propagation from static member matching the signature starts its own namespace" - hmm
  * `class A{void foo()}, B extends A{static void foo()}, C extends B{void foo()}` ?
* the "forcePropagation" file comes into play here
  * THEORY: might have something to do with correcting private->public ATs?
* something wacky with bridge methods

as expected "up" propagation calls propagate() on superclasses/superinterfaces, and "down" propagation calls propagate() on subclasses

oough there's also `isAssignableFrom` logic? i think it's used as part of resolveMethod, comments there make talk of the jvm spec

article from proguard about it https://www.guardsquare.com/blog/behind-the-scenes-of-jvm-method-invocations#Virtual_methods

https://docs.oracle.com/javase/specs/jvms/se17/html/jvms-5.html#jvms-5.4.6

interesting: hotspot will IncompatibleClassChangeError in certain cases where method lookup is actually ambiguous https://jvilk.com/blog/java-8-specification-bug/

while i'm here, the specific overriding rules: https://docs.oracle.com/javase/specs/jvms/se21/html/jvms-5.html#jvms-5.4.5

* mC can override mA if:
  * mC and mA have identical names and descriptors (good)
  * mC is not PRIVATE
  * one of the following constraints on the base method mA is true
    * mA is PUBLIC or PROTECTED
    * mA is not private and appears in the same package as mC
    * mA is not private and there's a method mB in a class between them blah blah

that final constraint is very complicated, basically what it means is that if you're scanning upwards for an overriding method and you find a `public` one, you are permitted to continue scanning upwards even through package-private methods you can't see. the example from the spec is

```java
public class A           {        void m() {} } //D.m can override this (!)
public class B extends A { public void m() {} } //D.m can override this
public class C extends B {        void m() {} } //D.m cannot override this
//different package
public class D extends P.C { void m() {} }
```