*Part of the [linear algebra notes](./index)*

# Determinants

Did I write about determinants in some other part? Idk

Only for square matrices.

3blue1brown level explanation: A measure of how much a matrix scales or squishes space, negative sign means it's flipped over. A determinant of 4 means that any given area becomes 4 times larger after the transformation.

## computing in general

TODO. For 2x2s it's ad-bc, for 3x3s you do the minors and cofactor stuff.

When you do the cross-product mnemonic it's that, but you  can actually use any row or column instead of just the first one, just make sure to use the right sign (alternating grid of plus and minus signs)

## triangle and diagonal matrices

* Lower triangle matrix: When all the numbers below the diagonal are 0.
* Upper triangle matrix: When all the numbers above the diagonal are 0.
* Diagonal matrix: When all numbers above and below the diagonal are 0.

TODO examples of this.

In these cases finding the determinant is easy; it's just the product of the terms on the diagonal. Everything else gets multiplied by 0

## row/col operations and the determinant

Taking the transpose leaves the determinant unchanged. So everything that applies to rows also applies to columns

Switching two columns flips the sign of the determinant. (Visual interpretation: cycling around the vectors flips the handedness but leaves the volume the same)

Multiplying a column by a scalar $c$ multiplies the det by the same scalar. (Visual interpretation: scaling up one of the vectors) Ofc, multiplying the whole matrix by a scalar $c$ multiplies the det by $c^n$ where $n$ is the dimension of the matrix.

Adding one row to another does nothing to the determinant. (neat) Even adding a *multiple* of one row to another does nothing to the determinant.

### using this to find the det

Because row operations do predictable things to the determinant, instead of doing a gigantic cofactor expansion, you can simplify the matrix. Then find the determinant of that and work back. Adding rows to each other is the easiest way because it does nothing to the det. But other things like scaling a row is possible, and might be useful to avoid fractions.

Don't forget column operations!

* If you end up with a row or column that's all zeroes, you instantly know the det is 0
  * Corollary: If you end up with two identical rows or two identical columns, you instantly know the det is 0
* If you end up with a row or column that's all zeroes except for one digit, take that digit out, find the det of the corresponding minor, and multiply the two

$$\det\begin{bmatrix}0&0&x&0\\1&2&3&4\\5&6&7&8\\9&10&11&12\end{bmatrix} = x\det\begin{bmatrix}1&2&4\\5&6&8\\9&10&12\end{bmatrix}$$

Don't forget the correct sign. It's this type of grid anchored at the top left

$$\begin{bmatrix}+&-&+&-\\-&+&-&+\\+&-&+&-\\-&+&-&+\end{bmatrix}$$

Repeat until you have a 2x2 which are easy to find the det of.

## matrix operations and the det

$\det(AB) = \det(A)\det(B)$. Visual interpretation: scale by x then scale by y -> scale by xy

$\det(A^{-1}) = 1/\det(A)$. Visual interpretation: changing a "scale up by 3" into a "scale down by 3" or somesuch.

(It multiplies, but doesn't add; in general $\det(A+B) ≠ \det(A) + \det(B)$. )

Remember that $\det(A^T) = \det(A)$.

## diagonalizable matrices and the det

A matrix $A$ is *diagonalizable* if it can be written as $BDB^{-1}$ for some matrix $B$ and some *diagonal* matrix D.

The opposite of diagonalizable is *defective*. For example, a rotation matrix is defective because it is not diagonalizable (because it has no nontrivial eigenvectors).

Every symmetric matrix is diagonalizable.

If $A$ is diagonalizable and you have $B$ and $D$, then computing the determinant is easy: $\det(A) = \det(B)\det(D)\det(B^{-1})$, but since $\det(B^{-1}) = 1/\det(B)$ the terms cancel and $\det(A) = \det(D)$; and since $D$ is diagonal the determinant is just the product of its diagonal.

How do you find it: by a process inspired by polynomial long division or something???? Smething something characteristic polynomial (Im gonna be honest i'm not paying attention in class)

### why talk about this in relation to eigenvectors?

$BDB^{-1}$ looks a lot like a change-of-basis and that's not a mistake:

* Diagonalizable matrices are *anisotropic scaling* matrices: they're scaling matrices which can scale along the axes in different amounts.
* Because an anisotropic scaling scales along the axes, and because each vector is axis-aligned (b/c it only has one nonzero entry in the vector), this means every basis vector is an eigenvector (called an *eigenbasis*.)
* So $B$ is the change-of-basis required to *axis-align the eigenvectors of $D$.*

Pretty interesting

https://en.wikipedia.org/wiki/File:Diagonalization_as_rotation.gif <- this specific visual intuition only works when the matrix is symmetric i guess?? but it's the thought that counts

## which matrices are diagonalizable

ummm, i guess if it has "enough" different eigenvectors. like a 2x2 matrix should have at least 2 non-colinear nonzero vectors which are eigenvectors

i guess another way of saying that - a matrix is diagonalizable if it has an *eigenbasis* which spans the whole space. (because if there are $n$ distinct noncolinear eigenvectors on an $n×n$ matrix, that is by definition a basis)



### fun

If $A$ is diagonalizable, then finding $A^p$ is easier than doing $(p-1)$ matrix multiplications.

$$A^5 = (BDB^{-1})^5 = BDB^{-1}BDB^{-1}BDB^{-1}BDB^{-1}BDB^{-1} = BDDDDDB^{-1} = BD^5D^{-1}$$

and $D$ is diagonal so finding its fifth power can be done elementwise.