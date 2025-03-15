# The Mill build tool

Just some experience notes about [Mill](https://mill-build.org/).

## Why experiment with this

* Mill uses a strongly-typed language (Scala) out of the box. In IntelliJ, the Gradle experience is either spotty and loosely-typed (using Groovy), or strongly-typed but slow and "bolted-on" feeling for back compat reasons (using Kotlin).
* Mill seems to take caching and performance very seriously.
* Mill appears to be more naturally extensible than Gradle ([for example](https://mill-build.org/mill/extending/example-typescript-support.html)); when working with Minecraft stuff I feel like I run into the walls of Gradle very quickly.
* I will admit there are some shiny toys I want to play with (like self-executing jars that prefix themselves with a shell script - very funny)
* Frankly I am just sick to death of Gradle and need a break!

see [what makes mill unique](https://mill-build.org/mill/comparisons/unique.html).

Some downsides:

* It is a smaller tool with a smaller community and probably poorer IDE integration. (However they can piggyback off the Scala ecosystem a little.)
* It's unusual! Scala is a difficult programming language for outsiders.
* The `import $ivy` magic gives me some pause. It appears hardcoded to Maven Central. In the Minecraft ecosystem we share lots of artifacts in places other than Maven Central.

## questions I had going in

* How can I fetch things from alternate Maven servers?
  * in particular, is there a way to say "fetch *this* thing from *that* server", instead of the gradle approach where you throw servers on the pile and hope one has what you need (for no reason I can discern)
* How's the multiproject story? Can I do "integration tests" in a subproject? In my project Voldeloom I use a stupid hack (`includeBuild("../../")`) to dep on the real project from my test projects. This always struck me as silly, like... is there really not a "pretty" way to write integration tests for your program? how else do you know whether the API is any good?

# setup bumpy roads

I use Intellij. So first I had to dig up the Scala plugin, which I uninstalled a long time ago since I didn't think I'd be writing Scala ever :)

Next I got [the wrapper script](https://mill-build.org/mill/cli/installation-ide.html) and put it in `./mill.bat`.

- If you are on Windows you do actually have to get the Windows version of the script. The linux build works out of  "git bash" but IDE integration does not work.
- This script reads the current version of mill out of `./.mill-version`, kind of like "the one thing anyone ever cares about in `gradle-wrapper.properties`". If you don't set a `.mill-version` it will use the latest version. The current version of mill atm is `0.12.8`. 

Next, because I haven't written any Scala before, I have to tell IDEA where to find a Scala standard library.

- In intellij, I'd right-click on the `build.mill` file, picked Override File Type and chose scala. This made it syntax-highlight the file as Scala but didn't provide semantic analysis.
- Opening `build.mill` prompted a banner at the top of the screen that said "no scala SDK found" or something. I clicked it and just downloaded whatever scala version it picked which was `2.13.15`
  - To reopen this dialog, you can go to Project Structure -> Global Libraries -> hit the "plus" and pick Scala SDK.

At this point I pasted [the example](https://mill-build.org/mill/javalib/intro.html) into `build.mill`.

Also, in my case I was opening an existing project directory and Intellij already thought it was a Gradle project. This needed some whacking:

- Close intellij, delete the `.idea` folder from the project lol.
- Open it again. It might prompt whether you want a bsp project or a gradle project. Pick bsp.
  - I heard people say "File -> New Project from Existing Sources" would work, but it didn't do anything for me.

The initial bsp project import took a little bit; probably downloading some mill bits. Just give it some time to think. Turning off "export SBT project to Bloop before import" seemed to improve things (but i might be imagining it)

There is always some friction between build tools and whatever "the IDE project model" is. In this case it appears the root of the project becomes an IDE-side module called `mill-synthetic-root`.

# playing around

Ok so I have this `build.mill` lifted straight from the example.

```scala
package build
import mill._, javalib._

object foo extends JavaModule {
  def ivyDeps = Agg(
    ivy"net.sourceforge.argparse4j:argparse4j:0.9.0",
    ivy"org.thymeleaf:thymeleaf:3.1.1.RELEASE"
  )

  object test extends JavaTests with TestModule.Junit4 {
    def ivyDeps = super.ivyDeps() ++ Agg(
      ivy"com.google.guava:guava:33.3.0-jre"
    )
  }
}
```

(IntelliJ prompted me to add `override` to those `def ivyDeps`.)

Ok, so I am learning a build tool and a new langauge at the same time.

* `JavaModule` comes from `javalib` which is introduced [here](https://mill-build.org/mill/javalib/intro.html)
* Generally a lot of stuff in javalib feels "re-exporty", like, you ctrl-click in the editor and you go to the reexports, and ctrl-click again to go to the actual definition.
* There is a layer below `JavaModule` of course, which is introduced [a bit below here](https://mill-build.org/mill/fundamentals/tasks.html). That definitely feels a little less "gradle magic" than this code sample.
* But since ctrl-click works, and goes into code that sometimes even has comments (lol) I feel confident I could understand `JavaModule` if I wanted. But skimming [this](https://mill-build.org/mill/javalib/module-config.html) wouldn't be a bad first step.

The default directory for sources is `foo/src`; first `foo` (name of the module) then `src` and `.java` files go directly in there. This is unlike Maven where you `src/main/java`. But if you want the Maven format you can [extend `MavenModule` instead of `JavaModule`](https://mill-build.org/mill/javalib/intro.html#_maven_compatible_modules). But here is the complete definition of `MavenModule`.

```scala
trait MavenModule extends JavaModule { outer =>

  override def sources = Task.Sources(
    millSourcePath / "src/main/java"
  )
  override def resources = Task.Sources {
    millSourcePath / "src/main/resources"
  }
}
```

So it's not too difficult to do yourself :)

Because it's just scala you can even press Ctrl-O to list all overridable methods! There are a *lot* of them in javalib but this is already 1000x better discoverability than Gradle.

## subprojects

The subprojects story feels 100000x better.

In Gradle, you list subprojects in `settings.gradle`. In Mill you create several objects in `build.mill` (you can have several `object ___ extends JavaModule`).

In Gradle, you put subproject-specific configuration under `<subproject name>/build.gradle`. In Mill you define the subproject-specific configuration right alongside the definition of the subproject, so they all live in the same file.

In Gradle, you configure all subprojects with a `subprojects` or `allprojects` block and then get yelled at because that's not the right way to do it and actually you're *supposed* to create a build convention plugin in `buildSrc` or whatever the fuck. In Mill you configure all subprojects by creating your own module type (ex. `trait MyModule extends JavaModule`) and subclass *that* from your subprojects. (this is called a [trait module](https://mill-build.org/mill/fundamentals/modules.html).)

Like damn this model is so much better. `subprojects` blocks stop being magic-at-a-distance and start being something you can see is happening, because you extend a different module than `JavaModule`, and if you ctrl-click the module you can go to it. You can leverage existing object-oriented intuition and do inheritance, abstract methods, and so on.

This also means we don't need anything like `gradle.properties` substitution, because you can write a trait (doesn't have to be a module), `with` it from your modules, and grab the properties from there.

## tasks

I think it's instructive to look at [the verbose, non `JavaModule` build example](https://mill-build.org/mill/fundamentals/tasks.html).

The task types are:

* `Task`, a piece of Scala code which is executed *if its input tasks change* and is considered "outdated" if the output is different
* `Task.Input`, a piece of Scala code which is executed *every time* and considered "outdated" if the output is different
* `Task.Source`, a file/folder-tree which is considered outdated when it changes
* `Task.Sources`, a list thereof
* `Task.Command`, which can take parameters
  * not cached
* `Task.Worker`, a task which sticks around in the Mill daemon
* Something something "anonymous tasks"

The most important ones are `Source`/`Sources`, used for your project sources, `Task`, used for compilation and processing tasks, and `Input`, used for external data you want to slot into the build (like a version number or the git status or whatever)

When writing a general `Task`:

* You can access the variable `Task.dest`. This is a unique folder created fresh for your task and you can write whatever you want in there.
  * You can use the division operator to munge paths: `Task.dest / "myfile.txt"`
  * If you don't want a *fresh* folder you can pass `persistent = true`. But then it's your responsibility to maintain cache coherency.
* You can access the result of a task by "calling" it; `myTask()`. Doing this will also create a dependency edge on that task
  * It's not "monadic". All dependency edges are created before the code is executed
  * ...somehow

## modules

[The page](https://mill-build.org/mill/fundamentals/modules.html) is pretty clear

* `object` modules are namespaces and organizational tools
* `trait` modules are subclass-bait, used to factor code

(See the above glazing of the subprojects system.)

Scala also has `class`es but they are not recommended "due to implementation limitations". Ok. Im not too familiar with Scala but `trait`s look like what i need anyway.

Scala has multiple inheritance across traits so you can bring in as many traits as you want. See `JavaModule`.

Check this out too https://mill-build.org/mill/fundamentals/modules.html#_use_case_diy_java_modules

# random cheatsheety things

- `./mill shutdown` is like `./gradlew --stop`
- mill's `./out` is like gradle's `./build` and should be gitignored
- "BSP" stands for [Build Server Protocol](https://build-server-protocol.github.io/) and it's supposed to be a standard way for build tools to communicate with IDEs, analogous to the language server protocol. It is intended as a general standard but has gained the most traction in the Scala ecosystem (and hence, the BSP integration in IntelliJ is part of the Scala plugin)
- ["Coursier"](https://get-coursier.io/docs/overview) is a Scala library for downloading things off maven/ivy servers. Coursier does a lot of things but it has an opinion about how caching works, so Mill inherits its caching model for these kinds of dep

Goddammit. The gradle "version catalog" thing everyone was hyped about turns out to just be a pear-shaped bill of materials. Mill's [BoM system](https://mill-build.org/mill/fundamentals/library-deps.html#_dependency_management) can load external BoMs off Maven servers, or you can just write one. 