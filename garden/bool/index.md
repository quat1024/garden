# Boolean algebra

I'm learning this in an engineering class so this is might be an "engineer's perspective" on boolean algebra.

## Truth value

True or false.

True is represented by the number 1, and false by the number 0.

## And

`xy` is true when `x` is true and `y` is also true.

This is like multiplication. 0 times anything is 0, so the only way to multiply two booleans and get 1 is if they are both one. This motivates why `AND` is written like multiplication: `xyz`. The unit for AND is `1`; anding anything with 1 will leave it unchanged.

This is also similar to the "min" function that returns the smallest number.

In logic gates diagrams, "and" is represented with a straight back.

## Or

`x + y` is true when `x` is true or `y` is true. (Or both.)

This is like saturating addition (where instead of overflowing `1 + 1` to `2`, we just cap it to 1.) Under saturating addition, 1 plus anything is 1, so the only way to add two booleans and get 0 is if they are both 0 to begin with. This motivates why `OR` is written like addition: `x+y+z`. The unit for OR is `0`, ORing anything with 0 will leave it unchanged.

This is also similar to the "max" function that returns the largest number.

In logic gate diagrams, "or" is represented with a curved back.

## Not

`x'` denotes a value that is 0 when x is 1, and 1 when x is 0. It is the negation of `x`.

The notation `x'` is pronounced "x not", but in my head I pronounce it "x tick".

In logic gate diagrams, "not" is represented with a triangle pointing at a small circle.

## Logical equivalences

Two functions are *logically equivalent* if they output the same truth values for all possible inputs.

Here are some handy equivalences which can be used to simplify expressions:

### Units

The unit for "and" is 1. `1x = x`. The unit for "or" is 0. `x + 0 = x`.

Applying the wrong unit results in a constant function. `0x = 0`, and `x + 1 = 1`.

### Commutativity and associativity

Both addition and multiplication are commutative and associative.

### Idempotency

`X + X = X` and `XX = X`. Easy to see with the truth tables.

### Distributivity

Addition and multiplication both distribute over each other.

* Multiplication over addition: `X(Y+Z) = XY + XZ`
* Addition over multiplication: `X+YZ = (X+Y)(X+Z)`

The usual "FOIL" rules for multiplying polynomials also work.

### Double-negation elimination (DNE)

`X'' = X`. Don't tell this to certain mathematicians.

### Excluded middle (LEM)

`X + X' = 1`. Everything is either true or false.

`XX' = 0`. Nothing is both true and false.

### DeMorgan's

As a consequence of DNE and LEM, `(X+Y)' = X'Y'` and `(XY)' = X' + Y'`. This helps you turn (negated) products into sums and (negated) sums into products.

### Unity and absorption

Unity: `XY + XY' = X`, and `(X+Y)(X+Y') = X`. The same expression ends up evaluated regardless of the value of Y.

Absorption: `X + XY = X` and `X(X + Y) = X`. The value of Y gets flooded out by X.

### Elimination

`X + X'Y = X + Y`. This works because if the `X` term of `X + X'Y` is *not* needed to make the expression true, we can assume `X` is false and therefore `X'` is true.

Same for `X(X'+Y) = XY`.

### Consensus

`XY + X'Z + YZ = XY + X'Z`.

This is a bit subtle:

* Look at `XY + X'Z + YZ`.
* If `X` is true, this evaluates to `Y + YZ` which simplifies to `Y` (absorption).
* If `X` is false, this evaluates to `Z + YZ` which simplifies to `Z` (absorption).
* Either way the expression will be true when `YZ` is true, so we don't need that term in the disjunction.

## Duality

The *dual* of an expression is that expression with all the sums and products exchanged. The dual of `(AB)+C` is `(A+B)C`.

Taking the dual does not, in general, preserve the truth value. However, if `A` and `B` are logically equivalent (and do not include literal 1 or 0), the dual of `A` *is logically equivalent to the dual of `B`*.

