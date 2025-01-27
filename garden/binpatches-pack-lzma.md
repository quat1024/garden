*Originally a Voldeloom note*

# binpatches.pack.lzma

In 1.6, Forge stopped being a jarmod. [Mojang was happy with this](https://github.com/MinecraftForge/FML/wiki/FML-and-the-new-launcher-in-1.6#on-some-inanity-seen-elsewhere):

> With the advent of the new launcher and other API stuff in the pipe, we expect the number of mods shipping base classes to drop significantly however, **and Mojang has politely asked that FML and MinecraftForge, jointly the largest platform shipping base classes, to cease once the new launcher is established**, a request with which I am happy to comply.

Instead, patches are done in a mildly less copyright-infringing way. The class `cpw.mods.fml.common.patcher.ClassPatchManager` handles the patches; `setup` loads them.

## Overview

* Inside Forge, there's a file `binpatches.pack.lzma`.
* This is LZMA-encoded `binpatches.pack`.
* This is a `Pack200`-encoded jar (with no class files).
* `binpatches.jar` contains a `binpatch/client` and `binpatch/server` directory.
* In each directory there are files with names like `net.minecraft.block.Block.binpatch`, `net.minecraft.block.BlockBaseRailLogic.binpatch`, etc.
* At runtime, Forge picks the `client` or `server` directory.
* Deltas are applied with a GDiff algorithm. Forge uses `com.nothome.delta` (modified to not use GNU Trove collections)

## Unwrapping lzma

[`xz` for Java](https://github.com/tukaani-project/xz-java) can do it.[^1]

[^1]: Free download no virus

## Unwrapping pack200

pack200 is an obscure, complex, and highly domain-specific compression scheme for Java archives, dating back to the applet days when download sizes were a big concern. It has been removed from the jdk so you need a third party decompressor such as Apache Commons Compress.

It was not the best compression scheme to use. Most of its complexity is about ways to compress class files, not resource files like these `.binpatch`es.

For a while commons-compress's pack200 parser was broken, giving you errors like `Failed to unpack Jar:org.apache.commons.compress.harmony.pack200.Pack200Exception: Expected to read 48873 bytes but read 3274`. See https://github.com/apache/commons-compress/pull/360 . You can fix it by wrapping the input in an `InputStream` that returns `false` from `markSupported`, and returns any nonzero value from `available`, [like this](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom/blob/10cb0c2f1d51c0570902e16d410868114baaba03/src/main/java/net/fabricmc/loom/mcp/BinpatchesPack.java#L63-L92). The bug has been fixed so I removed the fix from voldeloom.

## Unwrapping the jar

Forge reads all binpatches from `./binpatches/client/` on the physical client and `./binpatches/server` on the physical server.

The other set of files is ignored.

## Unwrapping the binpatch

The `.binpatch` file format is defined in terms of `DataInputStream`:

|           field | read with                                           |
|----------------:|:----------------------------------------------------|
|            name | `readUTF`                                           |
| sourceClassName | `readUTF`                                           |
| targetClassName | `readUTF`                                           |
|          exists | `readBoolean`                                       |
|        checksum | if "exists", call `readInt`; else 0                 |
|     patchLength | `readInt`                                           |
|      patchBytes | `readFully` into a buffer the size of `patchLength` |

* `name`: Internal name of the patch. Afaik this is *only* used for debugging in `ClassPatch#toString`.
  * It is *usually* similar to `sourceClassName` but it shouldn't br relied upon for this purpose.
* `sourceClassName`: The proguarded name of the class to diff against.
  * It is in 'package' format (dots separate packages).
  * When Forge's classloader attempts to load a class with a name `xyz`, it will look for binpatches whos `sourceClassName` is `xyz`.
  * (So the `sourceClassName` is still relevant for `exists = false` classes.)
* `targetClassName`: The *MCP mapped* name of the class to create, in 'package' format.
  * Launchwrapper `IClassTransformer` passes in both the proguarded & mapped names, and forge checks that both match the binpatch.
  * The patch *itself* does not create a class with this name. It creates a class with the proguarded name.
  * I don't use this in voldeloom.
* `exists`:
  * If `true`, `patchBytes` is a [gdiff patch](https://www.w3.org/TR/NOTE-gdiff-19970825.html) transforming the vanilla class into a patched class.
  * If `false`, `patchBytes` is a gdiff patch "from" a zero-length file into the target class.
* `checksum`:
  * If `exists = true`, this is the ADLER-32 hash of the bytes of the *vanilla* class *before* applying the patch.
  * Forge refuses to perform the patch (unless `-Dfml.ignorePatchDiscrepancies=true`) unless the hashes match.
  * If `exists = false`, this field is not present in the file at all.
* `patchLength`: The length, in bytes, of the rest of the file.
* `patchBytes`: The actual sequence of gdiff instructions.

## Applying binpatches

To apply binpatches statically, like Voldeloom does:

* Loop through class files in the vanilla jar, apply diffs where the vanilla class name equals the `sourceClassName` field of an `existsAtTarget` binpatch, and write the patched class.
* Loop through `!existsAtTarget` binpatches, apply them to `new byte[0]`, and write the patched class under the name given in the `sourceClassName` field of the binpatch.

To apply binpatches at runtime:

* When loading a vanilla class, first see if a binpatch exists with the same `targetClassName`. If so:
  * If the patch `existsAtTarget`, get the bytes of the vanilla class with the corresponding `sourceClassName`, apply the patch, and return the patched class bytes.
  * Otherwise, apply the patch to `new byte[0]` and return the patched class bytes.

## Trivia

* Even within the same patchset, it's possible for multiple patches to exist for a given source file.
  * Patch order is based off encounter order in the zip.
  * Forge does not use this feature.
* Why are `exists = false` patches used?
  * Sometimes Forge "patches off a `@SideOnly` annotation" by copying the class from the other jar using an `exists = false` binpatch.
  * Sometimes Forge creates a new inner class of a vanilla class, such as a switchmap.

## And the patch data?

It's simply a [gdiff file](https://www.w3.org/TR/NOTE-gdiff-19970825.html).