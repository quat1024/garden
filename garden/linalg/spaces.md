*Part of the [linear algebra notes](./index)*

# Vector spaces

A vector space is any mathematical object you can "do linear algebra" to. Specifically, think about the operations involved in Gaussian elimination.

* You can scale rows by a real number.
  * So we need the ability to scale the object by a real number.
  * Multiplying the object by 0 should take it to a zero object. Everything goes to the same zero object when multiplied by 0.
* You can add and subtract rows with each other.
  * So we need the ability to add and subtract these objects.
  * Every object $x$ has an additive inverse $-x$, such that $x + (-x)$ equals the zero object.
* You can perform these operations in any order and you can switch rows at will.
  * So the addition operation needs to be commutative and associative.
  * The scaling needs to distribute over addition in the appropriate fashion.

Here are some examples of vector spaces:

* Real numbers.
  * The addition operation is real number addition.
  * Scaling is real number multiplication.
  * The zero object is the number 0.
* Vectors with $n$ elements. (That's why they're called "vector spaces".)
  * The addition operation is vector addition.
  * Scaling is done by multiplying each element by the scale factor.
  * The zero object is the all-zero vector.
* Matrices with $m$ rows and $n$ columns.
  * The addition is matrix addition.
  * Scaling is also done by multiplying each element by the scale factor.
  * The zero object is the all-zero matrix.
* Polynomials.
  * The addition operation is polynomial addition.
  * Scaling is done by multiplying all the coefficients.
  * The zero object is $f(x) = 0$.
* Functions.
  * The addition operation is function addition.
  * Scaling is done by multiplying the output of the function by the scale factor.
  * The zero object is $f(x) = 0$.

### Subtle distinction

When we talk about matrices as a vector space, we only worry about matrix-matrix addition and matrix-scalar scaling. We don't concern ourseles with matrix multiplication. Matrix multiplication *is* a useful operation, it just doesn't correspond to any vector space concepts.

Similarly for polynomials/function spaces. When we talk about functions as a vector space, we are just concerning ourselves with the ability to add and scale functions. The act of *applying* the function to some particular $x$ doesn't correspond to any vector space concepts. That's why we can *talk about* functions like $f(x) = x^2 + 6$ as points in the space of polynomials, and we can perform linear algebra with the polynomials, even though $f$ is not a "linear function".

## Subspaces

A sub*space* is a sub*set* of a vector space that is closed under the vector space operations (addition and scaling). To check that a sub*set* is a sub*space*:

* check that the zero element is in the subset,
* check that adding two elements in the subset results in a third element also in the subset,
* check that scaling an element of the subset by any real number results in an element also in the subset.

Intuition: There's no way out of Flatland. Given the elements of the subspace as a construction kit, there is no way to scale and add them in such a way that you *leave* the subspace. 

All vector spaces are subspaces of themselves.

Some texts use "must be nonempty" instead of "must contain the zero element". These are equivalent definitions; because a subspace must be closed under scaling, and you can always scale an element by 0, a subspace must contain the zero element.

Examples.

