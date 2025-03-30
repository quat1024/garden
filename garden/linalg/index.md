# Linear algebra

I need to write a bit more introduction to matrices, matrix multiplication mechanics, a bit about row-reduction, etc. To be fair these are my personal notes and I'm not writing a textbook.

* Book we're using: "Introduction to Linear Algebra", 5th edition, by gilbert strang. I like it.
* You also *need* to look up the 3blue1brown "essence of linear algebra" series of video lectures. Cannot heap enough praise on these.

## Matrix crash course

A *matrix* is a grid of numbers. An $m × n$ matrix has $m$ rows and $n$ columns.

You can add two matrices of the same size by adding each element. Matrix addition is commutative and associative because addition of real numbers is commutative and associative.

You can scale a matrix by a real number by multiplying all the elements of the matrix by the number. As you'd expect from algebra, scaling distributes over addition -- $p(A+B) = pA + pB$.

The *zero matrix* is a matrix where all the elements are 0. The zero matrix is an addition identity.

### Row operations

A matrix corresponds to a *linear system*, and "row operations" are ways of solving the system. If you've solved systems of equations before linear algebra you're already familiar with row operations.

## quat's top tips for row operations

I am *horrible* at arithmetic, okay. I can never figure out what "minus four minus minus seven" is without carefully thinking through the signs and usually I have to count on my fingers. If you're like me, don't fret because you can still do row operations.

* Say you want to do something like *"subtract 6× row 4 from row 3"*.
* I take row 4 and copy it down off to the side, multiplying each number by 6 while I copy.
  * So if row 4 is $[0 \quad 1 \quad -2]$ I write $[0 \quad 6 \quad -12]$.
* I flip all the signs on my scratch row.
  * Change $[0 \quad 6 \quad -12]$ to $[0 \quad -6 \quad 12]$.
* I add this scratch row to row 3.
  * Copy rows 1, 2, and 4 first, then perform the addition while I copy row 3.

Actually I often do it in two steps by flipping the signs *while* multiplying. Multiplying signed numbers is easier than adding and subtracting them IMO. And if there aren't too many minus signs in the row, sometimes I can subtract in my head too.

In other words: Usually row operations are described as "you can add and subtract rows from each other". But you can always multiply a row by a scalar, and -1 is a perfectly fine scalar, so you only really *"need"* the ability to add rows.

## Matrix multiplication

*~ Blah blah blah, write some stuff about matrix multiplication ~*

* Not commutative.
  * Therefore sometimes people talk about "left multiplication" and "right multiplication". The matrix $B$ left-multiplied by $A$ is $AB$, and the matrix $B$ right-multiplied by $A$ is $BA$.
* Associative.
  * $(AB)C = A(BC)$, which justifies writing the product without parenthesis as $ABC$.
* Not cancellable; $AB = AC$ doesn't imply $B = C$.
* Distributes over matrix addition, on both the left and the right.
  * $A(B+C) = AB + AC$.
  * $(B+C)A = BA + CA$.
* Distributes over scalar multiplication -- $p(AB) = (pA)(pB)$.

### Sizes of matrices

There's two hard-to-explain rules:

* Matrix multiplication is only defined if the column count of the left matrix equals the row count of the right matrix.
* If multiplication is defined, the result has the same number of rows as the left matrix, and the same number of columns as the right matrix.

I like to write the size of the matrix above it and then cross out the middle two numbers.

$$\overbrace{\begin{bmatrix}1&2&3\\4&5&6\end{bmatrix}}^{2×\not{3}} \overbrace{\begin{bmatrix}1&2&3&4\\5&6&7&8\\9&10&11&12\end{bmatrix}}^{\not{3}×4}$$

Now the rules are easier to explain:

* For multiplication to be defined, the middle two numbers have to match.
* The resulting matrix's size is given by the outer two numbers. Ex, this multiplication results in a $2×4$ matrix.

The most common types of matrix multiplication are multiplying two square matrices of the same size, which results in another square matrix of the same size, and multiplying a matrix by a *column vector* (a one-column matrix), which is called the *matrix-vector product*.

### Ok but why

Why is matrix multiplication defined like that? Why can't it be easy and elementwise, like matrix addition?

* A matrix represents a transformation that turns one vector into another.
  * So if $A$ represents some transformation, $Ax = y$ represents the transformation applied to $x$.
* The matrix-matrix product represents the composition of two transformations.
  * If $A$ and $B$ represent transformations then $A(Bx) = y$ first applies $B$ and then applies $A$.
  * But we have associativity. So $(AB)x = y$ must result in the same vector.
  * What is $AB$? It must be a single matrix, packaging the transformation "apply B and then apply A" into one matrix.
* You might have transformations that go between two *different* spaces. Say, a transformation that flattens 3-dimensional space onto a 2-dimensional plane.
  * This is why we bother to define multiplication among rectangular matrices.

### Identity matrix

A square matrix with 1s on the diagonal and 0s everywhere else. It's the identity for matrix multiplication (like the number `1` for scalar multiplication), both on the left and on the right.

## Transpose

Flip a matrix diagonally over a sloping-downwards 45° line. Rows become columns and columns become rows. "The transpose of $A$" is written as $A^T$, with a superscript "T".

The transpose distributes over addition: $(A+B)^T = A^T + B^T$.

It also "antidistributes" over multiplication: $(AB)^T = B^{T}A^{T}$ -- you need to switch the order.

A matrix is "symmetric" if $A^T = A$. Visually, symmetric matrices are indeed symmetric around that sloping-downwards line.

If you take two column vectors, transpose the left one, and matrix-multiply them: you end up with the dot product. (Similar to how matrix multiplication is like taking a bunch of dot products.)

# Linear independence

Formal definition: If the only solution to $a_1v_1 + a_2v_2 + a_3v_3 + ... + a_nv_n = 0$ is $a_1 = a_2 = a_3 = \cdots = a_n = 0$, where $a_1, a_2, a_3$ are coefficients and $v_1, v_2, v_3$ are the columns of the matrix.

Pracitcal definition: Set the vectors up as columns in a matrix, one column per vector. Row-reduce. If the matrix is reducible to the identity matrix, the vectors are linearly independent. Otherwise (if there is a row or column of zeroes), the vectors are linearly dependent.

In other words: A set of vectors is linearly independent if there is no way to combine some of them to make the zero vector (apart from scaling every vector to 0). More handwavingly: ...if there is no way to combine some vectors to equal a different one.

## Singular matrices

A matrix $A$ is "nonsingular" if the only solution to $Ax = 0$ is $x = 0$, which is the case *only* if its columns are linearly independent.

Another way of saying "the only solution to $Ax=0$ is $x=0$" is "the [null space](./spaces) of A is the zero space" or "the nullity of $A$ is 0". These mean the same thing.

Matrices have a [multiplicative inverse](./inverse) *if and only if* they are nonsingular. "Singular" is another word for "noninvertible", and "invertible" is another word for "nonsingular".

Intuition: if a matrix does some transformation that sends two distinct points to 0, you can't distinguish the points from each other anymore, so there is no way to invert that transformation. In computer graphics, a famous singular matrix is the *view transform*, which flattens the three-dimensional world being simulated into the two-dimensional space of the computer screen. If $(0, 0)$ is the center of the screen -- imagine looking at a pencil end-on, all the points along the pencil get flattened into the single point at $(0, 0)$.

# Inverses

[Here](./inverse).

# Vectors

[Over here](./vectors).

# Vector spaces and subspaces

[This way](./spaces). This is when linear algebra starts getting fun.

# Eigenstuff

[here](./eigen)