(That's how my prof defines it. Other sources say the dual is swapping sums and products *and also negating every term*, which always flips the truth value. It's like a generalized DeMorgan's law.)

## Literals

The term "literal" refers to "an input variable or its negation". If we're working in a context where `A`, `B`, and `C` are inputs to our system, we have six literals at our disposal: `A`, `B`, `C`, `A'`, `B'`, `C'`.

This corresponds to digital circuitry: `A`, `B`, and `C` are the input wires, and `A'`, `B'`, and `C'` correspond to the negations of those wires -- I don't  know jack about circuitry, but I think it's easy to negate an input with some kind of resistor or transistor.

## Minterm

A minterm is a product of literals. `ABC`, `AB'C`, and `A'B'C'` are examples of minterms.

## Maxterm

A maxterm is a sum of literals. `A+B+C`, `A+B'+C`, and `A'+B'+C'` are examples of maxterms.

## Sum-of-products and product-of-sums

If an expression is a sum of minterms, it is in "sum of products" form. Looks like `(ABC)+(AB'C)+(A'B'C')`.

If you have a truth table, you can easily write the expression in "sum of products" form.

- Say you have an expression in 3 variables `A`, `B`, `C` with 8 rows in the truth table.
- For each `1` in the truth table, write the corresponding minterm. So if `A = 1`, `B = 0`, and `C = 1` leads to a true value, write `AB'C`.
- Sum all the minterms. Now the expression is in sum-of-products form.
- Each minterm is "sensitive" to one row in the truth table. Other minterms will evaluate to 0, the additive unit.
  - If the minterm evaluates to 0, it blends-in with the other minterms and the expression evaluates to 0.
  - If the minterm evaluates to 1, it pulls up the rest of the expression and makes it evaluate to 1.

If an expression is a product of maxterms, it is in "product of sums" form. Looks like `(A'+B'+C')(A'+B+C')(ABC)`.

If you have a truth table, you can easily write the expression in "product of sums" form.

- Say you have an expression in 3 variables `A`, `B`, `C` with 8 rows in the truth table.
- For each `0` in the truth table, write the corresponding maxterm. So if `A = 1`, `B = 0`, and `C = 1` leads to a *false* value, write `A' + B + C'`.
  - Each term is inverted - we want an expression that evaluates to 0, just like the row in the truth table.
- Take the product of all the minterms. Now the expression is in product-of-sums form.
- Each maxterm is "sensitive" to one row in the truth table. Other maxterms will evaluate to 1, the multiplicative unit.
  - If the maxterm evaluates to 1, it blends-in with the other maxterms and the expression evaluates to 1.
  - If the maxterm evaluates to 0, it pulls down the rest of the expression and makes it evaluate to 0.
  
Expressions in zero or one literals are also in SOP/POS forms. `0`, `1`, `A`, and `A'` are in both sum-of-products and product-of-sums.

## Minterm and maxterm expressions.

- Write in sum-of-products form.
- If there are terms that don't use all the variables, add redundant terms using every combination of the other variables, so that all terms use all variables. For example, if there are variables `a, b, c, d` and one of the sum-of-products terms is `ab`, expand it into `abcd + abcd' + abc'd + abc'd'`.
- Combine like terms again (if you need to)
- Now you have the minterm expansion.

Dually for the maxterm expansion.

## Minterm and maxterm numbers

* Write the literals of the minterm in order.
* Write a 0 for negated literals and a 1 for non-negated literals.
* Read it like a binary number.

`A'BCD'` -> `0110` -> minterm 6. If you write the truth table in the standard way this corresponds to row 6 of the table (when rows are ZERO indexed)

Writing maxterms is the same but put a 0 for *non*negated literals and 1 for negated literals!

`A+B'+C'+D` -> `0110` -> maxterm 6.

For all numbers X:
* Take minterm X.
* Negate it.
* Simplify with DeMorgan's law.
* Now you have maxterm X.
* Negate it again.
* Simplify with DeMorgan's other law.
* Now you have minterm X again.

aka, minterm X and maxterm X are duals of each other (where "dual" involves negating all literals)

## Finding the negation of a minterm expansion

* List all the minterms of F.
* Write all the other minterms that don't correspond to those numbers. For example, if `F(A,B,C)` has minterms `m(0, 3, 4)`, write `m(1, 2, 5, 6, 7)`.
* Now you have an expression equal to `F(A,B,C)'`.

Dually for negating maxterm expansions.

You can also simply negate the minterm expansion and push the negation through DeMorgan's laws, but then you'll have a maxterm expansion instead :) (And dually.)

## Converting minterm expansions to maxterm expansions

* List all the minterms of F.
* Write all the other *max*terms that *don't* correspond to those numbers. For example, if `F(A,B,C)` has minterms `m(0, 3, 4)`, write `M(1, 2, 5, 6, 7)`.
* Now you have an expression *equal* to `F(A, B, C)` but written with maxterms instead of minterms.

Dually for maxterm -> minterm expansions.

## Minimal sum-of-products/product-of-sums

Just because an expression is in SOP/POS form doesn't mean it's as simple as possible. For example, it's possible to simplify `(ABC)+(A'BC)` to just `BC` because the value of A doesn't matter (unity).

## Sidenote: Why bother?

* In electrical circuits, it's easy to negate inputs.
* It's also easy to build OR gates and it's not too difficult to build AND gates.
* "Sum of products form" corresponds to a handful of AND gates (one per minterm) and a big OR gate at the end. "Product of sums form" corresponds to handful  of OR gates (one per maxterm) and a big AND gate at the end.
* Every Boolean  expression can be written as sums-of-products or  products-of-sums where the only negations you need are in the inputs. Thus, it's  possible to realize any Boolean function with these tools.
* Simplifying the expression first means you need fewer gates, which will be more efficient!
