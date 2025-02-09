*Part of the [linear algebra notes](./index)*

# Matrix inverse

For some real numbers `a`, there is a unique real number `b` such that `ab = 1`. `a = 5`, `b = 1/5`, for example. 1 is interesting because it is the multiplicative identity for real numbers (`1a = a`). Not every real number has an inverse (namely, 0).

Matrices are similar: some matrices have an inverse matrix such that `AB` equals the identity matrix -- the multiplicative identity for matrices. 

* Unlike real numbers, there are many matrices that lack a multiplicative inverse (not just 0).
  * We call matrices that *do* have an inverse "invertible".
* There are two ways to multiply matrices (`AB` is not necessarily the same as `BA`), but the multiplication must result in the identity matrix in either direction.
  * This implies all invertible matrices are *square*.
* The inverse is unique.

## Noninvertible matrices

Nonsquare matrices are clearly noninvertible (there is no *one* matrix where `AX` and `XA` are both defined, except for square matrices)

Singular matrices (where one row or column can be reduced to all zeroes) are noninvertable.

* If you can spot that one row is clearly a multiple of another, then the matrix is noninvertable. Not all singular matrices are like that (especially large ones) but it's a good first check
* If the determinant is 0 then the matrix is noninvertable

## Properties of the inverse

* If one exists, the inverse is unique (so it makes sense to talk about "the" inverse)
* if A and B are invertible then so is AB and its inverse is B'A'
* The inverse of the inverse is the original
* The transpose of the inverse is the inverse of the transpose

## Solving linear systems with the inverse

Linear systems look like `Ax = b` where `A` is a matrix, `x` is an unknown vector, and `b` is a known vector.

Multiply both sides on the left by the inverse of `A` (which I will write as `A'` due to lack of latex support in my notes lol). Then you have `A'Ax=A'b`. The left side collapses to the identity matrix (by definition) times `x`, which equals `x`. Then you just need to find `A'b` which is a straightforward computation.

Inverting a matrix is a lot of work and not every matrix is invertible. So this method is best when:

* you have a lot of equations `Ax = b_0`, `Ax = b_1`, `Ax = b_2` to solve. Finding `A'` will help you stamp out lots of solutions.
* you are using a computer.

If you are working by hand and only have one matrix equation to solve it's usually easier to augment the matrix and do gaussian elimination.

## Finding the inverse

* If `AB = I` then `A` times the first column of `B` equals the first column of `I`, which is also written as `e1`
* If `AB = I` then `A` times the second column of `B` equals the second column of `I`, which is also written as `e2`
* And so on

One way to find the inverse is to solve all of those equations to reveal each column of B. (Or, symmetrically, reveal columns of A)

Instead of setting up lots of little equations, you can solve them all at once. Make this

```
a b c 1 0 0
d e f 0 1 0
g h i 0 0 1
```
and row-reduce the whole thing. If the matrix is invertible, when row-reduced the left side looks like the identity matrix and the right side contains the inverse matrix

```
1 0 0 a' b' c'
0 1 0 d' e' f'
0 0 1 g' h' i'
```

Basically you're solving "A adjoined with e1", "A adjoined with e2", and "A adjoined with e3" at the same time because the solutions don't interfere with each other.

## Inverse of a 2x2 matrix

To invert
```
a b
c d
```

first take
```
d -b
-c a
```
and divide by the determinant of the matrix `(ad-bc)`.

That's why the determinant being 0 implies a noninvertable matrix (you can't divide by the determinant)