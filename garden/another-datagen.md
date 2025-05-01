# Another way to do datagen

Super late, writing this on my phone before bed.

What's bad about datagen?

- Poor locality. Generally you gen all the blockstates then gen all the item models then gen all the recipes. All of this stuff might "belong" to one piece of content but it's spread across ten files.
- Too-loose coupling. Easy to forget the blockstate or whatever, out of sight out of mind.
- Too-tight coupling. Sometimes you just want to pass an item ID as an argument but the game makes you pass the actual `Item`.
- Gentime/runtime distinction. The gentime code has little to do with the game at runtime, so there's a large incentive to leave it out of the built jar, so there's large incentive to keep the coupling loose.
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

A facet holder is anything with a bag of related facets. An "item" might have an associated lang entry, creative tab, and crafting recipe, for example, so it makes sense as a facet holder.

The purpose of creating specialized facet holders is building a domain-specific languages over facets. The facet for assigning an item model requires a model and an item to assign it to. When you are working within an item's facet holder, you have the item ID available and don't need to manually thread it through.

Importantly:

- There is no restriction on what facets you can add to what holders,
- there is no restriction on how many facets you can add of any type,
- it never matters *which* holder a facet was put in. (it's always safe to slosh facets around between collections)

The domain-specific language for a recipe facet might prefill the recipe ID based off the crafting result's ID, but you can always pick a different ID. Special-cases (like an item with two recipes or models or whatever) do not break the system.

## Implementation

In templates I have a `Tmpl` holder which represents a block/item pair. The block ID is taken as argument and double-brace init idiom is used to execute code within that context. https://codeberg.org/quat/templates-mod/src/commit/d748e7ca0fe27b25e30f81915951d9553433330d/src/dgen/java/io/github/cottonmc/templates/dgen/Dgen.java#L64 .

So i make a bunch of `Tmpl`s.

Then i create a single giant FacetHolder, pour all the facets into it (plus a few more that don't belong to any `Tmpl`) and loop over each facet by type. Sometimes 1 facet = 1 json file, other times i loop over all facets of a type and collect then into a bug array which i write out as a json file.

## Facet types themselves

- Builder style apis, no `final` or constructor parameters
- Serialize themselves to json with this crummy `Ser` interface. (lighter weight compared to like gson, and i don't need deserialization for most types)
- Heavy use of subclassing
- `Downcastable` base class for ergonomic builder types
- `Idable` base class for "anything with an id"
- `@Facet` annotation marks top-level facet classes, just used for facet holders
- `Id` is my own resourcelocation type

## Further work

I am very pleased with the locality.

Templates really only adds one *kind* of thing twenty times, which is probably why I can get away with this. I'll have to wait and see how it works in a larger mod.

I want the source of *truth* to live entirely within the datagen system -- i.e., I want datagen to drive the actual block registration code too. This means double-brace init will have to go, because I initialize a bunch of recipe shit that I have no business calling at runtime. It's just a matter of splitting the double brace init into gentime and runtime methods and calling the appropriate one.

Instead of manually adding all FacetHolders into a list, I could scan my own classpath and look for classes with a certan annotation or a specific naming pattern (ex. looking for classes named `$Gen` means i can nest gen code for a block inside the block's class). I could even datagen *a list of gen classes* and load that at runtime instead of scanning the classpath ;)

- construct the genclass
- call a method like "prepareData" or "prepareRuntime" which takes a context grab-bag as parameter. ex the block facetholder will grab whatever it needs to make its `registerBlock()` function actually make a note to register the block
- call the data or runtime functions
- resolve all the facets. so you go through and (at gen time) write all the files (at run time) register all the blocks

Sketch:

```java
class MyBlock {
  public static final Id ID = MyMod.id("myblock");

  //puts the runtime representation
  //of MyBlock here as soon as it's available
  @Inject
  public static MyBlock inst;

  // block code ...

  static class Gen extends BlockFacetHolder {
    //the zero-arg constructor would grab
    //the block ID automatically from a field
    //called "ID". you could override it

    @Override void data() {
      dropsSelf();
      shapeless().add("minecraft:stick");
    }

    @Override void runtime() {
      registerBlock(...);
      blockEntity(MyBlockEntity.ID);
    }
  }
}
```

And remember that you can do whatever wherever, if you wanted to make a sixteen colors block you could just put loops inside these methods and ignore or reassign the block/item id fields

## Lessons

- It is a lot more fun to use datagen when it's split out from the game and doesn't require waiting 100 years for the game to start.
- Serializing your own json isn't that hard. In particular you don't need to write a deserializer which simplifies things a lot
- Can lead to happy accidents like, well fuck if datagenning this is as easy as loading it at runtime, might as well try and make it loadable through a resourcepack

# Holder-baded registration

Addendum.

There's a vanilla class called `Holder<T>` which pairs together a registry, an ID, and *possibly* an object of type `T` corresponding to that ID. Unbound holders do not contain a T and crash when trying to retrieve it. Bound holders do contain such a T.

In neoforge, many modders use the `DeferredRegister<T>` utility. You pass it a block ID and a block constructor, and in one step it creates an unbound `Holder` for the block, creates a task to construct/register the block at the appropriate time, and binds the holder to the block immediately atter registering it. These holders are then stuck into an easily accessible class where it's easy to grab the block ID throughout the project. (Older versions of forge which predated `Holder` had the same idea.)

The problem is that when you use a `Gen` system, the block constructor call is deep inside your `Gen` code so it can't be colocated with the holder pile. Instead, I propose a holder-first approach to doing your registration: instead of using DeferredRegister to create holders, just create unbound holders, and when you construct and register content, immediately bind them to all relevant holders.

Because an unbound holder doesn't require a block constructor (it doesn't really know *what* it's registering yet), you regain the ability to stick them in convenient places.

Go a step further and make your `register` method take `(Holder, T)` instead of `(Registry, ResourceLocation, T)`. Registration then becomes a problem about "binding holders" instead of a problem about "associating ids with things". Small mindset shift.

In my project i actually created a clone of vanilla holder called `Latch` but only because I don't trust mojang to keep it around. I could experiment with the vanilla class.
