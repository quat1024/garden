# "transformation of structure-shy programs with application to xpath queries and strategic functions" by alcino cunha, joost visser

https://www.sciencedirect.com/science/article/pii/S0167642310000146 (open
access)

## what does structure-shy mean anyway

"a structure shy program specifies type-specific behavior for a selected set of
data constructors; for the remaining structure, generic behavior is defined"
(slight paraphrase). examples they mention are "adaptive programming",
"strategic programming" (several citations for it), polytypic/type-indexed
programming, and several domain-specific XML programming languages

what are the problems?

- the performance is bogged down in runtime type checks
- typically, optimization involves making them less structure-shy

so this paper is about a method to transform structure-shy programs (into what?)
using concepts from typed strategic programming + some XML programming concepts
and methods from _pointfree functional programming_. intimidating term!

## XPath

this is a domain specific language for plucking things out of an XML file. it's
kind of like a CSS selector for your xml documents. this topic goes pretty deep,
and the paper does sorta assume knowledge of it

for example the xpath query `//movie/director` selects all `director`s which are
children of `movie`s that appear at _any_ depth in the document. but if we have
an XML schema that declares `movie` will only ever appear under `imdb` and
`imdb` is the root of the document, then rewriting the query to
`imdb/movie/director` will return the same results but _without_ requiring a
recurse-into-everything search necessitated by `//`.

`//movie/director` is structure-shy because it doesn't specify everything
between the root and `movie` - and in case the schema is modified so that
`movie`s appear elsewhere in the document, we probably don't want to hardcode
the `imdb`.

additionally, if `director` can only ever appear under `movie`, then we can make
the query _more_ shy by rewriting to `//director`, with the same sort of
generalization benefits if `director`s are lated added elsewhere in the document

## context for strategic functional programming

- first implemented in Stratego `[38]` which was typeless
- "the Strafunski system" implemented it in Haskell with strongly typed
  combinators `[28, 29]`
- generalized into "Scrap Your Boilerplate" `[25]`
  - known for poor runtime performance
- (this paper) "our own, based on explicit type parameterization and GADTs"

in this paper they just use a few combinators from _The Essence_ (a previous
paper)

- nop (id)
- `>` (strategy composition)
- `mapT` (map over children)
- `mkT_a` (applies only if the type is correct)
- `apT_a` (applies a generic transformation to a specific type)

for modelling results they have empty (empty result), union (union of results),
mapQ (fold over children), `mkQ_a` and `apQ_a` which are similar to the
previous, i guess they're type specific...

"the result of a query is assumed to be a monoid" and its zero/plus operators
are used to combine results from multiple children when required (like in
`mapQ`)

we see these friends again

```
everywhere :: T → T
everywhere f = f > mapT (everywhere f) -- where > is that strategy composition operator

everything :: Q R → Q R
everything f = f ∪ mapQ (everything f)
```

alright so im thinking "everywhere" is useful for converting one tree into
another, and "everything" is useful for querying the tree and summarizing it in
some way

and the motivating example is exactly the same as in XPath. this pseudocode
function counts up the total length of all reviews

```
count = everything (mkQ_{Review} size)
  where
    size (Review r) = length r
```

where mkQ_{Review} indicates a query for the type `Review` and `Review` has a
field containing the text of a review. the _summation_ happens since `length r`
is a number, which is a monoid with a 0 element and combined by addition

it's cute, but imagine a naive implementation that iterates through the entire
movie database in `everything`. and again the program knows more, because
`Review`s only occur under `Movie` and `Movie` only occurs under `Imdb`. this
function would do the same thing

```
count = sum . map (sum . map size . reviews) . movies

-- or, less pointfree (lean syntax for the function idk)
-- note that "movies" and "reviews" are both accessors that return lists of stuff
count imdb = sum . map (fun movie => sum . map size . (movie reviews)) . (imdb movies)
```

## 3. point free functional programming

_why_ bother with pointfree programs? i guess it has a sortof Forth-like
quality; if you can't put bound variables wherever you want in a function, there
are _fewer functions_ and they end up being built from smaller building blocks,
which you can then stretch and deform with a bunch of meaning-preserving laws
and rewrite rules. they compare this to "fourier transforms"; pointfree programs
and pointed programs are bizarro mirror worlds of each other, sometimes
transforming between them is useful

the simplest combinators are `id` (identity) and `.` (function composition)

