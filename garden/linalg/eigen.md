*Part of the [linear algebra notes](./index)*

# Eigenstuff

(just taking notes during class on my computer)

* A matrix is a transformation that takes vectors to vectors
* If a matrix takes a vector to a scaled version of itself, this vector is an *eigenvector*

Examples:

* In 2d space, a uniform dilation around the origin scales every vector, so every vector is an eigenvector
* In 2d space, a nonuniform dilation moves the axes to dilations of themselves and throws everything else off-axis, so only the axes have eigenvectors
* In 2d space, a rotation by 10 degrees moves every vector apart from the zero vector, so only the zero vector is the eigenvector

The zero vector is always an eigenvector but it's boring so we usually don't talk about it.

The amount that a particular eigenvector gets scaled during the transformation is the *eigenvalue*. For example, if a transformation $A$ takes vector $v$ to $2v$, then $v$ is an eigenvector of $A$ and its eigenvalue is $2$.

## trick to finding eigenvectors

It feels like it'd be easier to find the eigenvectors then look for their values. But it's actually easier to find the eigen*values* then look for the corresponding vectors.

The usual trick is to subtract some number from everything along the diagonal and tweak the number until the determinant equals 0.

$$A = \begin{bmatrix}a - λ & b \\ c & d - λ\end{bmatrix}$$
$$det A = (a-λ)(d-λ) - (bc)$$

This is a quadratic and meh. Theres a good 3blue1brown about what this exactly means. ANyway so you'll get some solutions of λ, so you plug those lambdas into

$$(A - λ_{i}I)x = 0$$

for each eigenvalue $λ_0$, $λ_1$ etc, where $x$ is the eigenvector you're looking for, and $λ_{i}I$ is like the identity matrix but with $λ_{i}$ in place of 1's on the diagonal.

## algebraic multiplicity

you might have equations like $(1-λ)(1-λ)(2-λ)$

it still has 3 eigen vectors even though it's $(1-λ)^{2}(2-λ)$

## eigenspace

uhhhhh