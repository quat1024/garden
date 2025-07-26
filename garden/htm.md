# HTM by developit

[`developit/htm`](https://github.com/developit/htm/) is one of my favorite Javascript snippets. It parses a useful subset of HTML, with the ability to substitute in variables using a "tagged template literal" and a few other niceties, in about 600 bytes of code.

I wanted to see how it works.

## "Hyperscript"

A loose standard for "a function which creates an HTML node, or something representing one". Originated in [hyperhype/hyperscript](https://github.com/hyperhype/hyperscript) as a DSL for building trees of HTML nodes, a simplified form of the function signature was [borrowed by `React.createElement`](https://react.dev/reference/react/createElement), and the rest is history.

In the context of `htm`, a hyperscript function is any function of three arguments and returning a type `T`. Often `T` represents some sort of `"virtual DOM" structure; it might also create real DOM objects.

* First argument is the tag type, which can be a string or function (a "component", in react parlance).
* Second argument is a map of attributes to apply to the tag.
* Third function is an array of children, which can be `T`s or just strings.

The goal of `htm` is to take a block of unparsed HTML and call this function to build the tree it represents.

## Template literal functions

In JS, these two statements do the same thing:

```js
bar`aaaa${1 + 1}bbbb${2 + 2}cccc`;

bar(["aaaa", "bbbb", "cccc"], 1 + 1, 2 + 2);
```

`bar` is called where the first argument is an array of all literal strings, and the rest of the arguments are the values of all substitutions between the literals. It's called in a varargs way. If the template literal begins/ends with a `${}` substitution, JS will pass an empty string before/after it, so that the number of literal strings is always one more than the number of substitutions.

When writing a function intended to be called with this syntax, you can capture all the substitutions with the varargs syntax:

```js
function bar(statics, ...subs) { ... }
```

or you can read from the special "arguments" variable, which is an array of all arguments the function was called with.

```js
function bar(statics) {
  const subs = arguments;
  ...
}
```

With the first approach the first substitution is at `subs[0]`, with the second it's at `subs[1]` because `arguments[0]` is taken up by `statics`.

## Mini version

The "mini version" (450 bytes) exports [this `build` function](https://github.com/developit/htm/blob/d62dcfdc721e47bc1923a2cb7a01ebd594ab0c25/src/build.mjs#L128-L292) as `htm`. (Of course the `MINI` is constant-folded out.)

`build` starts like this:

```js
export const build = function(statics) {
	const fields = arguments;
```

Here, `statics` contains the string literals, and `fields` contains all the substituted values (one-indexed).

```js
	const h = this;
```

To use `htm`, you write `htm.bind(myHyperscriptFunction)`. That's [bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) from standard JS. `htm` is now reading the hyperscript function bound to `this`.

```js
	let mode = MODE_TEXT; // a constant equal to 1
	let buffer = '';
	let quote = '';
	let current = [0];
	let char, propName;
```

* `mode` contains the parser state. There is `MODE_TEXT`, but also `MODE_SLASH`, `MODE_WHITESPACE`, `MODE_TAGNAME`, `MODE_COMMENT`, `MODE_PROP_SET`, and `MODE_PROP_APPEND`, as well as a "quote mode" denoted by `quote` being nonempty.
* `buffer` accumulates characters from one of the `statics` strings, until `commit` is called. For example, when the parser is in state `MODE_TEXT` `buffer` will contain the literal text to emit, when it's in state `MODE_TAGNAME` `buffer` will contain the name of the tag to emit, etc.
* `quote` may contain `'` or `"`; HTML attributes can be delimited with either so we need to remember which type of quote actually closes the string.
* `current` contains the actual HTML structure being built. `current[0]` is used as scratch space.

### Tangent: `current`

"The current element" = the element the parser is in the middle of.

* `current[1]` contains the current element's tag name.
* `current[2]` contains an object listing the current element's attributes.
* `current[3]` and onward contain the current element's children.

In other words `current.slice(1)` is "arguments to the Hyperscript function." As pieces of HTML are encountered by the parser, the appropriate section of `current` is updated.

For example, if the parser is in `MODE_TAGNAME` and `commit()` is called, indicating that the parser has just finished reading the `v` in `<div>`, `current[1]` will be set to the string "`div`".

What about `current[0]`? It is a linked list of ancestor elements: `current[0]` is the current element's parent, `current[0][0]` is the current element's grandparent, etc. Parsing HTML is a recursive task, but the `build` function is not recursive. Instead, to parse a tag contained inside another tag `current` is temporarily stashed in `current[0]`, and when the closing tag is encountered `current[0]` is popped back into `current`.

Opening (annotated with some comments):

```js
if (char === '<') {
	commit();
	//save current into current[0]
	//(and pad out current[1] and current[2] so that the next function always works...)
	current = [current, '', null];
	mode = MODE_TAGNAME;
}
```

Closing (annotated with some comments):

```js
if (char === '/' && (mode < MODE_PROP_SET || statics[i][j+1] === '>')) {
	commit();
	//not sure what this is about, something something self-closing tags?
	if (mode === MODE_TAGNAME) {
		current = current[0];
	}
	//re-using "mode" as a temporary just since it happens to be clobberable (!)
	mode = current;
	//* current = current[0] resets `current` to my parent element.
	//* the left-hand side of the .push call is my parent element, so this appends
	//  myself as my parent element's child.
	//* the slice() call tears off the "linked list of ancestors" gunk and calls
	//  the hyperscript function with the rest.
	//
	//and `current` is padded to three elements in the previous code snippet so that
	//the .push() call always adds the element starting at current[3], the area
	//designed to hold child elements.
	(current = current[0]).push(h.apply(null, mode.slice(1)));
	//we just parsed the "/" of "</div>" so tell parser to start ignoring characters
	//until after the next ">"
	mode = MODE_SLASH;
}
```

### `commit`

Next the function `commit` is defined. This function can be called in two different ways. If it's called with a numeric argument `i`, the `i`-th value from `arguments` is slotted into `current`, otherwise the contents of `buffer` are slotted into `current`. Then `buffer` is cleared.

What it means to "slot something into `current`":

* if the mode is `MODE_TEXT`, the parser just read some literal text; `.push` the string as a child (putting it in `current[3]` or later)
* if the mode is `MODE_TAGNAME`, the parser just read a tag name; set `current[1]`.
* if the mode is `MODE_PROP_SET`, the parser just read a `key=value` pair. The key is stored in a separate variable `propName`, so set `current[2][propName]`.

There are additional considerations for spread props (driven by `<div ...${props}>` syntax, splatting the value directly into `current[2]`), and a "prop appending" mode (allowing substitutions to appear inside the value of a single prop, `<html class="theme-${darkOrLight}">`)

### Parser loop

Iterating over the strings and substitutions is done in lockstep like this.

```js
for (let i=0; i<statics.length; i++) {
	if (i) {
		if (mode === MODE_TEXT) {
			commit();
		}
		commit(i);
	}
  
	//... process statics[i]...
```

So this will first process `statics[0]`, commit `arguments[1]`, process `statics[1]`, commit `arguments[2]`, process `statics[2]` and so on. This is the correct order.

(Not sure exactly why the `MODE_TEXT` check is there, probably flushing out the buffer from after the previous loop? There's one final `commit` call at the very end, after all the statics have been processed which probably corresponds to the same operation.)

Generally the parser builds up characters in `buffer` until some sort of state transition happens. `commit()` clears the buffer. Todo write about the states https://github.com/developit/htm/blob/d62dcfdc721e47bc1923a2cb7a01ebd594ab0c25/src/build.mjs#L208

## Non-mini version

The full version does not directly call the hyperscript function from `build`. Instead, `current` is built out with a list of operations to perform like a little virtual machine. Substitutions are not performed yet; only the index of the variable to substitute is recorded.

The "program" is cached indefinitely and a separate function `evaluate` is responsible for interpreting the program and calling the hyperscript function. The space formerly occupied by `current[0]` is re-used to track whether a substitution is actually used in the element's subtree; if not, the result of the hyperscript function is cached indefinitely as well.

`evalute` actually binds `current` to `this` when it calls your hyperscript function. This provides a way for the hyperscript function to disable element-level caching if it wants by running `this[0] = 3`, setting the same flag that `evaluate` sets if it determines a substitution was used.