some functions for working with pairs - the familiar projections `fst` and
`snd`, then to build pairs we've got "split" which takes `A->B` and `A->C` and
constructs a pair `BxC`, and `X` ("function product") applies two functions, one
on each arm of the product

and then the duals of all these for working with sums. left and right injections
turn an `A` or a `B` into an `A+B`, the "either" combinator takes two functions
`A->C` and `B->C` and eliminates `A+B` into `C` by calling the appropriate
function, and the "function sum" applies one of two functions just like how the
function product applies both

and that's really all you need, right? user-defined structures and enums are
representable as sums and products after all

- they talk of a "functor" (not sure if it's related to the other definition of
  the word functor) which takes a user-defined type into its sum-of-products
  representation
- two functions "in" and "out"; "in" goes from the functor to the real type, and
  "out" goes from the real type to the functor. you can think of 'out' as
  "taking apart" a type into this form we can play with pointfree combinators on
- a type of function called a "congruence function" which first applies `out`,
  then does something, then applies `in`

other functions which show up:

- lists show up a lot so they define `map`/`filter` with the usual definitions,
  `wrap` which lifts a single item into a list
- functions over any monoid: `zero` (zero element of monoid as a const function
  `_ -> A`), `plus` (monoidal plus), `fold` (crunch a list into one element with
  `zero` and `plus`)
  - bool is a monoid where `zero` is false and `plus` is logical or
- `cond` (pointfree if then else)
- `true` (`_ -> bool` ignoring arugment)

it's pretty common in pointfree world to use const functions so that's why true
is `_ -> bool` instead of just a constant.

## 4. algebraic laws of structure shy programs

theres some simplification rules for strategic/structure shy programs (for
example if you compose anything with the `nop` strategy you can remove it) but
there aren't toooo many

it's more fun when you start combining strategy application with the pointfree
world!!!

for example our friend `apT_t` applies a generic strategy to a specific type.
you can push it down through strategy composition (apt_a (f . g) => (apt_a f) .
(apt_a g)) and push it down through certain other types of structure until it
either reaches a `mkT_a f` (in which case they annhilate and just leave an `f`)
or an `mkT_b f` (in which case it turns into `id`, since it's a strategy applied
to the wrong type)

## 5. encoding this in haskell

There's two tricks:

- "reifying" types so they can be matched over
- "reifying" the pointfree functions so they can similarly be disassembled and
  reassembled

this kind of type

```haskell
data Type a where
  Int    :: Type Int
  Bool   :: Type Bool
  String :: Type String
  -- ... other concrete types ...
  
  Any    :: Type ⋆
  
  List   :: Type a -> Type [a]
  Prod   :: Type a -> Type b -> Type (a, b)
  -- ... other type functions of interest ...
```

⋆ is this wacky thing useful for encoding extra types

> The universal node type will be encoded in Haskell using dynamic values. A
> dynamic value can be encoded as a value paired with the representation of its
> type:
>
> ```
> data ⋆ where Any :: Type a → a → ⋆
> ```
>
> Function `mkAny` can be defined as follows:
>
> ```
> mkAny :: Type a → a → ⋆
> mkAny ⋆ x = x
> mkAny a x = Any a x
> ```

