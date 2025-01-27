# The big picture

## Strategic programming

Generalized "visiting"

## Structure shy programming

Programming in a pattern-match style. You have a tree of data, and you pattern-match against it.

To borrow an example from the paper, a program that lists all movies in an XML file by recursively searching for all `<Movie>` tags and looking at their `<title>` child, is a structure shy program.

If you have a particular schema in mind, however, you can optimize a structure shy program by using information from the schema. If you know there's no need to search inside the `<Reviews>` tag to find `<Movie>`s, and you know that `<Movie>` tags cannot appear inside themselves, you can save a lot of time and potentially avoid a full recursive search.

Why bother programming in the structure-shy way, when optimizing these programs is so easy?

* Developer ease. It's easy to think "find all the `<Review>`s, I don't care how".
* Loose coupling.
  * Program functions even if the entire document is wrapped in a new `<Root>` node or whatever.
  * Program functions even on subtrees of the original document.
* Extensibility. If `<Review>`s begin appearing in a new location,  you'll pick up on them. (Might be good or bad.)

In a functional programming setting, we might classify structure-shy programs into two categories:

* transformations, which pull apart one tree of data and build another tree
  * for example, producing a new movie database where all reviews have been trimmed to 100 characters
* queries, which make some kind of summary of the data
  * for example, finding the total length of all reviews

These correspond to structure-preserving "maps" and structure-flattening "folds"; I think the distinction is important in FP.

## Optics

* Lenses are a useful model for programming with very nested immutable data structures
* Lenses allow you to factor out the whole "take the structure apart, work on the small part, put the structure back together" dance
* "Optics" are a generalization of lenses, helping you talk about sum types, perform traversals, etc
* There are several ways of constructing optics
  * The "concrete" form, as a family of two functions
  * van Laarhoven form, encoding a lens as an operation between two functions leveraging a functor
  * Profunctor optics, generalizing this to arbitrary profunctors

### Concrete form

In the concrete representation, a lens is a pair of two functions, for example

```lean
structure Lens' (whole part : Type) where
  view: whole → part
  update: whole → part → whole
```

Then we can lift a function from parts → parts into a function from wholes → wholes, like this:

```lean
def lens'Map {whole part : Type} (lens: Lens' whole part) (w : whole) (f : part → part) : whole :=
  (lens.view w) |> f |> (lens.update w ·)
```

* First we view through the lens, going from the whole → part
* Apply `f` to the part
* Build the new whole, out of the previous whole and the new part

```lean
-- assume fstLens' is a Lens' onto the first element of a pair

def coolPair := ("banana", 5)
##eval lens'Map fstLens' coolPair String.toUpper -- ("BANANA", 5)
```

#### Benefits

Easy to explain, easy to write.

#### Drawbacks

These are function pairs, not functions. Composing lenses is hard; you need a special function that takes two lenses and returns a third lens representing their composition.

They don't play nice with other optics like prisms.

### var Laarhoven but ignoring the functors

```lean
abbrev CrapLens (whole part: Type) := (part → part) → (whole → whole)
```

If I'm a `CrapLens whole part`, I can take *any* function from parts to parts and turn it into a function from wholes to wholes. Naturally, you do this the same way `lens'Map` was written:

* disassemble the `whole` into a `part` (which is some operation specific to the two types)
* apply the supplied function to the part
* then reassemble the new part with the old whole (the "inverse" of step 1)

You zoom into a structure, apply the function, then zoom out. A lens.

How else would you write a function with this signature? (Especially if these were type-changing lenses?)

### van Laarhoven

Stick a functor in there. Any old functor. (In Haskell I believe you'd represent this with a forall?)

```lean
abbrev Lens (whole part: Type) [Functor f] := (part → f part) → (whole → f whole)
```

Alright, so this says if I'm a `Lens`, I can take any function from "a part" to "a part in any computational context", and turn it into a function from "a whole" to "a whole in the same computational context".

* disassemble the `whole` into a `part`, same thing you do with a functor-less lens
* apply the supplied function, leaving an `f part`
* `fmap` the reassembly function over the `f part` leading to an `f whole`

Given that we don't have anything like `Applicative` or `Monad`'s `pure`, the only way to "get into the computational context" is to apply the function; then to reassemble into the whole, the only thing we can do is `fmap`. A bit like solving a crossword puzzle.

**Why stick a functor in there?** - Should look into this. I think the answer is: with `CrapLens` we can only write a lens, but the functor in `Lens` provides just enough flexibility to generalize to a few other types of optic.

### Type-changing lenses

Who says a lens has to update things to the same type? For example you could update a `Prod String Nat` into a `Prod Nat Nat` by taking the length of the first element. Why not.

You end up with a lot of type variables floating around but it's not so bad.

```lean
abbrev CrapLens (whole whole' part part': Type)             := (part →   part') → (whole →   whole')
abbrev Lens     (whole whole' part part': Type) [Functor f] := (part → f part') → (whole → f whole')
```

Lenses that take `whole`s to `whole'`s by way of taking `part`s to `part'`s.

### Profunctors, in general

*Roughly speaking*, something that "consumes As and produces Bs". Importantly this "produces" means something more general than "has the type `B` exactly".

A function `A → B` is a profunctor, but so is `A → (B, C)`, and `A → (B, B)`, as well as `A → List B` and `A → Maybe B`, and even `A → F B` for any functor `F`

The actual typeclass is something like

```lean
class Profunctor (p : Type u → Type v → Type w) where
  dimap : {α α' : Type u} → {β β' : Type v} → (α' → α) → (β → β') → (p α β) → (p α' β')
```

Note that the first argument is `(α' → α)` and the second argument is `(β → β')`. This is consistent with the idea that a `p α β` is something that "takes `α`s to `β`s" - the arguments to dimap are the correct way around to be thought of as "pre-" and "post-processors". To turn a `p α β` into a `p α' β'`:

* first you turn the `α'` into the `α` that you understand, with the preprocessor,
* apply your personal transformation,
* then turn the resulting `β` into a `β'` with the postprocessor

Now the laws make sense:

* `dimap id id` uses an empty pre and post processor, so of course it should equal `id`.
* `dimap (f' ∘ f) (g ∘ g') = dimap f g ∘ dimap f' g'` strings two preprocessors and two postprocessors together, of course the result should be equal to applying them one at a time

#### Summary

`Profunctor α β` is a generalization of "function from α to β" where α or β might have additional "context" (say, `α → (β, χ)`) or be in any functor (say, `a → List β`).

### Cartesian profunctors

....


