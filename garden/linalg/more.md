# more linalg stuff

Cramming time!!!

## change of basis matrix

imagine the vector $v$ existing independently from any coordinate system. the notation $[v]_B$ refers to "the vector $v$ written in $B$'s coordinate system". it's plonking down graph paper over the space and seeing where $v$ lands.

a matrix $P$ is a change-of-basis from $B$ to $C$ if $[v]_C = P[v]_B$. this equation means: take $v$, write it in $B$'s coordinate system, then multiply those coordinates by $P$, and you end up with the coordinates of the vector if you wrote it in $C$'s coordinate system.

how to find $P$? they give the equation $P_i = [u_i]_C$, where $u_1, u_2, u_3$ refer to the basis vectors of $B$. it means that the $i$th column of $P$ is the $i$th basis vector of B, written in the coordinates of C. In other words, the change of basis from $B$ to $C$ - take each column of $B$, write it with C's coordinates, and write it as a column of $P$

this leads to another, smaller problem: how to take the *vector* $u_i$ and write it with $C$'s coordinates? this is just a matrix-vector product equation ^^

$$Cx = u_i \qquad\rightarrow\qquad x = [u_i]_C$$

## rotations

rotation matrices (cos sin sin cos or whatever)

## uhh

complex value time oasjdiasdjajskdlasdkjasd

if λ is an eigenvalue of a matrix A, then λ conj is an eigenvalue of A conj

## similarity

$P$ and $Q$ are similar if $Q = S^{-1}PS$ for some matrix $S$. in other words, $P$ is similar to $Q$ if $P$ and $Q$ represent the same space under different coordinate bases.

similarity is an equivalence relation: reflexive, symmetric, transitive.

if $P$ is similar to $Q$ then $P$ and $Q$ have the same set of eigenvalues with the same algebraic multiplicity. the converse is not true.