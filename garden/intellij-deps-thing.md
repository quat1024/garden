# IntelliJ can't find intra-module dependencies when they're behind a configuration

Basically IntelliJ's project model is composed of "modules", no relation to the Java 9 term. Modules can depend on libraries, or they can depend on other modules in the project. If you open "Project Structure" -> "Modules" -> pick something -> "Dependencies", module-to-library dependencies are displayed with a stack-of-books icon, and module-to-module dependencies are displayed with a folder icon.

Most people no longer select "build and run with IDEA" anymore, they delegate all the building to Gradle. But IntelliJ's view of the project model is still used when navigating in the IDE, "find usages", auto complete, realtime error-checking, etc. In particular, when you press "go to definition" on a class from a module-to-module dependency IDEA can open the corresponding source file, but if the class is from a module-to-library dependency IDEA doesn't know which source file it came from and defaults to decompiling the class.

When "importing from Gradle" IntelliJ allows your Gradle buildscript to run and then tries to interpret the results in its own project model. Gradle subprojects become IDEA modules, Gradle dependencies become IDEA module dependencies, etc. There is an impedance mismatch here, because the Gradle project model and the IDEA project model are different.

One way this can manifest is that -- I don't think Gradle puts as much distinction between subproject-to-library and subproject-to-subproject dependencies? As far as Gradle is concerned, the producer subproject publishes some jars, and the consumer module puts those jars on the classpath. When IntelliJ tries to interpret Gradle's project module, it has to guess which dependency edges it sees actually correspond to module-to-module dependencies, and upgrade them if so.

That's my understanding anyway. This is all speculation, I don't really know how to debug this.

## The problem

I don't have a good reducer for this which explains the handwaviness, i'm writing a gradle plugin.

Working with a source-set called `rebind_narrator`. One configuration is called `rebind_narratorImplementation` which contains compilation dependencies. Another configuraton is called `rebind_narratorSplat` which contains dependencies for shading into the jar; its contents should also be present on the compilation classpath.

Because `rebind_narratorSplat` contains things which should go on the compilation classpath, I figured `rebind_narratorImplementation` could depend on `rebind_narratorSplat`. This seems to confuse IDEA.

* When configuration `rebind_narratorImplementation` depended on configuration `rebind_narratorSplat`, and that configuration contained a Gradle subproject dependency, IntelliJ was not able to identify the module-to-module dependency and defaulted to module-to-jar.
* I added the project dependency to `rebind_narratorCompileOnly` as well. Now IntelliJ was able to identify the module-to-module dependency.,

## Wait a second

I thought configuration-to-configuration dependencies were supposed to be deprecated in Gradle? Maybe I'm accidentally using an escape hatch?

Could also be confusing it with the gradle 9 "consumable/resolvable configuration" stuff.

I have a function like this:

```java
public void withDep(Configuration config, Object dep) {
    config.withDependencies(it -> it.add(project.getDependencies().create(dep)));
}
```

Calling it like `withDep(configuration1, configuration2)` does seem to make configuration 1 "depend on" configuration 2 just fine.

## Misc

IDEA's project model also has a third type of dependency (project to "jar/directory"), but it does not seem to be used when importing Gradle projects. Even depending on a jar with `project.files()` shows up as a "library" dependency.
