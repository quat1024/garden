# What JVM language should I learn for Minecraft?

I occasionally see people ask "when I am learning modding, should I stick to Java or pick a different JVM language like Kotlin?" I understand why people want to avoid Java but I think you should stick to Java. Here are the reasons:

## Minecraft is Java

Minecraft is written in Java. Fabric and Neoforge are both written in Java.

So while it is *possible* to interact with Minecraft through a language like Kotlin or Scala, it is not *nice*. Minecraft and modloader APIs will not feel "idiomatic" in your preferred language; they will feel like Java code. It will be difficult to use your language's unique, non-Java features to interact with things from Minecraft.

## Minecraft is not "enterprise Java"

Maybe your exposure to Java is through Spring Boot, Jakarta, or heinous object-oriented projects in undergrad. Minecraft does not feel like that. They basically write Java like it's C++; they don't use reflection, serialization, annotations, or factory builder builder-factory builder beans. It's not so bad.

## The translation layer

Not only will you need to understand Kotlin, you will need to understand [*how Kotlin maps onto Java bytecode*](https://kotlinlang.org/docs/java-to-kotlin-interop.html). You'll need to get comfortable with [`@JvmStatic`](https://kotlinlang.org/api/core/kotlin-stdlib/kotlin.jvm/-jvm-static/), what a `companion object` actually *is*, etc.

You'll also need to understand the reverse -- how Java maps back onto Kotlin -- because every time you look at a learning resource or look at code from the loader or game, you will be looking at Java. If you're going to be thinking about Java in your head anyway, why not cut out the middleman and just write the Java you're thinking about?

## The beaten path

Most modders use Java.

* All modding tutorials use Java.
* All examples in the modloader documentation use Java.
* Most open-source mods you can learn from use Java.
* Java is the most well-tested language in the ecosystem.
* If you need to ask a question, more modders will be able to understand your code if it is presented in Java.

## Minecraft is *modern* Java\*

```{=html}
<small>*assuming you're targeting Minecraft 1.17+</small>
```

If you are only familiar with Java 6 or something, you're missing out on lambda functions, records, pattern-matching `instanceof`, pattern-matching `switch`, streams, new convenience functions, and a whole host of other things. I personally think it is very fun to write "modern Java".

## Mixin

Minecraft mods are able to directly change the code of Minecraft using a brilliant library called Mixin. Mixin is able to weave the JVM bytecode of your method into the JVM bytecode of a method from Minecraft. It's exciting stuff, but it's as hacky as it sounds, and everything needs to be set up *just so* in order for the weaving to work.

So you will need to write your mixins in Java. Even mods that use Kotlin end up with a separate Java source-set just for the mixins.

## The boilerplate is somewhere else

I've heard from several prospective modders that they're considering non-Java languages to cut down on "boilerplate code". To be frank, Minecraft modding does not involve that much "boilerplate code".

*(Instead, the boilerplate exists in the form of "a steaming pile of JSON files you need to write", but that's a story for [another day](./datapacks-bad).)*

# Sidenote: Non-JVM languages

There are some old books on "modding minecraft with Python" and such. These all rely on someone's library to do the heavy lifting for you. Every single one is out of date. Don't bother.

Generally these products are aimed at people who aren't really interested in writing full-fat Minecraft mods, but they just want to learn programming inside a visual environment. If you want to draw some pictures and learn programming in the process, there are non-Minecraft ecosystems like [Scratch](https://scratch.mit.edu) and [Processing](https://processing.org) that are better suited for learning, very visual, and *much* more well-supported with high-quality learning materials.

If you are just starting your computer programming journey, I don't want to dissuade you from having fun with Minecraft, but I also don't want to sic the ridiculous moving-target spaghetti-code Minecraft ecosystem on you either.
