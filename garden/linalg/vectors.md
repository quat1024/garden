# Vectors

Pretty familiar with these so wont take too many notes

* List of numbers
* Represents a displacement or a direction, not a position
  * The arrow representation is a bit misleading since "translating" a vector doesn't mean anything 
  * You can measure position as "displacement from the origin" if you like
* Add vectors componentwise, "tip to tail"
* Scalar-vector product is also componentwise, scaling along the direction of the vector
* Dot-product: take sum of "products of components"
* Cross product in R3: that cover-up determinant mnemonic
* Length: pythagoras
* Normalize: divide by length

In matrix algebra, "column" vectors are one-column  matrices, and "row" vectors are one-row matrices. Vector sums are matrix sums, vector scaling is matrix scaling, and the dot product corresponds to transposing one matrix and performing matrix multiplication with the other. In this way, matrix algebra is like a superset of vector algebra, you can encode vector algebra in matrix algebra.

## Basis vectors

Vectors where one component is 1 and all the other components are 0, aka the column vectors of the identity matrix.

## Right hand rule

Pointer in the direction of x, flip the bird in the direction of y, and the thumb is in the direction of z. There's two choices for a z that's perpendicular to both x and y, so the right hand rule decides for you.

This is more accurately a right hand *convention*. The left-handed coordinate system isn't *wrong*, it's just a mirror image of the right-hand system.