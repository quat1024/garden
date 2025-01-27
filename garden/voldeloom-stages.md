# Voldeloom stages

or, "How to deobfuscate Minecraft", with a focus on old versions since that's what [Voldeloom](https://github.com/crackedpolishedblackstonebricksmc/voldeloom) is designed for.

## Manifest index

Fetch this file: https://piston-meta.mojang.com/mc/game/version_manifest_v2.json . Under `versions` is 1 json object per version, pick the one you want and follow its `url`.

You could get away with simply never caching this file and downloading it every time new version metadata is requested. If you did want to cache this file, a good policy would be "until someone requests version metadata that isn't in this file", which would be essentially forever because Mojang seemingly never republishes old versions.

## Version manifest

You end up with a file like this: https://piston-meta.mojang.com/v1/packages/7aa8e9aeacf4e1076bfd81c096f78de9b883ebe6/1.4.7.json

Lots of miscellaneous metadata in there.

* `downloads/client/url` and `downloads/server/url` contain the obfuscated client and server jars.
* `libraries` contains third-party libraries. These need to appear on the compilation and runtime classpath.
  * The ones with Maven coordinates are resolvable against Mojang's Maven server at `https://libraries.minecraft.net/`.
  * Most libraries are written in Java but there are some natives. The correct one needs to be downloaded per-platform and they need to be extracted.
* `mainClass` has the entrypoint to the game.

OSX users and especially M1 Mac users have reported issues with voldeloom's natives implementation. Apparently Macs need a different set of natives entirely. Prism Launcher supplies different manifests.

You can cache these indefinitely.

## Binpatching

Forge is usually a source-patch toolchain (anyone remember `setupDecompWorkspace`). However, end-users do not end up decompiling minecraft and installing source patches. Voldeloom installs Forge like a user would.

Forge for 1.5 and earlier did not ship binpatches; it was a jarmod you could paste atop *either* a client or server jar. Mojang started looking funny at Forge for redistributing large chunks of the game, though, so from 1.6 through ...probably 1.12 Forge shipped "binpatch" files. These are binary diff files which need to be applied to the client and server jars *before* merging them.

