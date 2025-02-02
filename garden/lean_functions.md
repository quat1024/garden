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

On the left, we declare that `add` has type `Nat → Nat → Nat`. On the right, we supply an expression of that type. This is no different from, say, `def greeting : String := "hello"`.

```lean
def add : Nat → Nat → Nat := (fun a b => a + b)
```

This syntax is handy for pointfree functions.

```lean
def add : Nat → Nat → Nat := Nat.add
```

## Shorthand: Pattern matching definitions

*Instead of* writing `:=`, you may add a newline and continue with the body of a `match` expression. The expression will scrutinize all arguments to the function. This is called a [pattern-matching definition](https://lean-lang.org/functional_programming_in_lean/getting-to-know/conveniences.html#pattern-matching-definitions).

```lean
def add : Nat → Nat → Nat
| a, b => a + b
```

You can include as many match arms as you want, and you must exhaustively match all cases, because you are indeed writing a real `match` expression.

```lean
def add : Nat → Nat → Nat
| 0, 0 => 0
| x, 0 => x
| 0, x => x
| a, b => a + b

-- desugars to something like:
def add : Nat → Nat → Nat := (fun arg1 arg2 => match arg1 arg2 with
  | 0, 0 => 0
  | x, 0 => x
  | 0, x => x
  | a, b => a + b
)
```

You may *not* write `:=` after the type of the function if you use pattern-matching definition syntax. That is a parse error.

## Named arguments in parenthesis

You may move an argument to the left of the colon, enclose it in parenthesis, and give it a name. If you do, you can refer to the argument under that name from the function body.

```lean
def add (a: Nat) : Nat → Nat := (fun b => a + b)

def add (a: Nat) : Nat → Nat
| b => a + b

-- [these are contrived examples]
```

Notice how there is one fewer `→` in the type signature and the body takes one fewer argument. Do not get tricked: the type of `add` is still `Nat → Nat → Nat`, as confirmed by `#check add`.

You can use the name `_` to ignore an argument without "unused variable" warnings.

If you move more than one argument to the left of the colon, don't put any arrows between them. If you move all the arguments to the left, you won't have any `→` arrows left, and you can't use pattern matching function syntax (since there is nothing left to pattern-match over).

```lean
def add : Nat → Nat → Nat := (fun a b => a + b)
def add (a: Nat) : Nat → Nat := (fun b => a + b)
def add (a: Nat) (b : Nat) : Nat := a + b
```

Using a hole can reveal more about what's going on.

```lean
def add (a: Nat) : Nat → Nat := _
 -- don't know how to synthesize placeholder context:
 -- a : Nat
 -- ⊢ Nat → Nat
```

It's like currying!

### Why does this exist?

This is also the syntax for writing dependently-typed functions -- the name can be used in later parts of the *type definition*, not just inside the body. The left side of the colon is a great place to put type arguments, because you can use them in argument types and the return type, just like generics in Java or Rust.

```lean
def twoOfThem (α : Type) : α → List α
| x => [x, x]

#eval twoOfThem Nat 5
 -- [5, 5]

#check twoOfThem
 -- (α : Type) → a → List a
```

The type argument is a "real" argument. `twoOfThem` is a two-argument function.

Other languages have a special place to put type arguments. In Java and Rust, generic arguments have to go inside `<` angle brackets `>`, and putting non-type arguments up there is forbidden. In a dependently typed language, type arguments are not more special than "regular" arguments and the two can be freely mixed.

[*Functional Programming in Lean*](https://lean-lang.org/functional_programming_in_lean/getting-to-know/functions-and-definitions.html#defining-functions) introduces the "all arguments to the left of colon" style as the *primary* way to define functions. It is convenient to declare argument types and capture them in one step, and it makes it easier to introduce dependent types -- it's only a small leap to start reusing variables in the type definition.

## Named arguments in braces

You may use braces instead of parenthesis around an argument to the left of the colon. This is now an "implicit argument", and Lean tries to guess its value at the call site instead of requiring callers to write it. Most type-generic functions use implicit parameters for their type arguments.

```lean
def twoOfThem {α : Type} : α → List α
| x => [x, x]

#eval twoOfThem "hello"
 -- ["hello", "hello"], notice how i don't need to say "String" at the call site
```

The function still takes two arguments. It is a syntactical convenience only.

If you need to explicitly define the value of an implicit argument at the call site, there's syntax for that:

```lean
#eval twoOfThem (α := UInt8) 5
```

### Shorthand: Automatic Greek letter type arguments

You may optionally use lowercase Greek letters as type parameters *without first declaring them to be type parameters:*

```lean
def twoOfThem : α → List α
| x => [x, x]

def pear : α → β → α × β
| a, b => (a, b)
```

This acts exactly as if you had written `{α : Type} {β : Type}` before the colon. The shortcut only applies if the Greek letters are otherwise undefined variables. Adding `def α = 5` above this code breaks it.

## Typeclass arguments in square brackets

If you mention a typeclass in square brackets to the left of the colon, you may use functions from the typeclass. (Compare to Haskell, where typeclass constraints go to the left of a fat arrow `=>`.)

```lean
def add {α : Type} [Add α] : α → α → α
| x, y => x + y

#eval add 5 10
 -- 15
#eval add 1.5 1.5
 -- 3.000000
```

Typeclasses are also first-class values in Lean. Square-bracketed typeclass arguments are their own type of implicit argument; Lean performs ["instance search"](https://lean-lang.org/functional_programming_in_lean/type-classes/out-params.html) to find a suitable value at the call site. You can even give typeclass arguments a name and use record-dot syntax on them.

```lean
def add {α : Type} [inst: Add α] : α → α → α
| x, y => (inst.add x y)
```

The object `inst` provides tangible evidence that `α` belongs to typeclass `Add`.

Owing to the dependent types, Lean's typeclasses are unusual compared to nondependent languages. Conversion and coercion typeclasses like `OfNat` and `Coe` provide the value they're converting from as an argument *to the typeclass*, enabling typeclass implementers to only implement `OfNat` for an appropriate range of values, and typeclass users to only request `OfNat` implementations for the values they need. So don't be surprised if you see constants and non-type variables appearing within square brackets.

### Aside: Non-generic typeclass arguments (for fun)

Of course typeclass arguments are most useful when they depend on a type argument. You don't *need* type arguments in the square brackets, though:

```lean
def what [Inhabited Empty] {α : Type} : Unit → α
| _ => Empty.rec (fun _ => α) default
```

This function promises to turn `Unit` into any type `α` at all, as long as an instance of `Inhabited Empty` exists. It's impossible to create such an instance. Exactly analogous to how `False` implies everything, but no statements that prove `False` are correct.

## Shorthand: Repeated parentheized/braced types

You can easily stamp out multiple function arguments of the same type by writing more than one name in the parenthesis. They will be expanded left-to-right.

```lean
def add (a : Nat) (b : Nat) : Nat := a + b
def add (a b : Nat) : Nat := a + b -- same
```

This also works for curly-braced arguments.
```lean
def pear {α β : Type} : α → β → α × β
| a, b => (a, b)
```

(For `Type` arguments, the universe level is also copied across all arguments in the list.)

## Digression: ×

You're already familiar with using `→` as an infix type operator; i.e. you write `Nat → Bool` to represent the type of functions from `Nat` to `Bool`,  instead of something like `Function Nat Bool`.

Another one to be aware of is `α × β`. This is a macro for `Prod α β`, the product (pair) type. `Notation.lean` defines a couple more, but the other infix type operators exist at the proposition level (like `∧` and `∨`) and I haven't been there yet.

### Digression: Type associativity

Remember that `List Option String` parses as `List<Option, String>`, not as `List<Option<String>>`. It's exactly the same as any other function call (because `List` is a function).

* You can disambiguate with parenthesis. `List (Option String)`.
* You can even disambiguate with the `$` function. `List $ Option String`
* I mean, types are just values, you can write `Option String |> List` if you really want.

## Digression: Type universes

What is the type of types? If the type of `Type` is itself `Type`, that's enough to send the typechecker into infinite loops and produce inconsistent results (a result called *Girard's paradox* that I don't really understand). Not a problem for most typed FP languages -- Haskell calls this feature `TypeInType` -- but Lean is primarily a theorem prover and Girard's paradox is analogous to a proof of `False`. Not good!

The workaround Lean uses is standard:

* `Type` is an alias for `Type 1`
* `Type 1` has type `Type 2`, `Type 2` has type `Type 3`, and so on
* Universes "infect" across type-level functions:
  * `List (Type 2)   : Type 3`
  * `Type 4 × Type 2 : Type 5`

### `universe` statement

Sometimes `{α : Type}` is not enough and you need to explicity specify a universe level. You can use a literal `Type 2`, but if you write `universe u v` earlier in the file, you can use the symbols `u` and `v` as "universe generics".

The `universe` statement is a bit of a parser hack. Even though the `universe` statement appears at file-level, `u` and `v` stand for fresh universe variables in every type definition they appear in.

When you use an undefined lowercase Greek letter as a type variable, Lean assumes it comes from a fresh type universe.

All of this is probably wrong because I haven't looked into type universes very much.
