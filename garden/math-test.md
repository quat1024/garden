# Rendering math

By loading this page you'll load a `.woff2` copy of [Libertinus Math](https://github.com/alerque/libertinus), which is gigantic. I'd like to learn how to subset mathematical fonts -- I don't expect to use many exotic characters, I *really* just want a nice serif with matrix bars, stretchy parenthesis, maybe some Greek letters.

The markup is straight out of Pandoc's `--mathml` output, so you'll need [a browser that supports MathML](https://developer.mozilla.org/en-US/docs/Web/MathML).

## Basics of inline math

Let $x=25$. Then $\sqrt{x} = \pm 5$. Can you believe that? No way. What if $\sqrt{x} ≠ \pm 5$?

## Stretchy radicals, delimiters, and matrices

Nested radicals:

$$\sqrt{\sqrt{\sqrt{\sqrt{\sqrt{\sqrt{\sqrt{1000}}}}}}}$$

Big parens:

$$5(\frac{10\frac{x}{j}}{4})$$

Matrices:

$$
\left(\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix}
+
\begin{bmatrix}
9 & 8 & 7 \\
6 & 5 & 4 \\
3 & 2 & 1
\end{bmatrix}
\right) = \begin{bmatrix}
10 & 10 & 10 \\
10 & 10 & 10 \\
10 & 10 & 10
\end{bmatrix}
$$