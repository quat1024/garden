# Datapacks aren't a good method of modding

Minecraft keeps pushing in the direction of datapacks. I don't like it.

## Editor support is poor

You write a JSON file and hope it has the correct syntax / adheres to the correct (completely undocumented) schema. If datapacks are aimed at nonprogrammers, this is a *very* picky environment to throw them into.

## Debuggability is poor

Why is your file not being loaded?

* Is it in the wrong place?
* Is the datapack containing it disabled?
* Syntax error in that file?
* Syntax error in some other file, which if corrected would load the file you want?
* Something in another datapack overriding it?

Who knows! You aren't given the tools to even start debugging this.

## Datapacks are not actually composable

The dream is that you can add ten datapacks and they all act independently. This doesn't shake out in practice. You can't add a biome without overwriting the entire overworld, for example; you can't create a feature and add it to "every appropriate biome", including biomes you haven't specifically coded support for.

## Commands are a very slow programming language

Apart from the usual overhead in parsing and validating commands, reading NBT, repeatedly selecting the same entities, etc etc etc: there is no generalized system for "event handlers". You cannot *react* to an event from a datapack, you must check every single tick if the conditions for the event are now met.

There is one exception: you can jank something together with advancements, *if* the event you want to listen for is something Mojang decided an advancement is necessary for. Just remember to revoke the advancement immediately after it's granted -- which is more overhead, and not something you *ever* have to worry about with a real event system.

## Data ossifies

Making something configurable through JSON causes "special cases" to become against the grain. Going with the grain of JSON means that every recipe/loot-table/whatever functions in exactly the same way; the list of exceptions is small.

## Tags are a bad abstraction

Tags can create lists of things that are in some way "the same". This is great if you want to add "more of the same", and is not useful if you want to add something actually *new*.

By tagging your item with `boats` you can make it have a furnace burn time of 1200 ticks. By tagging an item with `banners` you can make it have a burn time of 300 ticks. If you want to make an item with a different burn time than the tags permit: too bad. If these tags are later bestowed with meaning other than "burn times", your items will pick that up too.

(Quilt experimented with some form of key-value tags; IIRC they never really caught on, but unless you plug the system into the scoreboard or whatever, in order to give the values in a keyvalue tag meaning, you need to write code either way.)

## Data is not code

Tags only meaningfully affect the game in ways Mojang permits them to. If you want to change the game in a way Mojang did not anticipate, you are out of luck. Basic features, like the ability to add new blocks and items, are still missing after years (due to the code complexity involved in allowing blocks and items to appear and disappear at runtime), leading people to reskin existing blocks and hope noone notices.

I know that some people find it fun to use font resourcepack hacks + misuse chest GUIs + five mcfunctions that run every tick + *whatever else people do* in order to create basic functionality that you can do *correctly* in five minutes with a mod. I don't find it fun.

## Data resists abstraction

You want to create recipes for sixteen colors of stained glass. What to do. In any reasonable programming language, you loop over the colors and stamp out a recipe for each color. In datapacks, because data is not code and you don't have loops or functions, you must create a recipe file for the red stained class, copy and paste it for the orange glass, copy and paste it for the yellow glass...

This is so ridiculous to expect of people that Mojang doesn't even dogfood their own datapack system. They wrote internal tools that stamp out thousands of JSON files based on a *code* specification ("data generation"). The ideas live in code, then they're flattened into a bunch of json files, then they're read back by more code... this makes the json files... what, exactly? An intermediary?

By working at the level of JSON files, you're working as a second-class Minecraft content author, picking up Mojang's pieces. You could argue this is necessary for sandboxing. That's not true; Factorio uses an embedded copy of Lua and they stamp out lots of content with loops.

# In conclusion

Datapacks are not my favorite method of authoring content.

# See also

the ["inner-platform effect"](inner-platform)