Binpatches are contained in the file `binpatches.pack.lzma` inside release copies of Forge. Decompress with `LZMAInputStream` from `xz`, a `Pack200CompressorInputStream` from Apache Commons Compress, and finally a `ZipInputStream` from stock java. Oold versions of Apache Commons Compress contain a [broken Pack200CompressorInputStream](https://github.com/apache/commons-compress/pull/360), but a [workaround](https://github.com/apache/commons-compress/pull/360#issuecomment-1429003923) is possible.

Client binpatches are stored in `binpatch/client/` and server binpatches are stored in `binpatch/server/`. The file format is defined in terms of Java's `DataInputStream`:

* `readUtf()` - internal "name" field, only used in Forge for debugging printouts
* `readUtf()` - source class name. The original name of the target class.
* `readUtf()` - target class name. The MCP mapped name of the target class.
  * This field exists because Forge applies binpatches during classloading.
* `readBoolean()` - exists at target.
  * If true, this patch modifies an existing class, if false, this is a "patch" that "patches" a 0-byte file into the desired class.
* `if(existsAtTarget) readInt()` - Adler32 checksum of the original class. This field isn't written for `!existsAtTarget` patches.
* `readInt()` - Length of the rest of the patch.

immediately followed by a patch in the [Generic Diff Format](https://www.w3.org/TR/NOTE-gdiff-19970825.html).

To apply binpatches statically:

* Loop through class files in the vanilla jar, apply diffs where the vanilla class name equals the `sourceClassName` field of an `existsAtTarget` binpatch, and write the patched class.
* Loop through `!existsAtTarget` binpatches, apply them to `new byte[0]`, and write the patched class under the name given in the `sourceClassName` field of the binpatch. (Not the target class name!)

To apply binpatches at runtime:

* When loading a vanilla class, first see if a binpatch exists with the same `targetClassName`. If so:
  * If the patch `existsAtTarget`, get the bytes of the vanilla class with the corresponding `sourceClassName`, apply the patch, and return the patched class bytes.
  * Otherwise, apply the patch to `new byte[0]` and return the patched class bytes.

(Forge technically supports applying more than one binpatch to the *same* vanilla class, but AFAIK they never shipped any versions that do that.)

## Joining client and server jars

Zip the jars back together. [`fabricmc/stitch`](https://github.com/FabricMC/stitch) has a `JarMerger` implementation that I borrowed in Voldeloom. The process is not too difficult:

* For each class, if the class is the same across the client and server, or if the class only exists in the client *or* the server, copy it without modifying it
* Otherwise, frankenstiein a class together by blending properties of both. A lot of class metadata is hard to "merge" but is usually the same across client and server anyway (such as the name of the class, the access modifier, etc). You'll need to paste annotations, fields and methods from both input classes into the output class though.
  * It's very helpful to apply `@SideOnly` annotations to things that come from one jar.

### Aside: Forge dependencies

Ancient versions of Forge had some godawful automatic-dependency-downloading system. The servers are now dead so you'll have to mirror the libraries yourself. Fortunately if you already have the jars downloaded, Forge won't try to contact the dead server.

To find the list of jars to download:

* pre-Launchwrapper era (1.5 and below): perform static analysis on `/cpw/mods/fml/relauncher/CoreFMLLibraries.class`, look for string literals ending in `.jar`. These are "lib-downloader libraries".
* post-Launchwrapper, parse `/version.json` just like it's a vanilla verison manifest, and look for libraries containing a `url` field. These are "maven libraries".

To download lib-downloader libraries from the Prism Launcher mirror, append the filename to `https://files.prismlauncher.org/fmllibs/` and download. Maven libaries can be found on Maven Central.

You'll need to supply these on the compilation and runtime classpath. AFAIK lib-downloader jars need to be in a specific spot in `.minecraft` to cause FML to not try and redownload them -  can't remember the exact path right now.

## Jarmodding

Create a new jar, copy the vanilla jar into it, and then copy the Forge jar right on top.

Pre-Launchwrapper this is absolutely necessary because this is how Forge's jarmods get applied. Post-launchwrapper, you can probably keep Forge in its own jar, just remember to remap it properly.

## Access transformers (1.6 and below)

In forge 1.6 ATs are applied to unmapped class names. We haven't remapped yet so this is the correct time to apply ATs.

From Forge, parse them out of `forge_at.cfg` and `fml_at.cfg` - I'm not sure if these are hardcoded magic names or if they are referred to from somewhere. Also parse user-provided ATs if they are provided at this stage.

The file format is a bit involved. Voldeloom's AT parsing code is [here](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom/blob/4b49ff9c7746025cdcceb506c8822571a9c3e1d6/src/main/java/net/fabricmc/loom/mcp/ForgeAccessTransformerSet.java#L94). This class is a mess because the format has changed several times over the years.

## MCP remapping

In this step we go from Proguard names to "SRG names" like `func_12345_a`. I distinguish this from "renaming", which is going the rest of the way to human-readable names.

This is difficult and I intend to write more notes about it some time. The main puzzles:

* Off-the-shelf `tiny-remapper` does work, but ofc having it interpret SRG mappings is an adventure.
* It is also designed for ASM versions later than 4, which is what Forge uses to parse classes.
* Forge generates a few inner classes which did not exist in the original source, like `amq$1`, and those need the `amq` mappings applied to them
* More headaches

## Mapped access transformers (1.7 and above)

Exactly the same as unmapped ATs except the file format is a little different, and you apply them after remapping.

## Renaming

Now we apply renamings, the `func_12345_a` -> `readableMethod()` stuff. The original MCP toolchain did this with *find-and-replace* over the decompiled source code (yes!) so off-the-shelf remappers will be too smart.

Since Voldeloom is not a source toolchain, I wrote [my own renamer](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom/blob/4b49ff9c7746025cdcceb506c8822571a9c3e1d6/src/main/java/net/fabricmc/loom/newprovider/NaiveRenamer.java#L24) that applies renamings as naively as possible, ignoring "owning class" information and type information.

### Aside: Dependency remapping/#renaming

If the user has provided release jars straight off of curseforge (not some kind of `-dev` jar) as dependencies for their mod, they will be mapped in the *distribution naming scheme* before they are suitable for compiling the game against & running the game with.

* In 1.5 and later, the distribution naming scheme is SRG, just perform the naive renaming pass.
* In 1.4 and earlier, mods are distributed in proguarded names (same as vanilla minecraft) so you must perform remapping and renaming passes on them.

## Decompiling

(Well, since we're not a source toolchain this is an optional developer nicetie.)

Decompiling is easy, just feed it through fernflower.

Java compiles switch-over-enum to a "switchmap" class with a specific naming convention. The MCP authors did not know this, so they would give the class a different name. Fernflower chokes on this and throw an exception when decompiling methods containing switch-over-enum.

Fabric's fork of Fernflower can create a "linemap" file, which is very important for recovering the ability to place breakpoints in the generated source code.

## Linemapping

Basically Fabricflower can output a list of what source lines in *its* output correspond to what instructions in the *original* bytecode. We need to go through the bytecode and manually fix up the line-number tables so that they match Fernflower's output, instead of being junk data or corresponding to Mojang's private source code.

I don't fully understand the file format or the process; just borrowed the code from Loom. [Here it is.](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom/blob/4b49ff9c7746025cdcceb506c8822571a9c3e1d6/src/main/java/net/fabricmc/loom/util/LineNumberRemapper.java).

In the plugin, present the decompiled source-code to the user in the "attach sources" dialog, and put the *linemapped* jar (not just the renamed jar) on the classpath. Now breakpoints will work.

At this point the modder has a functioning dev workspace. One more thing needs to be done in order to release the mod.

## Reobfuscation

The jar now needs to go from the MCP `readableMethod()` naming convention into the distribution naming convention, which could be either SRG names or Proguard names. Despite the SRG -> MCP renaming using a naive renamer, reobfuscation always uses a full remapping engine.

In 1.5 and later, mods are distributed in MCP names (`func_12345_a`).

* Class names: Leave untouched.
* Field and method names: Invert the SRG -> MCP mappings.

Before that, mods are distributed in Proguard names.

* Class names: Apply the Proguard -> SRG names in reverse.
* Field and method names: Invert the SRG -> MCP mappings, and compose with inverted Proguard -> SRG mappings.

Made that sound more complicated [than it is.](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom/blob/4b49ff9c7746025cdcceb506c8822571a9c3e1d6/src/main/java/net/fabricmc/loom/mcp/Srg.java#L291-L330)