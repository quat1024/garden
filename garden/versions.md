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
|1.20.5 | Java 21 ||
|1.18.0 | Java 17 ||
|1.17.0 | Java 16 | Most people use Java 17 |
|1.12.0 | Java 8 ||
|Older versions | Java 5/6 | In the modded ecosystem, Java 8 is safe to assume as far back as 1.7.10 |

Versions of Forge for versions until *partway through 1.7.10* crash on classes compiled for Java 8; you really do need to use a Java 6-compatible compiler. (As in: The last version of Forge for 1.7.10 supports Java 8, but the first version did not, and versions of Forge for 1.6- all crash.)

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

## Fabric versions

This site will be more up-to-date https://fabricmc.net/develop/ but these should be good-enough for your build gradles.

|Game version|Fabric API version|Yarn version|
|-----------:|:-----------------|:-----------|
|1.16.5|`0.42.0+1.16`|`1.16.5+build.10`|
|1.18.2|`0.77.0+1.18.2`|`1.18.2+build.4`|
|1.19.2|`0.77.0+1.19.2`|`1.19.2+build.28`|
|1.19.4|`0.87.2+1.19.4`|`1.19.4+build.2`|
|1.20.1|`0.92.6+1.20.1`|`1.20.1+build.10`|
|1.20.5|`0.97.8+1.20.5`|`1.20.5+build.1`|
|1.21.1|`0.116.4+1.21.1`|`1.21.1+build.3`|
|1.21.5|`0.128.1+1.21.5`|`1.21.5+build.1`|

The same version of Fabric Loader works on all minecraft versions. At the time of writing, the latest version is `0.16.14`.

```groovy
dependencies {
	minecraft "com.mojang:minecraft: <minecraft version> "
	mappings "net.fabricmc:yarn: <loom version> :v2"
	modImplementation "net.fabricmc:fabric-loader: <fabric loader version> "
	modImplementation "net.fabricmc.fabric-api:fabric-api: <fabric api version> "
	
	//or this, for official names
	mappings loom.officialMojangMappings()
}
```

Double-check `fabric-loader` is in `modImplementation`, not just `implementation`, or you will crash during `runClient` with an obscure error.

## Forge versions

```groovy
dependencies {
	minecraft "net.minecraftforge:forge: <forge version>"
}
```

|Game version|Forge version|
|-----------:|:------------|
|1.3.2|`1.3.2-4.3.5.318`|
|1.4.7|`1.4.7-6.6.2.534`|
|1.5.2|`1.5.2-7.8.1.738`|
|1.6.4|`1.6.4-9.11.1.1345`|
|1.7.10|`1.7.10-10.13.4.1614-1.7.10`|
|1.12.2|`1.12.2-14.23.5.2860`|
|1.16.5|`1.16.5-36.2.42`|
|1.18.2|`1.18.2-40.3.10`|
|1.19.2|`1.19.2-43.5.0`|
|1.19.4|`1.19.4-45.4.0`|
|1.20.1|`1.20.1-47.4.3`, Neoforge fork point at `1.20.1-47.1.3`|
|Newer|Neoforge|

Yes 1.7.10 includes the Minecraft version number twice.

### Voldeloom info

1.3 thru 1.5:

```groovy
forge "net.minecraftforge:forge:${forgeVersion}:universal@zip"
mappings "net.minecraftforge:forge:${forgeVersion}:src@zip"
```

1.6.4 no longer needs `@zip` on the `:universal` artifact.

```groovy
forge "net.minecraftforge:forge:${forgeVersion}:universal"
mappings "net.minecraftforge:forge:${forgeVersion}:src@zip"
```

For 1.7.10, I'd say it's best to use MCPBot mappings if you're making a greenfield project.

```groovy
forge "net.minecraftforge:forge:${forgeVersion}:universal"
mappings volde.layered {
	importMCPBot("https://mcpbot.unascribed.com/", minecraftVersion, "stable", "12-1.7.10")
}
```

If you need compatibility with other toolchains (such as, I've heard, RetroFuturaGradle), since Voldeloom 2.5 the less-complete Forge userdev mappings are supported.

```groovy
mappings "net.minecraftforge:forge:${forgeVersion}:userdev"
```

## Neoforge versions

ModDevGradle parses the Minecraft version out of Neoforge's contents, so there is no need to separately set the minecraft version. In ModDevGradle you set the NeoForge version like this:

```groovy
neoForge {
  	version = " <neoforge version> "
}
```

|Game version|Neoforge version|
|-----------:|:------------|
|1.21.1|`21.1.186`|
|1.21.5|`21.5.81`|
|Newer|check [homepage](https://neoforged.net/) or [projects list](https://projects.neoforged.net/neoforged/neoforge) |

Also they're still supporting 1.21.1 so this page will get out-of-date quick.

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
