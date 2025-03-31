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

### easy ways to find the det

Because row operations do predictable things to the determinant, instead of doing a gigantic cofactor expansion you can simplify the matrix; maybe into a triangular one. Then find the determinant of that and work back.

Adding rows to each other is the easiest way because it does nothing to the det. But other things like scaling a row is possible and might be useful to avoid fractions

## matrix operations and the det

$det(AB) = det(A)det(B)$. It multiplies, but doesn't add. In general $det(A+B) ≠ det(A) + det(B)$. The visual interpretation is clear (scale by x then scale by y -> scale by xy)
