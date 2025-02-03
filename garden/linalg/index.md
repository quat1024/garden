# Linear algebra

Not a lot of notes here yet Tbh -- this is an example of "might as well put them online instead of having them rot on my hard drive". I don't have TeX on my notebook yet.

Book we're using: "Introduction to Linear Algebra", 5th edition, by gilbert strang. I like it.

## properties of matrix operations

* Addition is commutative and associative.
* There is a zero matrix, and every matrix has an additive inverse (matrix + -matrix = 0)
  * Not to be confused with the multiplicitave inverse which is usually just called "the inverse"
  
Matrix multiplication:

* Not commutative.
* It's associative, provided the shapes line up.
* Not cancellable; AB = AC doesn't imply B = C
* Distributes over scalar addition.

## Transpose

Flip it diagonally over a sloping-downwards 45° line. Rows become columns.Usually denoted with a superscript T but i don't have TeX in these notes.

Distributes over addition `(A+B)' = A' + B'`.

Sorta over multiplication `(AB)' = B'A'` - need to switch the order

"Symmetric" matrices: `A' = A`.

If you take two column vectors, transpose the left one, and matrix-multiply them: you end up with the dot product. (Similar to how matrix multiplication is like taking a bunch of dot products.)

## Identity matrix

Has 1s on the diagonal line and 0s everywhere else. The identity for matrix multiplication (like the number `1` for scalar multiplication)

# Linear independence

Formal definition: If the only solution to `a1v1 + a2v2 + a3v3 + ... + anvn = 0` is `a1 = a2 = a3 = ... = an = 0`, where a1, a2, a3 are coefficients and v1, v2, v3 are the columns of the matrix.

Pracitcal definition: Set the vectors up as columns in a matrix, one column per vector. Augment with a column of zeroes. Row-reduce. If the matrix is reducible to that matrix with 1s on the diagonal and 0s everywhere else, the vectors are linearly independent. Otherwise (if there is a row or column of zeroes), the vectors are linearly dependent.

In other words: A set of vectors is linearly independent if there is no way to combine some of the vectors so they equal a different one.

## Singular matrices

A matrix `M` is "nonsingular" if the only solution to `Mx = 0` is `x = 0`, which is the case only if it is linearly independent.

I belieeeeeve only nonsingular matrices have a multiplicative inverse?