*Part of the [linear algebra notes](./index)*

# Matrix inverse

For some real numbers $a$, there is a unique real number $b$ such that $ab = 1$. One example is $a = 5, b = 5^{-1} = 1/5$. The product 1 is interesting because it is the multiplicative identity for real numbers ($1a = a$). Not every real number has an inverse (namely, 0).

Matrices are similar: some matrices $A$ have an inverse matrix $A^{-1}$ such that $AA^{-1} = A^{-1}A =$ the identity matrix -- the multiplicative identity for matrices. The notation $A^{-1}$ is used because it's reminiscent of raising real numbers to the power $-1$.

* Unlike real numbers, there are many matrices that lack a multiplicative inverse (not just 0).
  * We call matrices that *do* have an inverse "invertible".
* There are two ways to multiply matrices ($AB$ is not necessarily the same as $BA$), but the multiplication must result in the identity matrix in either direction.
  * This implies all invertible matrices are *square*.
* The inverse is unique.

## Noninvertible matrices

Nonsquare matrices are clearly noninvertible (there is no *one* matrix where $AX$ and $XA$ are both defined, except for square matrices)

Singular matrices (where one row or column can be reduced to all zeroes) are noninvertable.

* If you can spot that one row is clearly a multiple of another, then the matrix is noninvertable. Not all singular matrices are like that (especially large ones) but it's a good first check
* If the determinant is 0 then the matrix is noninvertable

## Properties of the inverse

* If one exists, the inverse is unique (so it makes sense to talk about "the" inverse)
* if $A$ and $B$ are invertible then so is $AB$; its inverse is $B^{-1}A^{-1}$
* The inverse of the inverse is the original
* The transpose of the inverse is the inverse of the transpose

## Solving linear systems with the inverse

Linear systems look like $Ax = b$ where $A$ is a matrix, $x$ is an unknown vector, and $b$ is a known vector.

Multiply both sides on the left by $A^{-1}$. Then you have $A^{-1}Ax=A^{-1}b$. The left side collapses to the identity matrix (by definition) times $x$, which equals $x$. Then you just need to find $A^{-1}b$ which is a straightforward matrix vector product.

Inverting a matrix is a lot of work and not every matrix is invertible. So this method is best when:

* you have a lot of equations $Ax = b_0$, $Ax = b_1$, $Ax = b_2$ to solve. Finding $A^{-1}$ will help you stamp out lots of solutions.
* you are using a computer.

If you are working by hand and only have one matrix equation to solve it's usually easier to augment the matrix and do gaussian elimination.

## Finding the inverse

* If $AB = I$ then $A$ times the first column of $B$ equals the first column of $I$, which is also written as $e_1$
* If $AB = I$ then $A$ times the second column of $B$ equals the second column of $I$, which is also written as $e_2$
* And so on

One way to find the inverse is to solve all of those equations to reveal each column of B. (Or, symmetrically, reveal columns of A)

Instead of setting up lots of little equations, you can solve them all at once. Make this

$$
\begin{bmatrix}
a&b&c&1&0&0\\
d&e&f&0&1&0\\
g&h&i&0&0&1
\end{bmatrix}
$$

and row-reduce the whole thing. If the matrix is invertible, when row-reduced the left side looks like the identity matrix and the right side contains the inverse matrix

$$
\begin{bmatrix}
1&0&0&a'&b'&c'\\
0&1&0&d'&e'&f'\\
0&0&1&g'&h'&i'
\end{bmatrix}
$$

Basically you're solving "$A$ adjoined with $e_1$", "$A$ adjoined with $e_2$", and "$A$ adjoined with $e_3$" at the same time because the solutions don't interfere with each other.

## Inverse of a 2x2 matrix

To invert

$$
\begin{bmatrix}a&b\\c&d\end{bmatrix}
$$

simply calculate

$$
\frac{1}{ad-bc}\begin{bmatrix}d&-b\\-c&a\end{bmatrix}
$$

Note that $ad-bc$ is the determinant of the matrix. That's why the determinant being 0 implies a noninvertible matrix (you can't divide by the determinant)

## "Ill conditioned"

A matrix $A$ is "ill-conditioned" if small changes to $b$ in $Ax=b$ can result in large changes to $x$. This text doesn't define "small" and "large"; illconditionedness is a domain-specific classification, something that's useful to know if you're solving linear systems for some real-world application. The term comes from numerical analysis.

You can spot ill-conditioned matrices because the inverse has big numbers when the regular matrix has small numbers. Book mentions the "Hilbert matrix", which is composed entirely of small unit fractions (half, third, fourth etc) but its inverse contains numbers as large as 4 million in the 6x6 case. (And, oddly enough, are all integers.)