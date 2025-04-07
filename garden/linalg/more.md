# more linalg stuff

Cramming time!!!

## change of basis matrix

imagine the vector $v$ existing independently from any coordinate system. the notation $[v]_B$ refers to "the vector $v$ written in $B$'s coordinate system". it's plonking down graph paper over the space and seeing where $v$ lands.

a matrix $P$ is a change-of-basis from $B$ to $C$ if $[v]_C = P[v]_B$. this equation means: take $v$, write it in $B$'s coordinate system, then multiply those coordinates by $P$, and you end up with the coordinates of the vector if you wrote it in $C$'s coordinate system.

how to find $P$? they give the equation $P_i = [u_i]_C$, where $u_1, u_2, u_3$ refer to the basis vectors of $B$. it means that the $i$th column of $P$ is the $i$th basis vector of B, written in the coordinates of C. In other words, the change of basis from $B$ to $C$ - take each column of $B$, write it with C's coordinates, and write it as a column of $P$

this leads to another, smaller problem: how to take the *vector* $u_i$ and write it with $C$'s coordinates? this is just a matrix-vector product equation ^^

$$Cx = u_i \qquad\rightarrow\qquad x = [u_i]_C$$