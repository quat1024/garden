*Part of the [linear algebra notes](./index)*

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

## Consequences of the dot product

$A⬝B = \|A\|\|B\|\cos(θ)$ where $\|A\|, \|B\|$ denotes the length of $A$ and $B$, and $θ$ is the angle between the vectors. (Two vectors always define a plane, so it always makes sense to talk about the angle between two vectors.)

This looks like the law of cosines and it's not a coincidence (TODO fill this in, went over it in class)

Vectors are perpendicular when they have 90 degrees between them. Cosine of 90 degrees is 0. So the dot product of perpendiculuar vectors is 0 exactly when the vectors are perpendicular.

# Projections

The projection of a vector $u$ onto a vector $q$ is denoted $\textbf{Proj}_q u$. (In other words, the function that projects vectors onto $q$ is written as $\textbf{Proj}_q$.)

Book goes through this nice derivation:

1. If $v = \textbf{Proj}_q u$, then $v$ is a vector in the direction of $q$ and with its own length $\|v\|$. So you can write $v$ as
   
   $$\|v\| norm(q)$$
   
   where $norm(q)$ is q normalized to 1 unit, i.e. $q / \|q\|$. This way the length of the vector is entirely determined by the $\|v\|$ term, not the length of q.

2. From the picture you can see that $\|v\| = \|u\|\cos(θ)$. This is just right-triangle stuff from high school, nothing to do with the dot product

   So you can write $v$ as
   
   $$\|u\| \cos(θ) norm(q)$$

3. If you don't know $\cos(θ)$ you can compute it with the dot product: $\cos(θ) = (u⬝q) / (\|u\|\|q\|)$

   So you can write $v$ as
   
   $$\frac{\|u\| (u⬝q)}{\|u\|\|q\|} norm(q)$$
   
   and then cancel the $\|u\|$s leaving
   
   $$\frac{u⬝q}{\|q\|}norm(q)$$

TODO  typeset this better lol