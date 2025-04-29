# Reddit hivemind opinions

Let's go against the grain a bit.

## MCreator mods are always bad for performance / compatibility

Use your head: if the modder seems way too excited about their custom taco dimension, maybe skip that MCreator taco mod. And you weren't going to download the Emerald Tools And Armor mod with Microsoft Paint textures whether it was made with MCreator or not.

It's true that:

* Stupid shit has been done with MCreator.
* MCreator's scripting language is not very powerful so sometimes people drop back to vanilla commands.

However, do I need to mention that stupid shit has also been done with Java mods, and some Java mods also drop back to vanilla command execution? Did you know that *Botania* executes vanilla commands? (it's for datapackable special-effects for the Pure Daisy)

## LunaPixelStudios modpacks are made with AI / bad packs

They're not to your taste. That's fine, not every modpack is for everyone.

But they're popular for a reason, and part of the reason is that they are the most well-crafted modpacks in their particular markets.

* I can attest that they are a modpack group that takes performance extremely seriously.
* I'm glad *people looking for Better Minecraft* have Better Minecraft, instead of a reheated formulaic kitchensink, or some pack made by a rando.
* No they are not "made with AI" and I have no fucking clue where that rumor came from. Especially when I've only seen AI used in *non*-LPS packs...

## If it's datapackable, it's better

Code is king but data is not code. Sufficiently flexible APIs require code, and trying to shove them into a data-shaped hole results in [an Enterprise Rules Engine](./inner-platform). I really doubt "horrible JSON DSLs" are reaching the target audience of "people who do not like programming", given that I *like* programming and think they're horrible.

I feel like datapacks are putting a chilling effect on configuration options, too. Have you ever seen this exchange?

> * A: how do I remove (da-ta-da) from worldgen? there was an option in 1.12 but i can't find it now.
> * B: oh, worldgen is controlled with datapacks now!
> * A: great! so how do I do it?
> * *crickets*

Maybe if you're lucky B will toss over a Minecraft Wiki page about biome placement?

I don't think we should be throwing reams of JSON at people when they just want to do something simple. Noone should have to understand what a "configured placed feature" is to toggle something that, I must reemphasize, *used to be a boolean option* in the config file.

See [datapacks-bad](./datapacks-bad) for a longer answer.

## There are too many creepypasta mods

Back in my day there were hundreds of Lucky Block mods and we all agreed to look the other way. Let the kids have their fun.

## RLCraft sucks

RLCraft sucks *(affectionate)*. It's *kino*.

You are aware all the "realism" stuff is a joke, right?

## I need backport mods

I don't understand the clamoring for these. You can live without the 5 plants and 1 halfassed mob that Mojang put out in-between their tenth refactor of the registry system. You *could* get a backport mod to bring you even-more-halfassed facsimilies of this stuff, or you could just... explore the content already in the rest of your pack. Were you even going to do anything with a Sniffer anyway?

Maybe this is a boomer opinion. Have I ascended past the cycle of internet videogame FOMO and hype? I didn't even watch Minecraft Live this year!

## Old versions are poorly optimized...

Well, not entirely wrong. Depends what you mean by "optimized" though. RAM usage has shot through the roof in new versions, for example.

### ...and that's why I don't want to play any packs on old versions

Alright now you lost me.

Lower your render distance a touch, maybe install those crazy performance mods the GTNH guys are cooking, and enjoy some 10-year-old modded Minecraft community history even if it's in cinematic 24fps. It'll culture you at the very least.

# Uh oh modloader opinions

## Fabric performs better

Has this ever been proven? I have no idea where this comes from.

* This might have been intra-modder "Fabric's event system is much lighter than Forge's" shop-talk that escaped containment and got wildly out of hand. And/or people trying to talk up Fabric before there was really a compelling end-user reason to get it.
* Maybe it's because CaffeineMC developers originally worked only on Fabric, and the initial ports to Forge were done by third-parties who were not performance experts?
* maybe it's because if you install X mods on Fabric and X mods on Forge, you will get better performance on Fabric because `fabric-api` counts as 80 mods for technical reasons, and/or because there is simply less content on Fabric?

## Fabric is killing modding

First of all, Fabric is *driving* modding:

* Fabric dragged Forge into the Mixin era. This would never have happened if Fabric didn't prove Mixin was a reliable way to compose patches.
* The state of remapping would have never advanced, I argue, if Fabric didn't create the first viable MCP alternative.
* I believe Fabric invented jar-in-jar dependencies. Or at least Forge's implementation would still be a half-broken mess if Fabric didn't popularize the idea.
* Fabric proved that *so* much of Forge is unnecessary:
	* The event bus is unnecessary; arrays are fine.
	* Source patches, barriers to coremodding, and registry-replacements are unnecessary; Mixin is fine.
	* Registry events and "the forge registry" are unnecessary; vanilla registries are fine.
	* Mod load ordering is unnecessary; fine-grained ordering is fine.
	* `@SidedProxy` and `DistExecutor` are unnecessary; modders can be trusted with classloading, and clientside entrypoints are fine.
	* `AsmDataTable` is unnecessary; entrypoints and `ServiceLoader` are fine.
* By maintaining Voldeloom, a weird fork of Fabric's toolchain, I proved that creating a featureful dev environment for legacy Forge *without* a lengthy decompilation step is practical and realistic. Meanwhile, ModDevGradle still takes 50 years to decomp the game.

Fabric is obviously imperfect too. No runtime-mojmap in 2025 is a strange choice and an obstacle to cross-loader content. There is still no config API. Forge made the smart choice to annotate crash report stacktraces with the mixins targeting them, which gets a little messy but is handy from time to time.

Remind me to write up my other feelings on the loader that could have been. [The short version](https://types.pl/@quat/114418501154923898):

> "fabric's the modloader that lost", i think to myself while recording footage from the 130-player server with more than 500 fabric mods on it. it's a dead and dying loader, which is why i found all sorts of content i've never seen before while wandering the server. it'll never take off. it's killing modding.
> 
> i'm still probably going to prioritize neoforge for new content because i think it's where the players i want to reach are. so part of me wants to reminisce about what could have been, and the other part is like, what do you mean "what could have been"; it's here
> 
> obviously my feelings are complicated.

## Omg there are like 500 modloaders!!!

I understand that people are being hyperbolic with this statement, but there are *two*. Pre-1.21 there is Forge and Fabric. Post-1.21 there is NeoForge and Fabric. And that's all you need to worry about.

Two is, indeed, more than one. Modders also do not enjoy the whole "if i make my mod for X loader, i can't reach people on Y loader" question, if you can believe it. The truth is that there are fundamental differences in what modding *is* and *should be* that have not been resolved.

There was Quilt, but that project has pretty much wrapped up. People with more experience with Quilt will be able to write a lamentation similar to the one I wrote above about Fabric - I understand it had some *killer* APIs (including a config API! what a concept!) and it pushed modding forward in its own ways. And indeed, compatibility with Fabric remained high throughout its lifespan *specifically to avoid alienating people saying "OMG another modloader?"*, so you can install all your Fabric mods and be on your way.

Installing not-Neo Forge after 1.21 is a waste of time.

Other loaders that I see mentioned are:

* historical and not competing with either of the leading ones,
* modder's personal funprojects blown out of context -- yo, have you seen that one about the fish?,
* explicitly compatible with one of the main loaders,
* or some combination.
