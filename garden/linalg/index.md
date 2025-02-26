# Linear algebra

Not a lot of notes here yet Tbh -- this is an example of "might as well put them online instead of having them rot on my hard drive".

Book we're using: "Introduction to Linear Algebra", 5th edition, by gilbert strang. I like it.

## properties of matrix operations

* Addition is elementwise, so it inherits commutativity and associativity from addition on real numbers.
* There is a zero matrix, and every matrix $M$ has an additive inverse $-M$ such that $M-M=0$
  
Matrix multiplication:

* Not commutative.
* It's associative, provided the shapes line up.
* Not cancellable; $AB = AC$ doesn't imply $B = C$.
* Distributes over scalar addition.

## Transpose

Flip it diagonally over a sloping-downwards 45° line. Rows become columns. Denoted with a superscript T.

Distributes over addition: $(A+B)^T = A^T + B^T$.

Sorta over multiplication $(AB)^T = B^{T}A^{T}$ - need to switch the order.

"Symmetric" matrices are matrices where $A^T = A$.

If you take two column vectors, transpose the left one, and matrix-multiply them: you end up with the dot product. (Similar to how matrix multiplication is like taking a bunch of dot products.)

## Identity matrix

Has 1s on the diagonal line and 0s everywhere else. The identity for matrix multiplication (like the number `1` for scalar multiplication)

# Linear independence

Formal definition: If the only solution to $a_1v_1 + a_2v_2 + a_3v_3 + ... + a_nv_n = 0$ is $a_1 = a_2 = a_3 = \cdots = a_n = 0$, where $a_1, a_2, a_3$ are coefficients and $v_1, v_2, v_3$ are the columns of the matrix.

Pracitcal definition: Set the vectors up as columns in a matrix, one column per vector. Augment with a column of zeroes. Row-reduce. If the matrix is reducible to the identity matrix, the vectors are linearly independent. Otherwise (if there is a row or column of zeroes), the vectors are linearly dependent.

In other words: A set of vectors is linearly independent if there is no way to combine some of them to make the zero vector (apart from scaling every vector to 0). More handwavingly: ...if there is no way to combine some vectors and equal a different one.

## Singular matrices

A matrix $M$ is "nonsingular" if the only solution to $Mx = 0$ is $x = 0$, which is the case only if it is linearly independent.

Only nonsingular matrices have multiplicative inverses. All matrices with multiplicative inverses are nonsingul

# Inverses

[Here](./inverse)

## "Ill conditioned"

Matrices $A$ where small changes to $b$ in $Ax=b$ can result in large changes to $x$. This text doesn't define "small" and "large"; illconditionedness is a domain-specific classification, something that's useful to know if you're solving linear systems for some real-world application. The term comes from numerical analysis.

You can spot ill-conditioned matrices because the inverse has big numbers when the regular matrix has small numbers. Book mentions the "Hilbert matrix", which is composed entirely of small unit fractions (half, third, fourth etc), but its inverse contains numbers as large as 4 million in the 6x6 case. (And, oddly enough, are all integers.)

# Vectors

[Over here](./vectors)

# Vector spaces

A vector space is any mathematical object you can "do linear algebra" to. Specifically, think about the operations involved in Gaussian elimination.

* You can scale rows by a real number. So we need the ability to scale the object by a real number. Scaling the object to 0 should take it to a zero object.
* You can add and subtract rows with each other. So we need the ability to add and subtract these objects, and they need an additive inverse.
* You can perform these operations in any order and you can switch rows at will. So the addition needs to be commutative and associative, and the scaling need to distribute over addition in the usual way.

## Subspaces

A sub*space* is a sub*set* of a vector space that is closed under the vector space operations (addition and scaling). To check that a sub*set* is a sub*space*:

* check that the zero element is in the subset,
* check that adding two elements in the subset results in a third element also in the subset,
* check that scaling an element of the subset by any real number results in an element also in the subset.

Intuition: Given the elements of the subspace, there is no way to scale and add them in such a way that you *leave* the subspace. There's no way out of Flatland.

All vector spaces are subspaces of themselves.

