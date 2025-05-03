# Dissecting char-min-glee by Jack Lance

*Char Min Glee* is [a "little game made in 560 characters of javascript"](https://jacklance.itch.io/char-min-glee) by the [late](https://joelthefox.github.io/2023-05-04-Jack-Lance/) [Jack Lance](https://jacklance.github.io/).

Here is the source code to the game. It has copypasted poorly into this document; the canonical source is on the itch page or [this jsfiddle](https://jsfiddle.net/jacklance/t0vupbf3/1/).

```js
j=[];u=o=>{(b=$('body')).html((e='<button onclick="')+'m(0)">⟲'+e+'j[0]?u(a=j.pop()):0">⤺');a.map((r,x)=>{b.append('<br>');r.map((c,y)=>b.append(e+(c!='x'?`j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)">`+c:'">_')))})};m=o=>{n=0;u(a=l[i+=o].split`k`.map(a=>a.split``))};l=(btoa("ÓMdÒM4ÓItÇI1ÇY4LqÇqÒI4ÇMdÓtI4ÇYuLtIDÓM6M4ÓyuÓI$ÇM$ÓIDÖI4ÒQÓtÇI1ÇI1ÇI4ÓY1Ç%ÓmÄ8I1Çy$M%")+'ÜkWIN!').replace(/E/g,'>').split`l`;m(i=0)
```

Here is a clone of the game playable on this webpage with a few tweaks (zoom function & level select).

```{=html}
<div id="b" style="border: 1px solid black; padding: 10px">Either you have JS off or I broke the game, check browser console</div>
<details><summary>Size</summary><div id="zoombuttons"></div></details>
<details><summary>Level select</summary><div id="levelskip"></div></details>

<style>#b button {font-size: var(--button-font-size, 100%);}</style>

<script>
j=[];u=o=>{b.innerHTML=((e='<button onclick="')+'m(0)">⟲'+e+'j[0]?u(a=j.pop()):0">⤺');a.map((r,x)=>{b.innerHTML+='<br>';r.map((c,y)=>b.innerHTML+=(e+(c!='x'?`j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)">`+c:'">_')))})};m=o=>{n=0;u(a=l[i+=o].split`k`.map(a=>a.split``))};l=('001k0k0000l0x0kxx1k0l0xxxxxx0kk0x01k0xx0lEk0x1l1k0x0k0lE0002kE0003l100kkx00k00lE1kk00lEE04l0x0kxx0kxx0k001kxxx0l023ElxE4kkkxx3kkkk0lÜkWIN!').replace(/E/g,'>').split`l`;m(i=0)

for(let i = 1; i <= 5; i++) zoombuttons.innerHTML += `<button onclick="b.style.setProperty('--button-font-size', '${i}00%')">${i}00%`
for(let i = 0; i < l.length; i++) levelskip.innerHTML += `<button onclick="j=[];i=${i};m(0)">${i+1}</button>`
</script>
```

On the game's page, Jack Lance simply wrote *"Discover the rules as you go"*, so as a reverse-engineering effort, this page will necessarily contain mechanics spoilers. I figure that fiddling with the source code is a permissible mode of interaction with the work, given that it was put on display on the Itch page.

Unfortunately he was incorrect when he wrote you could "paste it into the console on any page with a body" because it uses features from jQuery like the `$` function and some helpers like `.append` and `.html`. Many real-life webpages do define jQuery, including `itch.io` itself. For the copy above I had to modify the game to remove usages of jQuery and inline the `btoa` call to avoid problems with invalid UTF8, and it no longer fits in two tweets.

Here it is pretty-printed with an off-the-shelf formatter:

```js
j = [];
u = o => {
    (b = $('body')).html((e = '<button onclick="') + 'm(0)">⟲' + e + 'j[0]?u(a=j.pop()):0">⤺');
    a.map((r, x) => {
        b.append('<br>');
        r.map((c, y) => b.append(e + (c != 'x' ? `j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)">` + c : '">_')))
    })
};
m = o => {
    n = 0;
    u(a = l[i += o].split`k`.map(a => a.split``))
};
l = (btoa("ÓMdÒM4ÓItÇI1ÇY4LqÇqÒI4ÇMdÓtI4ÇYuLtIDÓM6M4ÓyuÓI$ÇM$ÓIDÖI4ÒQÓtÇI1ÇI1ÇI4ÓY1Ç%ÓmÄ8I1Çy$M%") + 'ÜkWIN!').replace(/E/g, '>').split`l`;
m(i = 0)
```

## Level table (`l`)

The `btoa` call evaluates to `"001k0k0000l0x0kxx1k0l0xxxxxx0kk0x01k0xx0lEk0x1l1k0x0k0lE0002kE0003l100kkx00k00lE1kk00lEE04l0x0kxx0kxx0k001kxxx0l023ElxE4kkkxx3kkkk0l"`. The string `ÜkWIN!` is appended, capital `E`s are replaced with a right-angle bracket, and the whole thing is split on `l` characters into a thirteen-element array.

```js
l = [
  "001k0k0000",
  "0x0kxx1k0",
  "0xxxxxx0kk0x01k0xx0",
  ">k0x1",
  "1k0x0k0",
  ">0002k>0003",
  "100kkx00k00",
  ">1kk00",
  ">>04",
  "0x0kxx0kxx0k001kxxx0",
  "023>",
  "x>4kkkxx3kkkk0",
  "ÜkWIN!"
]
```

This is the level format in the game. `k` represents a newline, `x` represents an underscore button and everything else creates a button with that label.

I'm not sure why Lance spent lots of characters on `.replace(/E/g, '>')` instead of simply using `>` characters in the level format. Maybe it encoded poorly or maybe it caused parse problems with HTML?

The unusual syntax `` .split`l` `` is misusing JS template literals to save two characters over `.split("l")`. The backtick-syntax is equivalent to `.split(["l"])`, and you're not supposed to pass arrays as arguments to `split`, but it *does* work:

```js
"onextwoxthree".split("x")
// ["one", "two", "three"]

"onextwoxthree".split(["x"])
// ["one", "two", "three"]
```

This is because JS stringifies the argument to `split` if it's not a string, regex, or something with a `Symbol.split`, and stringifying a JS array stringifies each element and intersperses commas, but no commas appear because it's a one-element array.

```js
["x"] + ""
// "x"
```

## Current level (`i`) and level loader (`m`)

The variable `i` holds the index of the current level in the level table. It is set to `0` by the last line of code, which calls `m` at the same time.

`m` is the *level loader* and loads the `i`-th level. `m`'s function argument `o` is actually how many levels to *skip forward*; the reset button calls `m(0)`, and the win state calls `m(1)` to advance to the next level.

Here is `m`:

```js
m=o=>{n=0;u(a=l[i+=o].split`k`.map(a=>a.split``))}
```

* sets `n` to 0 (a surprise tool that will help us later),
* `i += o` increments the level number `i` by `o` -- reset when `o == 0`, advance when `o == 1`,
* `l[...]` indexes into the level table `l` by the new value of `i`, resulting in a string like `"001k0k0000"`,
* `` .split`k` `` splits the string on `k` characters to break it into lines: `["001", "0", "0000"]`,
* ``` .map(a=>a.split`` ``` further splits each string into character arrays: `[["0","0","1"],["0"],["0","0","0","0"]]`,
* assigns the result to the global variable `a`,
* calls `u`.

We can see more usages of using `split` as a template literal function to save characters. Normally they would be written as `split("k")` and `split("")` so the template-literal hack save 4 characters in total in this function.

## Level renderer (`u`)

Most code in the game is contained in `u`. Here it is again:

```js
u=o=>{(b=$('body')).html((e='<button onclick="')+'m(0)">⟲'+e+'j[0]?u(a=j.pop()):0">⤺');a.map((r,x)=>{b.append('<br>');r.map((c,y)=>b.append(e+(c!='x'?`j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)">`+c:'">_')))})}
```

and pretty-printed:

```js
u = o => {
  (b = $('body')).html((e = '<button onclick="') + 'm(0)">⟲' + e + 'j[0]?u(a=j.pop()):0">⤺');
  a.map((r, x) => {
    b.append('<br>');
    r.map((c, y) => b.append(e + (c != 'x' ? `j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)">` + c : '">_')))
  })
};
```

Note that `u` takes an argument `o` but doesn't use it. This saves three characters overall:

* defining a one-argument arrow function `x=>{...}` takes one fewer character than a zero-argument arrow function `()=>{...}`.
* doing work and then calling a function with the result of that work, like `u(work)`, takes one fewer character than doing work and calling the function in a separate statement, like `work;u()`, because it allows omitting the semicolon. One call like this happens in `a` and a second call happens in some code generated by `u`.

The current state of the level is held in global variable `a`.

```js
(b = $('body')).html((e = '<button onclick="') + 'm(0)">⟲' + e + 'j[0]?u(a=j.pop()):0">⤺');
```

The first statement in `u` sets `b` to a jQuery object representing the document body, clears the body's `innerHTML`, and replaces it with reset and undo buttons (using jQuery's `.html` function), saving the snippet `<button onclick="` in a variable `e`.

The reset button calls `m(0)` to reset the level. The undo button references the undo stack stored in `j`; if it isn't empty, it rebuilds the current level using `j.pop()`, rolling back one game state. Neither `m` nor the reset button clears the undo stack so you can "undo a reset", as is conventional in modern puzzle games.

```js
a.map((r, x) => {
  b.append('<br>');
  r.map((c, y) => b.append(e + ...
```

Next we loop over every cell in the game state using a few `map`s, and output a newline after every row. Two-argument `map` is used, and the variable names are evocative: `r` contains the current row, `c` contains the current character, and `x`/`y` contain the coordinates of the current button.

```js
b.append(e + (c != 'x' ? ... : '">_'))
```

Remember that `e` contains the string ``<button onclick="``. So if the current cell is `x`, this appends `<button onclick="">_` to the document. The `<button>` tag is never closed, however browsers will automatically close your open `<button>` tags when you write to `innerHTML` (which the jQuery `append` function uses). So this writes a spacer button with no click action into the HTML.

```js
b.innerHTML = "<button>a";
b.innerHTML
// "<button>a</button>"
```

The other branch of the append, when `c != 'x'`, is much more interesting.

## Button click handler

**Now we are getting in to serious game mechanic spoilers.**

Buttons that don't contain `x` get the following code as their click handler, where `${x}` and `${y}` are substituted for the button's X and Y coordinate.

```js
j.push(a.map(o=>[...o]));(q=a[x=${x}])[y=${y}]!='>'?(n=1,a.map((r,w)=>r.map((c,z)=>{if((o=w-x)*o+(o=y-z)*o==c*c)q[y]-=-c;n&=c!=0}))):(q[y]=q[y+1]|0,a[x][y+1]='>');u(n?(j=[],m(1)):0)
```

Here is an attempt to pretty-print it:

```js
j.push(a.map(o => [...o]));

(q = a[x = ${x}])[y = ${y}] != '>'
  ? (n = 1, a.map((r, w) =>
    r.map((c, z) => {
      if ((o = w - x) * o + (o = y - z) * o == c * c)
        q[y] -= -c;
      n &= c != 0
    })))
  : (q[y] = q[y + 1] | 0, a[x][y + 1] = '>');

u(n ? (j = [], m(1)) : 0)
```

The first line of code, `j.push(a.map(o => [...o]));`, simply adds a copy of the current gamestate `a` to the undo stack. `.map` and the spread operator are used to create a "deep copy".

The middle expression handles the button click. First, `(q = a[x = ${x}])[y = ${y}]` sets `x` and `y` to the current button's `x` and `y` coordinates (remember they are substituted in), and causes `q` to become an abbreviation for `a[x]`.

If the clicked button was `>`, `(q[y] = q[y + 1] | 0, a[x][y + 1] = '>')` switches the `>` with the cell to its right, extending the row with a `0` if there is no such cell. I'm not sure why `a[x][y+1]='>'` was used when `q[y+1]='>'` would probably suffice.

Otherwise, `n` is set to 1 and the entire grid is looped over. If a cell with value `c` is discovered that's exactly `c` blocks away from the clicked cell, the value of the clicked cell is incremented by `c` -- hard to explain in words but this is the core concept of the game. At the same time, the `n` variable is set back to 0 if a cell with value 0 is discovered; which means that `n` can only remain `1` if there are no zeroes left on the board.

The `c * c` works correctly regardless of whether `c` is a number or string, and the incrementation is done "backwards", `q[y] -= -c` instead of `q[y] += c`, to coerce both `q[y]` and `c` to numbers at the same time. This is because the level data array `l` stores the grid as arrays of one-character strings, and they are never parsed into numbers when copied into the game state array `a`, but modifying the game state like this ends up leaking numbers into the game state. It only costs one character to make this function accept both strings and numbers, which is cheaper than coercing everything to one datatype.

Finally if `n` is still 0, the `u` function is called to refresh the UI with the newly-modified game state in `a`. But if `n` is 1, meaning all the zeroes were erased, `m(1)` is called to advance to the next level. (The call to `u` still happens in this case, meaning that the refresh happens twice, but it's no big deal.)
