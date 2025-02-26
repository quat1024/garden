# Linear algebra

Need to write a bit more introduction to matrices, matrix multiplication mechanics, a bit about row-reduction, etc.

* Book we're using: "Introduction to Linear Algebra", 5th edition, by gilbert strang. I like it.
* You also *need* to look up the 3blue1brown "essence of linear algebra" series of video lectures. Cannot heap enough praise on these.

## Matrix size

An $m × n$ matrix has $m$ rows and $n$ columns. (This does feel a little "backwards" at times.)

## Zero matrix

A matrix where all the elements are 0.

## Matrix addition

You can add two matrices of the same size by adding each element.

Matrix addition is commutative and associative because addition of real numbers is commutative and associative.

## Matrix scaling

You can scale a matrix by a real number by multiplying all the elements of the matrix by the number.

As you'd expect from algebra, scaling distributes over addition ($p(A+B) = pA + pB$).

## Row operations

(TODO stuff)

### quat's top tips for row operations.

I am *horrible* at arithmetic, okay. I can never figure out what "minus four minus minus seven" is without carefully thinking through the signs. So I like to do row operations like "subtract 6x row 4 from row 3" in three steps:

* Take row 4 and copy it down off to the side, multiplying each number by 6 while I copy.
  * So if row 4 is $0 1 -2$ I write $0 6 -12$.
* Flip all the signs on my scratch row.
  * I add minus signs where there are none, and erase minus signs where there already are some. So I change $0 6 -12$ to $0 -6 12$.
* Add this scratch row to row 3.
  * Copy the rest of the matrix down first, and perform the addition while I copy row 3.

Actually I often flip the signs *while* multiplying, so it's actually two steps. Multiplying signed numbers is easy - you ignore the minus signs, and write a minus sign at the end as appropriate.

In other words: you can always multiply a row by -1 and *add* rather than doing *subtraction*, and I think mental addition of signed integers is easier than subtraction.

## Matrix multiplication

Blah blah blah some stuff about matrix multiplication.

* Not commutative.
* Associative, provided the shapes line up.
* Not cancellable; $AB = AC$ doesn't imply $B = C$.
* Distributes over scalar addition.

## Identity matrix

Has 1s on the diagonal line and 0s everywhere else. The identity for matrix multiplication (like the number `1` for scalar multiplication)

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

A matrix $A$ is "nonsingular" if the only solution to $Ax = 0$ is $x = 0$, which is the case only if its columns are linearly independent.

Another way of saying "the only solution to $Ax=0$ is $x=0$" is "the [null space](./spaces) of A is the zero space" or "the nullity of $A$ is 0". These mean the same thing.

Matrices have a [multiplicative inverse](./inverse) *if and only if* they are nonsingular. "Singular" is another word for "noninvertible", and "invertible" is another word for "nonsingular".

Intuition: if a matrix does some transformation that sends two distinct points to 0, you can't distinguish the points from each other anymore, so there is no way to invert that transformation. In computer graphics, a famous singular matrix is the *view transform*, which flattens the three-dimensional world being simulated into the two-dimensional space of the computer screen. If $(0, 0)$ is the center of the screen -- imagine looking at a pencil end-on, all the points along the pencil get flattened into the single point at $(0, 0)$.

# Inverses

[Here](./inverse).

# Vectors

[Over here](./vectors).

# Vector spaces and subspaces

[This way](./spaces). In my opinion this is when linear algebra starts getting fun.