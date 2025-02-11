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
* Not cancellable; $AB = AC$ doesn't imply $B = C$
* Distributes over scalar addition.

## Transpose

Flip it diagonally over a sloping-downwards 45° line. Rows become columns. Denoted with a superscript T.

Distributes over addition: $(A+B)^T = A^T + B^T$.

Sorta over multiplication $(AB)^T = B^{T}A^{T}$ - need to switch the order.

"Symmetric" matrices are matrices where: $A^T = A$.

If you take two column vectors, transpose the left one, and matrix-multiply them: you end up with the dot product. (Similar to how matrix multiplication is like taking a bunch of dot products.)

## Identity matrix

Has 1s on the diagonal line and 0s everywhere else. The identity for matrix multiplication (like the number `1` for scalar multiplication)

# Linear independence

Formal definition: If the only solution to $a_1v_1 + a_2v_2 + a_3v_3 + ... + a_nv_n = 0$ is $a_1 = a_2 = a_3 = \cdots = a_n = 0$, where $a_1, a_2, a_3$ are coefficients and $v_1, v_2, v_3$ are the columns of the matrix.

Pracitcal definition: Set the vectors up as columns in a matrix, one column per vector. Augment with a column of zeroes. Row-reduce. If the matrix is reducible to that matrix with 1s on the diagonal and 0s everywhere else, the vectors are linearly independent. Otherwise (if there is a row or column of zeroes), the vectors are linearly dependent.

In other words: A set of vectors is linearly independent if there is no way to combine some of the vectors so they equal a different one.

## Singular matrices

A matrix $M$ is "nonsingular" if the only solution to $Mx = 0$ is $x = 0$, which is the case only if it is linearly independent.

Only nonsingular matrices have multiplicative inverses. All matrices with multiplicative inverses are nonsingular.

# Inverses

[Here](./inverse)

## "Ill conditioned"

Matrices $A$ where small changes to $b$ in $Ax=b$ can result in large changes to $x$. This text doesn't define "small" and "large"; illconditionedness is a domain-specific classification, something that's useful to know if you're solving linear systems for some real-world application. The term comes from numerical analysis.

You can spot ill-conditioned matrices because the inverse has big numbers when the regular matrix has small numbers. Book mentions the "Hilbert matrix", which is composed entirely of small unit fractions (half, third, fourth etc), but its inverse contains numbers as large as 4 million in the 6x6 case. (And, oddly enough, are all integers.)

# Vectors

[Over here](./vectors)