# Function definition syntax in Lean

*Note: I'm a functional programming beginner, this is just my understanding*

Lean has complicated syntax for function definitions. There are some reasons it's tricky to understand:

* In order to write a dependently-typed function, you need some way of referring back to the types of previous function arguments, which means they need syntax for cramming a name into the type definition
  * People like this syntax, so they use it even if they aren't writing dependent functions (!)
  * This syntax looks different from more commonly-used languages like Haskell
  * Named and non-named syntaxes can be mixed in the same function definition
* There are some syntactical abbreviations for defining functions
* Other information, like whether an argument is implicit, is communicated with sigils in the type signature

## Non-dependent function types

On the left, we declare that `add` has type `Nat → Nat → Nat`. On the right, we supply an expression of that type. This is no different from, say, `def greeting : String = "hello"`.

```lean
def add : Nat → Nat → Nat := (fun a b => a + b)
```

This syntax in particular is commonly used for pointfree functions.

```lean
def add : Nat → Nat → Nat := Nat.add
```

## Shorthand: Pattern matching definitions

*Instead of* writing `:=`, you may continue with the body of a `match` expression. The match expression scrutinizes all arguments to the function. This is called a [pattern matching definition](https://lean-lang.org/functional_programming_in_lean/getting-to-know/conveniences.html#pattern-matching-definitions).

```lean
def add : Nat → Nat → Nat
| a, b => a + b
```

This desugars to a real `match` expression, so you can include as many arms as you want, and you must cover all cases.

```lean
def add : Nat → Nat → Nat
| 0, 0 => 0
| x, 0 => x
| 0, x => x
| a, b => a + b
```

## Named arguments in parenthesis

You may move an argument to the left of the colon, enclose it in parenthesis, and give it a name. If you do, you can refer to the argument under that name from the function body.

```lean
-- (contrived examples)
def add (a: Nat) : Nat → Nat := (fun b => a + b)

def add (a: Nat) : Nat → Nat
| b => a + b
```

Notice how there is one fewer →, and in the pattern-matching function I cannot see `a` from the match arm. Do not get tricked: the type of the function is still `Nat → Nat → Nat`, as confirmed by `#check add`.

If you move more than one argument to the left of the colon, put whitespace between them. If you move all the arguments you won't have any → arrows left, and you can't use a pattern matching function (there is nothing left to pattern-match over).

```lean
def add (a: Nat) (b: Nat) : Nat := a + b
```

If you want to throw away an argument, name it `_`.

### Why does this exist?

This is also the syntax for writing dependently-typed functions -- the name can be used in later parts of the *type definition*, not just inside the body.

If you aren't familiar with dependent functions, surely you've heard of a special case: a *generic function*. The left side of the colon is a great place to put type arguments, because you can use them on the right side and in the return type.

```lean
def twoOfThem (α : Type) : α → List α
| x => [x, x]

#eval twoOfThem Nat 5
 -- [5, 5]

#check twoOfThem
 -- (α : Type) → a → List a
```

The type argument is a "real" argument. `twoOfThem` is a two-argument function.

Other languages have a special place to put type arguments. In C++, Java, and Rust, generic arguments have to go inside `<` angle brackets `>`, and putting non-type arguments up there is forbidden. In a dependently typed language, type arguments are not more special than "regular" arguments and the two can be freely mixed.

### Digression: Type associativity

Remember that `List Option String` parses as `List<Option, String>`, not as `List<Option<String>>`. It's exactly the same as any other function call (because `List` is a function).

* You can disambiguate with parenthesis. `List (Option String)`.
* You can even disambiguate with the `$` function. `List $ Option String`
* I mean, types are just values, you can write `Option String |> List` if you really want.

## Named arguments in braces

You may use braces instead of parenthesis around an argument to the left of the colon. This is now an "implicit argument". Lean tries to guess its value with type inference instead of requiring callers to write it. Very commonly used for type-generic functions like `List.filter` and `List.map`.

```lean
def twoOfThem {α : Type} : α → List α
| x => [x, x]

#eval twoOfThem "hello"
 -- ["hello", "hello"], notice how i don't need to say "String" at the call site
```

This function still takes two arguments. It is a convenience only.

There is also call-site syntax for explicitly specifying the value of an implicit argument.

```lean
#eval twoOfThem (α := UInt8) 5
```

## Typeclass arguments in square brackets

If you mention a typeclass in square brackets to the left of the colon, you can use the typeclass inside the function. Of course, this is most useful when your function also takes type arguments.

```lean
def add {α : Type} [Add α] : α → α → α
| x, y => x + y

#eval add 5 10
 -- 15
#eval add 1.5 1.5
 -- 3.000000
```

(Compare to Haskell, where typeclass constraints go to the left of a fat arrow `=>`.)

Typeclasses are also first-class values in Lean. Typeclass arguments are their own type of implicit argument; Lean performs "instance search" to find a suitable value. You can even name typeclass arguments and use "record dot" syntax on them.

```lean
def add {α : Type} [inst: Add α] : α → α → α
| x, y => (inst.add x y)
```

## Shorthand: Repeated parentheized/braced types

You can easily stamp out multiple function arguments of the same type.

```lean
def add (a : Nat) (b : Nat) : Nat := a + b
def add (a b : Nat) : Nat := a + b -- same
```

This also works for curly-braced arguments.
```lean
def pear {α β : Type} : α → β → α × β
| a, b => (a, b)
```

## Shorthand: Automatic Greek letter type arguments

You may optionally use lowercase Greek letters as type parameters *without first defining them to be type parameters:*

```lean
def twoOfThem : α → List α
| x => [x, x]

def pear : α → β → α × β
| a, b => (a, b)
```

This acts exactly as if you had written `{α β : Type}` before the colon. The shortcut only applies if the Greek letters are otherwise undefined variables. Adding `def α = 5` above this code breaks it.

Compare Haskell, which does the same thing (with lowercase ASCII letters, of course).

## Digression: ×

You're already familiar with using `→` as an infix type operator; i.e. you write `Nat → Bool` instead of something like `Function Nat Bool`. Another one to be aware of is `α × β`. This is a macro for `Prod α β`, the product (pair) type.

`Notation.lean` defines a couple more, but the other useful infix type operators exist at the proposition level (like `∧` and `∨`) and I haven't been there yet.

## Digression: Type universes

What is the type of types? If the type of `Type` is itself `Type`, that's enough to send the typechecker into infinite loops and produce inconsistent results (a result called *Girard's paradox* that I don't really understand). Not a problem for most typed FP languages -- Haskell calls this feature `TypeInType` -- but Lean is primarily a theorem prover and Girard's paradox is analogous to a proof of `False`. Not good!

The workaround Lean uses is standard:

* `Type` is an alias for `Type 1`
* `Type 1` has type `Type 2`, `Type 2` has type `Type 3`, and so on
* Universes "infect" through type arguments: `List (Type 2)` has type `Type 3` as well

### `universe` statement

Sometimes `{α : Type}` is not enough and you need to explicity specify a universe level. You can use a literal `Type 2`, but if you write `universe u v` earlier in the file, you can use the symbols `u` and `v` as "universe generics".

The `universe` statement is a bit of a parser hack. Even though the `universe` statement appears at file-level, `u` and `v` stand for fresh universe variables in every type definition they appear in.

When you use an undefined lowercase Greek letter as a type variable, Lean assumes it comes from a fresh type universe.