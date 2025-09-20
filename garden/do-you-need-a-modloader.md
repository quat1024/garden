# Do you need a modloader?

> *Originally a response to [a redditpost](https://old.reddit.com/r/feedthebeast/comments/1njd6hz/is_it_reasonably_possible_to_make_a_large/)*

You *could* write a mod without any modloader; the idea is that you directly open up Minecraft's jar and replace the pieces of code you want to replace. This is called "jarmodding".

These days, this would be a *more* difficult method of modding than using a modloader.

## Tooling doesn't exist in the same form

The original *Mod Coder Pack* project was a tool to run a Java decompiler on Minecraft's source code and fix it up into something you could edit, plus surrounding tools to distribute your mod as something users could install with the "drag and drop into `minecraft.jar` and delete `meta-inf`" method.

But the original MCP fell out of favor after ≈1.12 because everyone was writing mods with modloaders and modloaders are just easier. The last jarmod I'm aware of is [Carpet Mod for 1.12](https://github.com/gnembon/carpetmod112), which uses a very old version of ForgeGradle which still contained patching tools (newer versions of Carpet Mod are just Fabric mods), and I'm not aware of any comparable project for directly editing the code of minecraft 1.20.1. Things have changed and the original MCP/ForgeGradle 2 projects won't work on the newer versions.

The spirit behind the project lives on as MCPConfig (used by Forge) and NeoForm (used by NeoForge), but they are used to develop the modloaders themselves, and are not designed to be used by anyone making a mod. They no longer contain the "export mod into something people can install by dropping classes into minecraft.jar" feature, for example, because the modloaders now use [a custom "binpatches" format](https://notes.highlysuspect.agency/binpatches-pack-lzma.html) to save space (and for [copyright reasons](https://github.com/MinecraftForge/FML/wiki/FML-and-the-new-launcher-in-1.6#on-some-inanity-seen-elsewhere))

## The same things are possible in other ways

If you *need* to directly edit Minecraft's game code, all major modloaders incorporate a library called [Spongepowered Mixin](https://github.com/spongepowered/mixin). With Mixin you can edit game code *as it is loaded into the game* without needing users to manually paste your edits over the minecraft jar, and there is a *much* reduced risk of "two mods conflicting because they wanted to edit the same class" (a huge problem in the jarmod days) because Mixin knows how to weave the patches together.

## The beaten path

Noone has written a tutorial for this kind of thing in 10yrs or so, and users are not really familiar with this method of installing mods anymore.

If you created a jarmod and uploaded it to curseforge and modrinth, people wouldn't really know what to do with it? It would be difficult to upload in the first place since these platforms expect you to pick a modloader the jar falls under.

## The same compatibility issues

In a modern environment, if you make a mod that's incompatible with both Neoforge and Fabric, you are going to have a difficult time convincing people to use it.

