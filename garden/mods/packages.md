# Packages

Packages is a storage problem, not a storage solution. Its packages can hold eight stacks of a single item. No more, no less.

Download on CurseForge and [Modrinth](https://modrinth.com/mod/packages).

*Since v2025, Packages is part of the [Season 2](/mods/season2) project.*

## Features

* Build Packages out of any combination of blocks you like.
* Smart insertion and extraction scans your entire inventory; no need to use an empty hand.
* Hold CTRL and completely fill or empty a Package with one click.
* Insert and remove items from Packages in your inventory too, just like a Bundle.
* Make a package "sticky" with the *Sticky Syrup*.

The default keybindings: right-click to insert one item, shift-right-click to insert a stack, ctrl-right-click to insert everything. Left-click is the same but takes items out of the package.

## Ideas

* Store your earlygame cobblestone hoard in a couple of inventory slots.
* Store your lategame cobblestone hoard in a nested stack of packages. You can store about 250,000 items in a package if you max out the recursion.
* Hold extra food, torches, and pickaxes so you never run out of tools on your mining trip.
* Then mop up all the cobblestone so you never run out of inventory space either.
* Conveniently access an item you need at a particular place; e.g. a lapis package near your enchanting table.
* Copy shulker box loader and unloader designs. They work on Packages too.
* Use them for decoration - packages are very customizable and display an item very large.

## Sticky packages

A "sticky" package will remember its contents even when it has 0 items. To make a package sticky, right-click it with the *Sticky Syrup* item.

Stickiness is a property of the *block*; when you break and replace a package you'll have to reapply the Sticky Syrup. This is so that packages continue to stack in the inventory.

### Old system

Prior to *Season 2*, stickiness behaved differently. There was no *Sticky Syrup* item. Instead, a package became sticky when it was placed next to a slime or honey block. The old stickiness mechanic is, for the time being, reenableable inthe config file.

## Oddities

* When you "take stack", if you're already holding an incomplete stack of the same item that's in the Package, it will give you as many items as it can without them needing to spill into another inventory slot. You can shift-click again to take more stacks.
* Packages don't make insertion/removal sounds if you are invisible.

## Modpacker info

Packages cannot be used to cause "nbt overflow" even though they are recursive. This is because packages can only contain one type of item at a time and there is a recursion limit.

In the Package Crafter, Packages can be crafted out of any `BlockItem` representing a solid-enough block. The item tag `packages:banned_from_package_maker` can further forbid items from being used to craft Packages if there are items causing display issues.

The item tag `packages:things_you_need_for_package_crafting` contains valid items for the lower-right slot of the Package Crafter. If you change this away from copper ingots, please adjust the language keys on the tooltip as well.

Any item can be put in a package except for:

* nonempty shulker boxes;
* nonempty bundles;
* packages over the recursion limit;
* anything where `ItemStack#canFitInsideContainerItems` returns false.

The item tag `packages:banned_from_package` can further restrict items from entering a Package.

In the config file, "package maker allowlist mode" can be enabled. Then only items in the `packages:allowlist_package_maker_frame` and `packages:allowlist_package_maker_inner` tags are permitted in the Package Crafter in the respective slots.

The block tag `packages:sticky` can be used to control "sticky" blocks for the old stickiness mechanic.

If a package block entity contains the NBT `{bcLocked:1b}`, the block is "locked" and cannot be interacted with. Note that the block can still be broken and this tag is not copied onto the item. You need another solution for making packages unbreakable if you want to use this tag. (This was added hastily for Blanketcon.)

In 1.21.1, the data component types used by Packages are:

* `packages:style`, used by packages to hold the frame/inner/dyecolor data
* `packages:cont`, used by packages to store their contents

## Credits

The Package Crafter model was designed by Kat.

It was unascribed's idea to allow in-inventory interactions like a Bundle.

## Changelog (Season 2)

### v2025.08.21

* Now available for 1.21.1 Fabric as well as 1.20.1.
* Now available for 1.21.1 Neoforge as well as Forge 1.20.1.
* New item: *Sticky Syrup*. Apply it to a package to make it *sticky*. Sticky packages remember their item even when they are empty.
  * This replaces the old system of packages becoming sticky when they are next to a slime/honey block. Not many people knew about it!
  * The old system is available behind a config option.
* Tweak interactions with regard to sticky packages. (For example, you can insert items into an empty, sticky package, even if they aren't items from your hand.)
* Remove the annoying honey particles from sticky packages. Sticky packages can now be distinguied by "sticky" text that appears when shifting.
  * It is behind a client config option, if you want them back for some reason...
* Stickiness might actually work on Forge!!!!! (lmao) it wasn't being enforced through the `IItemHandler`.
* Slightly less willing to be placed vertically. You have to look up/down a bit farther.
* Fix an issue where items which stacked to 16 could be deleted using Packages inventory interactions.
* On Fabric, a nonnull `RenderMaterial` is passed when working with fabric-api, possibly fixing some clientside mod-compat issues.
* On 1.20.1, migrate off of a deprecated `fabric-api` method for registering custom models.
* On 1.21.1, `PackageBlockEntity` no longer implements vanilla `Container`! Instead, modloader-specific inventory mechanisms are used.
  * On NeoForge, the Package exposes an `ItemHandler` capability. On Fabric, the Package exposes an `ItemStorage` API. 
  * This was a rather large change so I'd like to test it before backporting it to 1.20.1.
* On 1.21.1, the Package *item* also exposes these modloader-specific inventories.
  * This means other mods which can, e.g., pull blocks out of shulker boxes in your inventory, may be able to pull items out of Packages too.
  * This feature needs more testing.

On NeoForge, enable the "NeoForge Light Pipeline" in `Mods` -> `NeoForge` -> `Client settings` -> `NeoForge Light Pipeline`. This will improve the apperance of the Package Crafter.

On Fabric 1.20.1, if you have Sodium remember to install Indium. No longer necessary as of Sodium for 1.21.1.