then we define a typeclass `Typeable a` with a function `typeof` that converts
an `a` into this value-level description of the type. (Think "serde knowing how
to disassemble your type into its representation")

They add a further `Data :: String -> EP a b -> Type b -> Type a` constructor to
`Type`, where `EP` is a pair of functions `to :: a -> b` and `from :: b -> a`.
The string is just a label, and the type `b` is expected to be the
sum-of-products representation of `a`.

(Ok, I guess this shows that the "functor" is not the FP definition of functor
and it's just a mathematical trick, because you implement the "functor" when you
implement `to` and `from`.)

There's a similar encoding for the various pointfree functions used in the
scheme, containing both the "regular" ones and the strategy-level ones. This
datatype is just called `F` for brevity, don't get confused.

Additional abbreviations: `T` is `forall a. Type a -> a -> a`, and `Q r` is
`forall a. Type a -> a -> r`, the types of traversals(term?) and queries
respectively

## 5.3, rewrite rules

The rewrite engine is backed by this monad

`type RewriteM = RWST Location [ (String, String) ] ⋆ Maybe`

where `RWST` is a monad transformer stack combining `ReaderT`, `WriterT`, and
`StateT`.

- `Location` is the thing being read; it encodes the path to the current
  subexpression
- `[ (String, String) ]` is the thing being written; it is a log of applied
  rules
- `⋆` is the state; "the type o f the state varies according to input
  expression"
- `Maybe` is the underlying monad. They say any `MonadPlus` will do:
  - Rewrite rules may fail, so that's `mzero`
  - Maybe's `mplus` is a left biased choice, fancy way of saying `mplus a b`
    picks `a` if `a` is Some and `b` otherwise

the type o f functions is this

`type Rule = forall f. Type f -> F f -> RewriteM (F f)`

here, `f` must be a function type, and since an `F f` is provided, you can tell
what kind of function it is. (they note in the next section that "type `Rule` is
basically a restriction of type `T` to pointfree expressions")

then you basically write all the rewrite rules as functions with that shape.

- you can use monadic `return` to do a simple rewrite
- you can use the `success` function to poke a message into the writer monad

## 5.4 rewrite systems

let's organize these into a full term rewriting system. with - what else -
strategic programming combinators `:)`

they introduce the nop, composition, choice, all, and one combinators for
rules - they're a little different since it's monadic, and since the monad has a
notion of failure that's why `choice` and `one` and friends can be implemented

extra combinators built on these are `many` (applies a rule until it fails),
`once` (applies a rule somewhere inside an expression but we don't care where),
and `innermost` (which "performs exhaustive rewrite rule application", mapping a
rewrite rule recursively on all children)

so at that point it's basically, "well which rewrite rules do you choose". they
just run through the table of rules and apply them all in order

### later bits of 5.4

talking about increasing the shyness of programs by running a different set of
generalizing rules which are not valid in all cases. at each step they try and
check that the type did not veer too far off course.

## 6. results

you do kind of get a mess because everything is still represented using that
sums-of-products representation, and of course it's pointfree. but the results
are as expected:

- rewriting a strategy applied to the wrong type leaves `id`
- rewriting a strategy applied to the correct type just leaves the body of the
  strategy
- rewriting a strategy applied to a type _containing_ the strategy's type inside
  leaves to a messy pointfree sums-and-products function, but it _does_ directly
  drill into the correct spots in the outer type and apply the strategy to the
  correct spots in the inner type

they have a look at the writer which logs the applied rules for an xpath
example, specializing `//director` onto the imdb schema to create
`imdb/movie/director`. of the 1177 "non-trivial" rules were applied, 288 were
for turning the expression into a gigantic pointfree representation, and
optimizing it into the tiny laser-targeted expresssion took 889 more rule
applications

## 7. application

XPTO xpath compiler

- do the techniques described in this paper to make an optimized pointfree xpath
- serialize it to haskell code
- compile it with ghc
  - this eliminates the overhead of needing to write an interpreter for the IR

two-level transformations

- dealing with "coupled transformations", i.e. changing an API and also changing
  all the consumers
- are my structureshy programs still valid under the new schema? or how do i
  change them?

## 8. related work

i thought "specialization to recursive datatypes" was interesting, basically
`everywhere` and `everything` get defined in terms of a fold or paramorphism or
something instead of a simple recursive function, now you can make rewrite rules
that incude these functions

## takeaways

A "structure shy program" is a program that deals with a small piece of a larger
data structure, while leaving the task of actually _finding_ those small pieces
to higher-level combinators that know how to search through the type.

Pointfree programming is (more or less) a style of functional programming where
all of the function arguments appear at the end of the function, instead of
being interspersed throughout it. Many functional languages then allow you to
omit the argument names entirely (making your program even more confusing)

People bother with pointfree programming because it enables easier methods of
reasoning about programs. It has a sort of Forth-like quality. Because there are
so few places to put variables, there are only a small number of functions in
the first place, so it's possible to create a collection of rewrite rules that
cover all the meaningful ways you can piece these functions together.

In order to do this kind of term-rewriting, you can't just write your program
directly in the pointfree style; you need to go "one step removed" and write
your program in a datatype corresponding to a pointfree program. This allows
other Haskell code to reflect on the functions contained within. It's not all
bad, because you can use the same rewriting engine to go from a representation
of a structure-shy program into a representation of the corresponding pointfree
program.

And of course structure-shy programming is a good way to write a term rewriter,
so this term rewriter was implemented as a structure shy program.

## further things to do

i want to fully understand that thing on page 521 (the definition of `bigTitle`)

I don't understand the purpose of ⋆ on page 526 yet