Some texts use "must be nonempty" instead of "must contain the zero element". These are equivalent definitions; because a subspace must be closed under scaling, and you can always scale an element by 0, a subspace must contain the zero element.

For example: the real line is a subspace of the real plane. The line $y=x$ is a subspace of the real plane, and so is $y=-x$, and $y=1000x$. All of these lines cross through the middle.

### The "smallest subspace" containing something

Consider the real plane and think about the point $(1, 2)$. Remember that a subspace is closed under scaling. So if you include $(1, 2)$ you must also include $(2, 4)$, and $(0.1, 0.2)$, and $(-1, -2)$, and $(1.001, 2.002)$. In fact, just by knowing that the subspace contains $(1, 2)$, you can conclude that it *also* needs to include the whole line $y=2x$.

Now consider adding $(1, 3)$. You now have two vectors which aren't colinear, and you can start scaling and adding them to trace out the entire plane. So any subspace of the real plane containing $(1, 2)$ and $(1, 3)$ is the whole plane.

### The zero subspace

Consider the subset containing only the element $0$.

* It contains the zero element (by definition),
* it is closed under addition (because $0+0=0$),
* it is closed under scaling (because $a0 = 0$ for all $a$).

So this is a subspace containing one element.

## Basis

A set of vectors which can be used to span the entire space.

The basis of the zero space is an empty set (instead of a set containing just the zero element).

### Dimension

The size of that set.

The dimension of the zero space is 0. The dimension of the smallest space containing $(1, 2)$ (aka a line) is 1. Planes are 2. Volumes are 3. Etc.vIt's like the number of different "directions" in the space.

# Linear maps

A function from one vector space to another that preseves the structure of the vector space. Category theorists would call this a "morphism".

* The function preserves addition: $F(a+b) = F(a)+F(b)$
* The function preserves scaling: $F(ka) = kF(a)$
* and as a consequence, the zero element is sent to the zero element: $F(0) = 0$ (where each use of the symbol $0$ talks about different vector spaces)

Basically the function "distrbutes" over both vector space operations.

For example, 2x2 matrices can be converted into 4-element vectors by plucking out the four components in some order. This is a linear map because adding and scaling matrices corresponds to adding and scaling the vector, and the zero matrix is sent to the zero vector. (Many vector spaces can be converted to and from $n$-element vectors, for some $n$.)

## Linear maps and matrix multiplication

I have midterm in 20 minutes so I'm hurrying.

Now we're tying the two worlds together. All matrices can be *used* as linear maps where $F(x) = Ax$.

## Null space

The set of $x$ where $Ax = 0$. It is remarkable that this is a null *space* and not just a null *set*.

Some matrix operations don't squish space, so the only thing that ends up at 0 is the vector already at 0. In this case the null space of that matrix is just the zero space. Other matrix operations squish more points onto zero.

The dimension of the null space is called the "nullity". A matrix with high nullity squishes space a lot, and a matrix with low nullity squishes space a little, or not at all.

## Column space / range space

The set of possible values $y$ where $Ax = y$. Again, interesting that this always forms a space, not just a set.

The range space is the span of the matrix's column vectors. Always contains the zero element, because $x$ can be the zero element.

Some matrix operations don't squish space, so the range space is the entire space. Other matrix operations squish things into a subspace and there's no input $x$ you can provide which won't leave the subspace.

The dimension of the column space is called the "rank". A matrix with high rank "covers" lots of the output space, and a matrix with low rank squishes space a lot.

### "Rank theorem"

If a matrix has $n$ columns, then the nullity of that matrix, plus the rank of that matrix, is $n$. In other words: A matrix can choose to send some values to 0, shrinking its column space -- but then the null space grows by the same amount.

In this sense the null space and the column space are sort of "opposites".

## Row space

If the range space is the span of the column vectors, the row space is the span of the row vectors.

Important things to know:

* Transposing a matrix switches the row and column spaces (obviously)
* Performing row operations *doesn't change the row space* (!)

Therefore if you transpose a matrix, do row operations, and transpose it back, you preserve the column space. This is a great way to actually *state* the column space of a matrix in a simple form. This sorta defines the notion of "column operations" on a matrix which preserve the column space.