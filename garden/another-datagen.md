# Another way to do datagen

Super late, writing this on my phone before bed. Link this before i forget https://codeberg.org/quat/templates-mod/src/commit/d748e7ca0fe27b25e30f81915951d9553433330d/src/dgen/java/io/github/cottonmc/templates/dgen/Dgen.java#L64

What's bad about datagen?

- Poor locality. Generally you gen all the blockstates then gen all the item models then gen all the recipes. All of this stuff might "belong" to one piece of content but it's spread across ten files.
- Too-loose coupling. Easy to forget the blockstate or whatever, out of sight out of mind.
- Too-tight coupling. Sometimes you just want to pass an item ID as an argument, but the game makes you pass the actual `Item`.
- Gentime/runtime distinction. The gentime code has little to do with the game so there's a large incentive to leave it out of the built jar.
- Churn, of course, because Mojang touches it

Can we do better

## Facets

A "facet" is any aspect of any piece of content that needs some attention.

Here are some examples of facets:

- Assign *this* model to *that* item.
- Create *this* recipe for *that* item.
- Create *this* loot table for *that* block
- Assign *this* tag to *that* item and block

Here are some facets that are less traditionally datagenned:

- Assign *this* name to *that* item in `en_us`.
- Add *this* item to *that* creative tab.
- Apply *this* tooltip to *that* item.
- Register *this* block using *that* class.

## Facet Holders

A facet holder is anything with a bag of related facets. An item might have an associated lang entry, creative tab, and crafting recipe, for example, so it makes sense as a facet holder.

The main purpose of creating specialized facet holders is building domain-specific languages over facets. The "add to lang file" facet requires a lang key and a value, but if you have an Item facet holder you can make a "give the item a name" function which can prefill the lang key

Importantly: There is no restriction on what facets you can add to what holders, there is no restriction on how many facets you can add, and it never matters *which* hole a facet was put in. The domain-specific language for some facet might prefill the ID for you but you can always pick a different one

## Implementation

In templates I have a `Tmpl` holder which represents a block/item pair. They take the block id as an argument and then the double-brace init idiom is used https://codeberg.org/quat/templates-mod/src/commit/d748e7ca0fe27b25e30f81915951d9553433330d/src/dgen/java/io/github/cottonmc/templates/dgen/Dgen.java#L64 . The constructor sets the blockId variable and then the class initializer can use it.

So i make a bunch of `Tmpl`s.

Then i create a single giant FacetHolder, pour all the facets into it (plus a few more that don't belong to any `Tmpl`) and loop over them by type. Sometimes 1 facet = 1 json file, other times i loop over all facets of a type and collect then into one file

## Facet types themselves

- Builder style apis, no `final` or constructor parameters
- Serialize themselves to json with this crummy `Ser` interface. (lighter weight compared to like gson, and i don't need deserialization for most types)
- Heavy use of subclassing
- `Downcastable` base class for ergonomic builder types
- `Idable` base class for "anything with an id"
- `@Facet` annotation marks top-level facet classes, just used for facet holders
- `Id` is my own resourcelocation type

## Further work

Anonymous classes work pretty well for this. You can just write `blockId` and get "the current" block id.

I am very pleased with the locality.

Something something good night it's getting late