* The real line is a subspace of the real plane. The line $y=x$ is also subspace of the real plane, and so is $y=-x$, and $y=1000x$. (All of these lines cross through the origin.)
* Symmetric $n × n$ matrices are a subspace of all $n × n$ matrices. There is no way to add, subtract, and scale symmetric matrices into a nonsymmetric matrix.
* "Even" polynomials are a subspace of all polynomials. There is no way to add, subtract, and scale even-degree polynomials into odd-degree polynomials.
* Polynomials of degree less-than-5 are a subspace of all polynomials. There is no way to add, subtract, and scale polynomials in such a way that increases their degree. (Remember that scaling is by real numbers; you can't "scale by x".)

Counterexamples.

* Even integers are not a subspace of the real numbers. If you scale $5$ by $2.1$ then you have something that is not an integer.
* The $x$ and $y$ axes, considered together, are not a subspace of the real plane. If you add one vector from the $x$ axis and another vector from the $y$ axis, you can make points not on either axis and leave the subset.
* Odd polynomials are not a subspace of all polynomials. The zero element, $f(x) = 0$, is not an odd polynomial.

### The "smallest subspace" containing something

Consider the real plane and think about the point $(1, 2)$. Remember that a subspace is closed under scaling. So if you include $(1, 2)$ you must also include $(2, 4)$, and $(0.1, 0.2)$, and $(-1, -2)$, and $(1.001, 2.002)$. In fact, just by knowing that the subspace contains $(1, 2)$, you can conclude that it *also* needs to include the whole line $y=2x$.

Now consider adding $(1, 3)$. You now have two vectors which aren't colinear, and you can start scaling and adding them to trace out the entire plane. So any subspace of the real plane containing $(1, 2)$ and $(1, 3)$ is the whole plane.

### The zero subspace

Consider any vector space $V$, and think about the subset containing *only* the zero object of $V$.

* It contains the zero element (by construction),
* it is closed under addition (because $0+0=0$),
* it is closed under scaling (because $a0 = 0$ for all real numbers $a$).

So this subset is indeed a subspace. This is called the *zero subspace* of $V$.

## Basis

A minimal set of vectors which can be used to span an entire space.

For example, the two vectors $(1, 0)$ and $(0, 1)$ are enough to span the entire real plane.

Todo blah blah

### Dimension

The size of that set.

The dimension of the smallest space containing $(1, 2)$ (aka a line) is 1. Planes are 2. Volumes are 3. Etc. It's like the number of different "directions" or "degrees of freedom" in the space.

The dimension need not be finite. The space of all polynomials has basis $\{1, x, x^2, x^3, x^4, \dots\}$ and it has infinite size.

The basis of the zero subspace is an empty set (instead of a set containing just the zero element), so the dimension of the zero subspace is 0.

# Linear maps

A function from one vector space to another that preseves the structure of the vector space. Category theorists would call this a "morphism" I think?

* The function preserves addition: $F(a+b) = F(a)+F(b)$
* The function preserves scaling: $F(ka) = kF(a)$
  * As a consequence, the zero element is sent to the zero element: $F(0) = 0$ (where each use of the symbol $0$ talks about different vector spaces)

Basically a function that "distrbutes" over both vector space operations.

For example, 2x2 matrices can be converted into 4-element vectors by plucking out the four components in some order. This is a linear map because adding and scaling matrices corresponds to adding and scaling the vector, and the zero matrix is sent to the zero vector. (Many vector spaces can be converted to and from $n$-element vectors, for some $n$.)

You can also take 2x2 matrices to a real number by picking the upper-left corner. Or convert matrices to a real number by taking the sum of the elements. These maps "throw away information", but that's fine.

## Linear maps and matrix multiplication

All matrices can be *used* as linear maps where $F(x) = Ax$. Here, $x$ stands for some vector.

Generally when we use a "space" term on a matrix $A$ (like, when we talk about the *span* of $A$, or the *dimension* of $A$) we are talking about the properties of the map $F(x) = Ax$.

## Null space

The set of $x$ where $Ax = 0$. It is remarkable that this is a null *space* and not just a null *set*.

Recall that $F(x) = Ax$ is a linear map and all linear maps leave 0 fixed, so the zero vector is always in the null space. Some matrices don't "squish" space, so the only vector that ends up at zero was the vector already at 0. In these cases, the null space of that matrix is just the zero space.

Other matrix operations squish more points onto zero, and then the null space is larger.

The dimension of the null space is called the "nullity". A matrix with high nullity squishes space a lot, and a matrix with low nullity squishes space a little or not at all.

## Column space / range space

The set of possible values $y$ where $Ax = y$. Again, interesting that this always forms a space, not just a set.

Equivalently, the column space is the span of the matrix's column vectors.

Some matrix operations don't squish space, so the range space is the same as the original space. Other matrix operations squish $x$ into a subspace.

The dimension of the column space is called the "rank". A matrix with high rank "covers" lots of the output space, and a matrix with low rank squishes space a lot.

### "Rank theorem"

If a matrix has $n$ columns, then the nullity of that matrix, plus the rank of that matrix, is $n$.

In other words: A matrix can choose to send some values to 0, shrinking its column space -- but then the null space grows by the same amount. In this sense the null space and the column space are sort of "opposites".

## Row space

The column space is the span of the column vectors, so the row space is the span of the row vectors.

Important things to know:

* Transposing a matrix swaps its row and column spaces. That makes sense.
* Performing row operations *doesn't change the row space* (!). That's interesting!

Therefore if you transpose a matrix, do row operations, and transpose it back, you preserve the column space. This is a great way to actually *state* the column space of a matrix in a simple form: transpose, reduce, transpose.

Maybe you wonder why we have "row operations" and not "column operations". This is why: they are redundant.