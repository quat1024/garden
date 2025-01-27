# "the essense of strategic programming" by eelco visser and joost visser

[link to paper](https://www.researchgate.net/publication/2489573_The_Essence_Of_Strategic_Programming_-_An_inquiry_into_trans-paradigmatic_genericity?enrichId=rgreq-74b1a819e08311f073abb7b91a006cc0-XXX&enrichSource=Y292ZXJQYWdlOzI0ODk1NzM7QVM6OTkxMTY5MTQ4Mzk1NjdAMTQwMDY0MjcyMjgyNQ%3D%3D&el=1_x_2&_esc=publicationCoverPdf) (this url might still work idk) (open access)

motivating example; imagine iterating over some fancy recursive structure, like
a programming language AST

> To obtain type-safety, the data must be heterogenous: each kind of tree,
> graph, or document element is assigned a specific type. But when the data
> structure is heterogenous, access to and traversal over its subelements will
> involve dealing with many specific types in specific ways. If no generic
> access or traversal is available, this approach implies lengthy traversal code
> which cannot be reused for differently typed data structures. The most obvious
> way to recover concision and reusability is to abandon type-safety and instead
> to employ homogenous, universal data representations. [...] As we will see,
> this dilemma can be solved with strategic program- ming, because it caters for
> generic access to the subcomponents of het- erogeneously typed data
> structures.

so it's an attempt to have the cake and eat it too. like idk, imagine you wanted
to rename all the variables in java source text. iterate over the tree, if you
see a variable name, rename it... but if you see a class, you need to iterate
over its fields and methods, and if you see a method you need to iterate over
the statements, and if you see a static initializer you need to iterate over the
statements too, and some statements define more than one variable so you need to
iterate into all subexpressions - you can see how the code for _finding_ the
variables in the tree dwarfs the size of the code needed for the business logic

how do they define a strategy?

- generic, but specific. applicable to data of any type, and (i guess when the
  encounter data of the correct type), able to traverse into it
- partial. applying a strategy might not work so there needs to be a =recovery
  mechanism
- control structures
- first-class. pass em as arguments and use "a combinator-style of programming".

## notation to know

`strategy@datum` is how strategy application is notated

`strategy@datum => newdatum` is how they notate what a strategy does

## strategies to know

- "type specialization"
  - take a strategy Pi and apply a type Tau,
  - not sure exactly what it does
  - maybe it acts like Pi on elements of type Tau and like `id` otherwise?
- "adhoc"
  - they call it 'strategy update'
  - take two strategies, the default `s` and the new one `r`
  - result acts like `r` if the type applies, and `s` otherwise
- id
  - does nothing successfully
- fail
  - fails all the time
- semicolon (`a;b`)
  - strategy composition, do the first one then the second one
- if-then-else (`a<b+c`)
  - if `a@t` succeeds, run b afterwards, i.e. `b@(a@t)`
  - otherwise run `c@t`
- all
  - "push the strategy one level down into the input datum"
  - ie if the input datum is a function application, apply the strategy to all
    the functions
  - ie if the input datum is a struct, apply the strategy to all the fields
  - all of the sub-visits must succeed
  - fails if one subpart fails
- one
  - applies the strategy to the first part of the input datum that succeeds
  - fails if every subpart fails

alright, now what can you do with this toolkit

- `choice (s, s')`
  - do `s` and if it fails do `s'`
  - defined like `s<id+s'`
- `not (s)`
  - succeeds when s fails and fails when s succeeds
  - `s<fail+id`
- and so on

some of these use "one" again

they emphasize that these are examples, you could choose a different set of
combinator axioms (you could make "choice" first class if you wanted)

none of these are really type-specific combinators yet

## 3. digression about term rewriting systems

- most interesting term rewriting systems don't terminate to a normal form; you
  might have two cases that simplify to each other, for example
- you might want more control over the rule selection algorithm, so you have a
  function you sprinkle throughout the rewrite rules that implements the
  relevant priority and rule selections
- but now this is sprinked throughout all the code and obscures the rules
- additionally it's hard to reuse the rules in other contexts because they come
  tied with this control-structure baggage

### digression about traversal functions

similar problem of tying rules to strategies

(...)

## 4. functional programming

combinators are familiar to functional programmers, specific recursion schemes
(foldl foldr) are familiar, but totally _generic_ term traversals are tricky

figure 14 (section 4.1) is a diagram of the traversal-noise problem where all
the repetitive recursion strategy stuff dwarfs the actual thing the function is
doing

### what about generalized folds

something about "fold algebras", i guess this is another way of solving this
similar problem

there's some shortcomings; "n fact, updatable fold algebras suffer from the same
problem as the traversal-function approach in term rewriting when only a fixed
set of traversal schemata is considered."

### types

strategies are about the interplay between type-generic and type-specific
worlds, hard to encode very vague and type-generic stuff in the very string
typing of Haskell

the solution is to eschew Haskell types and pass type tokens as parameters to
functions, so you can match on them, i guess? look what they need to mimic a
fraction of our power (dependently typed langugages)

"the somewhat involved encoding is described at length in `[39]`

## 5. java

the natural-ish analog of folds and traverses in Java is the visitor pattern

as an object, when you "accept" a visitor you tour it through the object,
calling its `visitRoot`, `visitChild`, `visitBlahblah` methods

### shortcomings

there is typically just one traversal scheme, it's usually some sort of top-down
visit, cannot choose the order you approach things in

keeping state is quite difficult since you need to smack it in the visitor and
use an mutable variable

"visitors resist composition" - you get the visitor you get

### visitors to strategies 5.5

mentions of "JJ-Traveler" and "JJForester" above

!! hell yeah we got implementations of visitor combinators in old java !!

generic visiting patterns are done by just requiring visitables to number their
children - there's a `getChildCount` method, and `getChild(i)/setChild(i)` pairs
that return `Visitable`s

the TopDown visitor is implemented like `sequence(visitor, new All(this))` where
`this` returns to the exact same TopDown - digression: actually a separate
assignment is used to tie the knot since you can't pass `this` into the
superconstructor. what does that mean. so first you use the passed-in argument
visitor `visitor`, and then you apply `All`, which looks into each subcomponent
of the structure and calls the same `sequecne` visitor (which calls the argument
visitor on all subcomponents, then again recurses into _their_ subcomponents...)

This is a fully type-erased mess, but runtime type information can be used to
implement the "type-specialization" combinator

## 6/7. related work and conclusions

mandatory XLST reference since this is a 2002 paper (it's tricky to implement in
XLST since templates aren't first class) and a notion of backtracking on
failure. a bit on this design pattern in Prolog

### applications

useful table

|                   🦆 | functional programming           | object oriented programming        |
| -------------------: | -------------------------------- | ---------------------------------- |
|               datums | terms of algebraic datatypes     | object structure                   |
|        basic actions | monomorphic monadic function     | visit method                       |
|             strategy | polymorphic monadic function     | generic visitor                    |
| strategy application | function application             | visit method call                  |
|         subcomponent | subterm                          | referenced object                  |
|  type specialization | implicit                         | type cast                          |
|      strategy update | type case                        | runtime type info, dynamic binding |
|                types | rank-2 fanciness                 | subtype polymorphism               |
|           partiality | monads, specifically `MonadPlus` | exceptions                         |

as well as additional columns for term-rewriting systems and logic programming systems

## takeaways

the authors emphasize that "strategic programming" is a design pattern applicable to very diverse worlds of programming

if the visitor pattern has two parts

* visited thing (the shape of structural recursion *and* the data to recurse over)
* visitor (the action to do when structurally recursing)

the strategy pattern further splits this into three parts

* a library of visitor combinators (for building the shape of structural recursion)
* visited thing (the data to recurse over)
* visitor (the action to do when structurally recursing)

so now you can separate "the shape" from "the particular structure you're recursing over". top-down, breadth-first, whatever you want.

and there's a similar analogy for the functional setting. "fold algebras" and (i think they're called) recursion schemes define one way of visiting a structure. with strategies you want to separate that into more pieces. it's a little more challenging to encode because functional languages generally don't rely on runtime type information as much, but it's doable

in the case of DFU specifically i think paying more attention to how strategies are implemented in a functional setting will be a good idea

`[39]` is "R. L¨ammel. First-class Polymorphism With Type Case and Folds over Con-
structor Applications, Jan. 2002. Draft paper."