# Versions For Things

Because I have the memory of a goldfish.

Yeah the CSS on these tables is ass, I will fix it later.

## Class formats

|Java version| Class format |
|-----------:|:-------------|
|8|52|
|16|60|
|17|61|
|21|65|

A mnemonic (which is at least true for Java 5 thru 24): take the Java version and add 44, that's the class format version.

More at [this stackoverflow answer](https://stackoverflow.com/questions/9170832/list-of-java-class-file-format-major-version-numbers), which people seem to update when new versions of Java come out, and [this part of the Java specification](https://docs.oracle.com/javase/specs/jvms/se24/html/jvms-4.html#jvms-4.1-200-B.2).

## Compiler version supprt

|`javac` version|Lower limit|Upper limit|Note|
|--------------:|:----------|:----------|:---|
|8|`-source 1.1 -target 1.1` |`-source 8 -target 8`|Also against Java 6 with `-source 6 -target 6`|
|11|`--release 6`|`--release 11`|Latest version which supports Java 6|
|17|`--release 8`|`--release 17`||
|21|`--release 8`|`--release 21`||

Java 9 added the `--release X` flag. Anything older requires `-source X -target X`.

Since at least java 11, valid options for `--release` are visible in `javac -help`.

[On-line documentation](https://docs.oracle.com/en/java/javase/21/docs/specs/man/javac.html#option-release) for modern-ish versions simply says "The supported values of *release* are the current Java SE release and a limited number of previous releases, detailed in the command-line help." As of `javac 21.0.5`, support for any version of Java later than 8 has *not* been dropped; all `--release`s between 8 and 21 are accepted.

## Minecraft Java versions

|Game version|Java version|Note|
|-----------:|:-----------|:---|
|1.21.5 | Java 21 | Fabric wants Java 21 already in 1.21.1 |
|1.18.0 | Java 17 ||
|1.17.0 | Java 16 | Most people use Java 17 |
|1.12.0 | Java 8 ||
|Older versions | Java 5/6 | In the modded ecosystem, Java 8 is safe to assume as far back as 1.7.10 |

Versions of Forge for versions until *partway through 1.7.10* crash on classes compiled for Java 8; you really do need to use a Java 6-compatible compiler. (As in: The last version of Forge for 1.7.10 supports Java 8, but the first version did not.)

There are some True Sickos who get Java 21 running on old versions of the game, too.

## Minecraft tooling versions

* Fabric Loom: https://maven.fabricmc.net/fabric-loom/fabric-loom.gradle.plugin/
	* They don't seem to publish a changelog
	* Fabric Loom 1.10.x requires Java 17, or Java 21 if targeting Minecraft 1.21 (for some reason)
	* Fabric Loom 1.11+ [requires Java 21](https://github.com/FabricMC/fabric-loom/pull/1299) and will support Gradle 9
* ModDevGradle: https://projects.neoforged.net/neoforged/ModDevGradle
	* `2.0.94` is the first version to support Gradle 9 apparently
* ForgeGradle 6: https://files.minecraftforge.net/net/minecraftforge/gradle/ForgeGradle/index.html
	* `6.0.31` is the first version to support Gradle 8.13
	* `6.0.26` is the first version to support Gradle 8.9
	* `6.0.16` is the first version to support Gradle 8.4
* ForgeGradle 5: latest version is `5.1.76`
	* Does not work on Gradle 8

If you can believe it, I suck at remembering the version numbers for my own plugins:

* voldeloom: https://repo.sleeping.town/agency/highlysuspect/voldeloom/
* minivan: https://repo.sleeping.town/agency/highlysuspect/minivan/
* crossroad: https://repo.sleeping.town/agency/highlysuspect/crossroad/

TODO, fill in more details about which versions of which tools work on which Gradle versions and which Java versions...

## `pack_format`

https://minecraft.wiki/w/Pack_format

Common modding versions:

|Game version |Resource pack format|Data pack format|
|------------:|:-------------------|:---------------|
| 1.12.2 | 3  | - |
| 1.16.5 | 6  | 6 |
| 1.18.2 | 8  | 9 |
| 1.19.2 | 9  | 10 |
| 1.19.4 | 13 | 12 |
| 1.20.1 | 15 | 15 |
| 1.20.5 | 32 | 41 |
| 1.21.1 | 34 | 48 |
| 1.21.5 | 55 | 71 |

Mods end up sharing `pack.mcmeta` across the resource and data pack just due to how modloaders load the mod jar as a resourcepack and a datapack. Forge, from 1.18 through 1.20.1 (and maybe later but who cares right), had a [split `pack_format`](https://github.com/MinecraftForge/MinecraftForge/pull/8612) thing for the pedants; neoforge has apparently [removed the requirement to add `pack.mcmeta` in the first place](https://docs.neoforged.net/docs/resources/#packmcmeta). But all versions accept `"pack_format": 99999` :)