# Apathy has shit config system and we need a better one

keep thinking of  a hypothetical "apathy language" but i don't know what it would look like

* SIMPLE. VERY SIMPLE. needs to be VERY VERY SIMPLE so everyone can use it.
* should cover all existing features of apathy and then some
* should be machine-translatable from the json crap, and TO the json crap as well.
* should be easy to parse so i can hopefully build a nice editor for it with documentation, auto complete, etc.

## observations

"chain" at the top level is like a function with early return. "chain" at inner levels is more complicated but it's translatable if i add functions for grouping.

"predicates" vs the tristate is really tripping people up

## syntax

again we are seeking VERY FUCKING SIMPLE, it should be familiar and easy to explain. trying to reduce the possibility of errors:

- it should not be case sensitive
- it should definitely not be whitespace sensitive
- considering "special forms" that obviate the need for quoting strings (eg. tag names)

probably something lua-like. `if ... then ... end`

```lua
if attacker.isboss then
  deny
end
```

## more methodological

### rule "always"

basically a return statement