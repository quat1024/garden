# Project Sanity

For lack of a better name, the goal here is to identify why writing Minecraft mods makes me feel stressed/upset, and then address those problems. Hopefully this will make me more excited to write Minecraft mods in the future.

## Performance problems

* **A:** Neoforge tools like ModDevGradle, being decomp-based, are very slow. It also doesn't seem to put things in a global cache anymore (if it does, i seem to miss the cache every time)
* **B:** The IDE takes a couple seconds/minutes to re-"index" a bunch of stuff every time I open it. When I port multiple mods at once, I am often waiting for the IDE to think in between mods. I don't like it.
* **C:** It takes a long time to start the game.

I can address **A** by killing ModDevGradle and installing Forge with binpatches, which I am attempting in [InstallerToolsRuntime](https://codeberg.org/CrackedPolishedBlackstoneBricksMC/InstallerToolsRuntime). Early results are promising; it takes about 60 seconds to install Forge like an end-user, compared to ~11 minutes to let ModDevGradle chug.

I can address **A** and **B** by using a monorepo to hold the source to all my mods. This means I only need to set up O(version support &times; loader support) minecraft workspaces, not O(version support &times; loader support &times; mods).

I can try and address **C** by configuring a JDK like DCEVM or JetBrainsRuntime, which has better support for class redefinition. This should allow "hot swap" to work in more situations. I can also make sure appropriate performance mods are in my development environments where relevant (maybe lazydfu).

## Friction

* **D:** Sharing code between my mods is a pain.
* **E:** There is a lot of friction involved in setting up a new mod workspace, so a lot of small mod ideas never get over the hump.

I could solve **D** using a library mod. However I would not enjoy needing to keep it in-sync with my main mod or foisting that complexity onto users. Also, I like the ability to easily change the library; I noticed splitting Zeta off from Quark kind of killed its development momentum.

I experimented with solving **D** in `modfest-oneoffs` by writing a library which exists in the same repo as the other mods, and gets *shaded* into all jars using it (although I went back on the shading trick before Modfest, to avoid creating complexity right before the event).

I solved **E** in `modfest-oneoffs` by using a "one mod per *source set*" approach. This meant I could easily spin up a new mod by creating a new source-set and copying over a few `fabric.mod.json` files. I could hopefully generate even more files automatically and automate more things from the buildscript.

## Just don't like it

* **F:** Multi-loader multi-version support is just not that much fun to do.
* **G:** Publishing a zillion versions of mods to CurseForge and Modrinth is annoying and takes a lot of manual work.

I can solve **F** by simply dropping support for some versions and loaders. I could look at CurseForge and Modrinth download statistics to find which versions people don't seem to care about.

I can solve **G** by *finally* setting up automatic publishing.

# Monorepo design

Normally I write multiloader where you have two "axes", minecraft version and modloader choice. Moving to a monorepo means "the mod" becomes a third axis.

Due to limitations in Minecraft plugins I need to make "vanilla 1.x", "fabric 1.x", and "forge 1.x" entirely separate Gradle *subprojects*. It should be fine to do one mod per source-set within those subprojects.

Wrt run configs, i would like the ability to make one giant run config containing all the mods at once, and/or smaller run configs containing just one mod at a time

* MDG *should* support multiple source-sets per "run config": https://github.com/neoforged/ModDevGradle?tab=readme-ov-file#isolated-source-sets
  * I remember having trouble with this before, but maybe I was holding it wrong
* Loom does not https://github.com/FabricMC/fabric-loom/blob/b37c4d3474fccd30f69beb25a20cc84da94f0574/src/main/java/net/fabricmc/loom/configuration/ide/RunConfig.java#L76
  * There is a type of workaround: https://github.com/quat1024/modfest-oneoffs/blob/1bc756d43b86a56e573fcf11787a4456e3ca7b02/build.gradle#L67-L69
* This resource about gradle "configurations" is probably helpful https://dev.to/autonomousapps/configuration-roles-and-the-blogging-industrial-complex-21mn
  * Especially for consuming artifacts published by other projects / source sets
	* Can i avoid `multiloader-template`-style "manual concatenation of classpaths"

In `modfest-oneoffs`, my shading setup for Loom was like this https://github.com/quat1024/modfest-oneoffs/blob/1bc756d43b86a56e573fcf11787a4456e3ca7b02/build.gradle#L65-L110 . I never wrote anything like that for neoforge so I'll have to puzzle out how MDG works

# Action items!

* Make a monorepo. Start moving mod source code into the monorepo.
* Figure out alternate JVMs which have better class redefinition support.
* Figure out which versions I want to drop.
* Continue thinking about enhanced Minecraft plugins like InstallerToolsRuntime and toybox which don't have as many limitations...