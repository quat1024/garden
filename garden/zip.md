# Fast zips

The goal: "process" a zip file as fast as possible.

* Loop over every file in the zip
* Read the file into a byte array or something
* Mutate it
* Write it back to the zip
* Ideally the destination zip should contain files in the same order

There are 3 ways to read zip files in the java standard library

ZipInputStream, dates from Java 1.1

* Reads the zip file forwards, looking at the Local File header (LOC).
* Ignores the zip central directory
* Usage: read the next local file entry, then pull the file bytes directly from the zipinputstream. Cute
* Serial behavior. There is only one ZipInputStream and it does all the inflating. You can pass it *between* threads, I guess, but you can't read more than one file at a time

ZipFile, dates from Java 1.1

* Starts out by reading the Central Directory, located at the end of the file
* Usage: init the zip file, call entries() and pick out input streams you want
* Provides random access
* Maybe parallelizable? Try entries().parallelStream()...
  * Note that getInputStream has a synchronized(this) for some reason
* ONLY works with on-disk zips! AAAAAAA

the "ZipFileSystem", dates from Java 7 I think

* Fairly complicated and "heavyweight"
* Allows treating an on-disk zip like a file system
* Only works with on-disk zips!
* Parallel behavior: reading operations put the inflater input stream on the thread that's doing the reading

There are 2 ways to write them?

ZipOutputStream

* Simple
* Serial beahvior :pensive: there is only one Deflater
* Writes the central directory after writing all the files

ZipFileSystem (again)

* Parallel behavior: writing operations put the defalter output stream on the thread that's doing the writing
* Spills to disk if crossing a threshold on the size of the file

## This thing

Someone figured out how to reach into ZipOutputStream internals so you can parallelize the deflating procedure

https://github.com/gregsh/parallel-zip

Basically the trick:

* map: compress files individually with little ZipOutputStreams, but don't close them (so the central-directory stays unwritten)
* reduce: make a zipoutputstream, dump the compressed bytes directly into it while manually adding them to the zipoutputstream's list of already-written entries, then close the zip (so it writes the central directory)

How can it be improved ?

* Maybe reimplement the zip header writing code (instead of leveraging ZipOutputStream) and use DeflaterOutputStream
* Compute the adler32 or whatever in one pass instead of using CheckedOutputStream... the idea is that we context-switch less, i dunno if it makes sense though
  * Tried profiling this and pretty sure the difference was within the margin of error

## On zip

java's ZipInputStream is not actually conforming, because the central directory is supposed to be the source of truth for zip files. like, if the central directory doesn't refer to a file, it's supposed to be "deleted". In practice, though: Meh.