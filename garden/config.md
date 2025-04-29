# Towards a good config system

In which I finally write up my terrible config opinions that I've been threatening to write for years.

Goals: *realistic*, *friendly* config systems. Aimed at the Minecraft mod space but probably broadly applicable.

## On-disk format

Human-readability is always, always, always more important than machine-parsability.

*Most* people will edit the config file with `notepad.exe`, so any format that's particular about delimiters, has significant indentation, or requires syntax-highlighting is out.

Comments are critical to guide the user. A loud comment character like `#` helps clarify which parts are comments in the absence of syntax highlighting. Any file format without comment support is out.

As the file grows, hierarchy becomes important. "Section headers" created out of comments can create hierarchy. Underrated: careful use of blank lines to visually separate files into paragraphs and chapters. Notice how this webpage puts more space around headings than it does between paragraphs? Why can't your config file do that?

The file extension should be something in the intersection of these two circles:

* Users recognize it as a config file without having to google what it is.
  * "Do I Look Like I Know What A Json Is"
* Users immediately know that opening the file in a text editor is an appropriate action.
  * The file should already have a "text editor" association in operating systems.

Dare I say it: maybe `.txt` is the best config file extension.

## The War On Quotes

Users should not need to care why you can leave double-quotes off of numbers but strings need double quotes except if the string is `true` or `false` then it's back to no quotes (but `"maybe"` needs quotes) and if the number is a version number like `2.3` *maybe* it'll work without quotes but `"2.3.4"` definitely needs quotes.

As a programmer you understand it's because numbers, strings, and booleans are different types in the language. But why make our implementation details into *their problem*?

Relevant links from the StrictYAML guy:

* [Syntax typing](https://hitchdev.com/strictyaml/why/syntax-typing-bad/); introducing types at the syntax level is bad.
* [Implicit typing](https://hitchdev.com/strictyaml/why/implicit-typing-removed/); guessing the type based off the syntax instead of the schema is bad. (YAML's "norway problem")

Solution: At the *config format* level, everything is just a string. When you are loading the config file into a well-typed value, *that's* when you choose to parse things into numbers or booleans or whatever you need in the program. Parsing a string into a number is a validation problem, not a well-formedness problem, and deserves to be reported with the same thoughtfulness that all errors are reported in the system. Reporting this well is *your responsibility*, not something you can kick to the authors of your TOML library.

You also don't end up with blessed types. In every config system I've used, you get a small set of types which are "free" to put in the config file -- strings, numbers, whatnot -- but even basic non-JSON types like `ResourceLocation`s are "expensive" to put in a config file and feel like an afterthought. (Well, if everything's a string, everything is an afterthought. At least now the need for custom types is more obvious and might actually be addressed!)

Also, if everything is a string anyway, you don't need quoting. Or you can make quoting optional/irrelevant. Or you can make quoting required, but now that every option is quoted and parsed the same way, there are no rules to remember. Point is, this opens up file format design space.

## POJO and pray

The easy annotation-based config system in Forge 1.12 works like this:

* You create a Java object to hold your config.
* Config fields correspond to fields of this Java object.
  * There are annotations for applying config comments, etc.
	* To set up things like min/max constraints on numbers, there are dedicated annotations for that.
* Config sections correspond to inner classes of this Java object.
* You pass this Java object off to the config system. When the config file is loaded, it will parse the file and set all the relevant Java fields if the parse succeeds.

This is pretty convenient if you stay on the happy path: simple configs using simple constraints only using supported Java types (which in practice are strings, numbers, and lists of the previous). You even get a nice GUI to edit the configuration file from in-game.

The problem is that this conflates a few ideas:

* Because the schema is read from the Java object, the layout of the Java object must perfectly match the layout of the config file. Maybe the best order to explain the config file to the user is not the most convenient order for programming. Maybe you want to put some config options in a subsection for your users, but you don't need the extra organization for programming.
* The set of configurable types is closed. If you want to configure a more complex type, you have to break it into a bunch of `String`s in the Java object. You might have a `String` field with the `@Config` annotation, and then a separate `MyType` field which you're actually supposed to use from code, and a post-config-change hook parses the string and updates that object.
* It is hard to do more validations. The set of validation annotations is closed. You better hope that `String` -> `MyType` conversion is infallible, or else the best thing you can do is throw an exception from your post-config-change hook and hope it reaches the user.
* It is hard to do migrations. If you rename a field, the old name will not get parsed and its value will get dropped on the floor. But if you leave the old-named field in the Java object, it will get written into new config files.
* After successfully loading a config file, the config system reaches in to the Java object and updates each fields. It can't update all the fields atomically. So now you have "config file tearing" to worry about.

That said, Forge also has a lower-level configuration API which you can use if the annotation API is too limiting. (Most complex mods end up growing into this API.) It is still lacking:

* It is still difficult to configure types other than numbers, strings, and lists of numbers and strings.
* It still conflates runtime-type with "textual representation in the config".
  * The most convenient runtime representation of a color is an `int` in some sort of packed `AARRGGBB` format. This will get written to config files in base-10 and cause a mess.
  * The GUI generated from the config schema suffers from the same problem.

The idea I'm getting at is that these are *separate problems* which should be addressed individually:

* Parsing a config file into a pile of strings.
* Dealing with old versions of the config - renaming options, migrating old values, etc.
* Parsing the pile of strings into a well-typed set of values and reporting any error messages that arise.
* Reporting any error messages about the global coherence of the config.
* Mapping the validated, parsed, typed values onto an easy-to-access Java object.
* Generating a graphical user interface to edit the config.

That's not to say there should be *no* crosstalk between these problems: it is convenient to grab config options off a class's fields. But it's not *enough*, and when you need more functionality the escape hatch should be a *designed* part of the system, not something bolted on afterwards.

## Regarding type-driven parsing

Information about how to serialize an value to/from a config file is ultimately up to the *field*, not the *type of the field*.

This one's simple: it's the "using `int` to store a color" problem again. Most `int`s are not for colors and should be written in base 10, but `int`s that are for colors should be written in base 16. If you are generating a config GUI, the number should get a textfield/spinnerbox/whatever, and the color should get a color picker. It doesn't matter that they're both the same runtime type.
