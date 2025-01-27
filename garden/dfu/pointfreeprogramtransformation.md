# "point free program transformation" by alcino cunha & jorge sousa pinto

https://repositorium.sdum.uminho.pt/bitstream/1822/842/1/PUReTR040203.pdf (not
open access but this link worked when i tried it)

## 2.1 basic combinators and functions

this is a difficult paper and pretty dense on category theory terms

### functor (in the category theoretical sense)

mapping between categories.

in our context: it's something that maps types to types, and maps functions to functions.

Laws:

- `functor-COMPOSE`: `F(f . g) = (F f) . (F g)`
- `functor-ID`: `F id` = `id`
- (You'll note this is also the rules for functors in programming languages, so maybe these definitions aren't so dissimilar after all.)

### bifunctor

mapping from a pair of categories to a category.

in our context: it's something that maps a pair of types to one type, and a pair of functions to one function.

- Here infix notation is used. The bifunctor would go where the `*` is.
- If `f` has type `A -> C` and `g` has type `C ->  D` then
  - `f * g` has type `(A * B) -> (C * D)`
- `bifunctor-COMPOSE`: `(f . g) * (h . k) = (f * h) . (g * k)`
- `bifunctor-ID` : `id * id = id`

#### lifting a bifunctor

...

### products

Pair type. Comes with two "projection" functions (denoted with the pi symbol) and "split", written `<f, g> x`, that creates a pair `(f x, g x)`.

You can turn a pair of functions into a function over pairs. (Two functions into one -> that's a bifunctor).

### sums ("coproducts")

Writes them as "separated sums" and notates them as ordered pairs where (0, a) is the left and (1, b) is the right.

This paper also adds Bottom into the list of possible elemnets for a sum.

We have two "injections" (making the sum by providing the left or right item) and an "either" function, written `[f, g] x`, that applies whichever of `f` or `g` is relevant to the sum.

You can turn a sum of functions into a function over sums, so again it's a functor.

### functions ("exponentials")

yeah it's getting dense on the math terms. `B^A` is all functions from A to B.

We have the "apply" function (`ap f x = f x`) and the "curry" function (`curry f x y = f (x, y)`) which seems backwards that looks more like an uncurry function

functions are themselves a functor, somehow

### unit

Written as 1, its unique element also written as 1.

### constant functions

Function that always returns the same thing, written with an underline in this text. Everything is isomorphic to a constant function returning that thing. Generally the unit type is used as the argument to this function.

If you do any function, and then compose a constant function, you can ignore the first function ("fusion property").

### guard combinator

i am getting sleepy i dont know what this does

# takeaways

useful to represent constant functions specially in your reflections over functions because of some nice fusion properties wrt function composition

# next steps

**COME BACK TO THIS PAPER i am tired**

this paper *also* cites John Backus's "Can programming be liberated from the von
Neumann style? A functional style and its algebra of programs.", from 1978,
sounds like a foundational paper.

"many introductory texts to this \[pointfree\] style of programming": `[26, 7, 16]`.
