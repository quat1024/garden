# How do Neoforge installers work

My motivations are not entirely altruistic: through [Voldeloom](https://github.com/CrackedPolishedBlackstoneBricksMC/voldeloom) I learned that installing Forge 1.4-1.7 "like an end-user", instead of decompiling the game, is a practical and realistic way to get a simple modding moolchain going. Surely nothing has changed in ten years, right.

todo, peep [this](https://maven.neoforged.net/releases/net/neoforged/neoforge/21.5.75/neoforge-21.5.75-moddev-config.json) that i found while looking for the installer

we're gonna look at `net.neoforged:neoforge:21.5.75:installer`, aka [this jar](https://maven.neoforged.net/releases/net/neoforged/neoforge/21.5.75/neoforge-21.5.75-installer.jar). It's for 1.21.5

The main class is `net.minecraftforge.installer.SimpleInstaller`. If you pass `--install-client` or `--install-server` it will do that, otherwise if you're in a headless environment it will install the server, otherwise it will pop the GUI. There's also options to generate a "fat installer" with `--fat-installer`, with options `--fat-include-minecraft`, `--fat-include-minecraft-libs`, `--fat-include-installer-libs`, and `--fat-offline`. Could be neat.

It will attempt to install Let's Encrypt root certificates. They are bundled in the root of the jar in the file `lekeystore.jks` with password `supersecretpassword`. Lol.

## "install specs"

Installation specs are loaded from the `install_profile.json` file in the root of the jar. If `spec` is 0 you get an `Install`, otherwise you get an `InstallV1`. These are the instructions for how to install the jar / things to display in the GUI / things to copy into the vanilla launcher.

* `String profile` (e.g. "NeoForge")
* `String version` (e.g. "neoforge-21.5.75")
* `String icon` (base64 icon with mimetype, e.g. "data:image/png;base64,AAAAAAA")
* `String minecraft` (minecraft version, e.g. "1.21.5")
* `String json` (I think this is the path to a vanilla launcher profile json inside the jar? Not too familiar with the vanilla launcher honestly)
* `String logo` (path inside the jar to a logo, eg. "./big_logo.png")
* `Artifact path`
* `String urlIcon`
* `String welcome` (message to display in the gui, eg "Welcome to the simple NeoForge installer")
* `String mirrorList` (URL to obtain mirrors from, eg https://neoforged.net/mirrorlist.json )
* `boolean hideClient, hideServer, hideExtract`
* `Version.Library[] libraries` (looks like the exact same structure as the library type from piston-meta)
* `List<Processor> processors`
* `Map<String, DataFile> data`
* `Mirror mirror` (unset in this installer)
* and only in `InstallV1`, `String serverJarPath`

A `DataFile` has one key for `client` and another for `server`. It doesn't have to actually be a file path. Data files in this installer are `MAPPINGS`, `MOJMAPS`, `MERGED_MAPPINGS`, `BINPATCH`, `MC_UNPACKED`, `MC_SLIM`, `MC_EXTRA`, `MC_SRG`, `PATCHED`, and `MCP_VERSION`.

A `Processor` is a description of a JVM invocation. A Processor optionally contains a `List<String> sides` ("client" or "server"), an `Artifact` of the jar to run, a `List<Artifact>` of the jars to stick on the classpath, `String[] args`, and a `Map<String, String> outputs` which appears to be unused. If the `sides` is missing, the processor runs when installing any side.

No maven-style artifact resolution is attempted. The locations of all needed libraries are specified in `libraries` complete with a URL.

A `Mirror` is a `String name, image, homepage, url` and `boolean advertised`. If the mirror is `advertised`, a "Data kindly mirrored by `name` at `homepage`" message will be displayed.

## Action

Assuming the headless installer since the GUI doesn't interest me. After the install profile is parsed (`Util.loadInstallProfile` called from `SimpleInstaller#main`), the `Action` is invoked. The action was selected from the command line, so it can be `Actions.CLIENT`, `Actions.SERVER`, or `Actions.FAT_INSTALLER`.

### Fat installer

Makes a copy of the installer jar which includes the following goodies inside the zip:

* `maven/version_manifest.json`, downloaded straight off Mojang's server from `https://piston-meta.mojang.com/mc/game/version_manifest_v2.json`
* `maven/minecraft/<version>.json`, downloaded from Mojang's server with information found in the version_manifest file
* if `--fat-include-minecraft` was passed, `maven/minecraft/<version>/{client,server}.jar` and `maven/minecraft/<version>/{client,server}_mappings.txt` using information from that per-version manifest
* if `--fat-include-minecraft-libs` was passed, all of the libraries mentioned in the per-version manifest
* if `--fat-include-installer-libs` was passed, all of the libraries mentioned in the `libraries` block in the installer manifest, as well as a copy of `serverstarter.jar` downloaded fresh from `https://github.com/NeoForged/serverstarterjar/releases/latest/download/server.jar`
  * all these libs end up under `maven/` concatted with the `path` mentioned in the library json

If all three `--fat-include` options were passed, the installer copy also gets `Offline: true` set in MANIFEST.MF, which makes it act like `--offline` was passed all the time.

### Server installer

Okay, now getting into actual minecraft stuff. Handled by the `ServerInstall` class.

We have a `File target` which is the directory to install the server into, sometimes called the "root".

* if `{ROOT}` or `{ROOT}/libraries` doesn't exist, make it
* print the "Data kindly mirrored by" message if applicable
* if the vanilla server jar doesn't exist, download it by parsing piston_meta
  * the expected location is `{ROOT}/minecraft_server.{MINECRAFT_VERSION}.jar`
* download libraries (`Action#downloadLibraries`):
  * add `~/.m2/repository` as a mirror, if it exists (lol)
	* download each library, both minecraft libs and installer-profile libs, and build a tree under `{ROOT}/libraries` with em
	* there's a fancy system to check your local paths, the installer jar itself (for the fatjar), etc etc
* run each applicable *processor*:
  * this is worthy of a subsection
* finally if serverstarter was requested, grab it from github

### Client installer

Here the "target dir" is your vanilla launcher .minecraft directory expected to contain a `launcher_profiles.json` or `launcher_profiles_microsoft_store.json` file.

* `version.json` is extracted out of the jar and plonked in `{ROOT}/versions/neoforge-21.5.75/neoforge-21.5.75.json`
* look for the vanilla jar (first by guessing its path from your vanilla launcher dir, then by downloading it)
* Download libraries
* Run the processors
  * next section
* Fiddle with your `launcher_profiles.json` so the vanilla game sees the profile

Tl;dr doesn't do anything fancy like downloading assets, the vanilla launcher can handle that, and the real meat is handled by the processor system

## Processor system

Handled in `PostProcessors`

First the install manifest's `data` is modified. Here is a datamap excerpt to illustrate.

```json
"MOJMAPS": {
  "client": "[net.minecraft:client:1.21.5-20250325.162830:mappings@txt]",
  "server": "[net.minecraft:server:1.21.5-20250325.162830:mappings@txt]"
},
"BINPATCH": {
  "client": "/data/client.lzma",
  "server": "/data/server.lzma"
},
"MCP_VERSION": {
  "client": "'1.21.5-20250325.162830'",
  "server": "'1.21.5-20250325.162830'"
}
```

At install time this would get collapsed to a simple `Map<String, String>` depending on whether the client or server is being installed. Then:

* entries surrounded in square brackets get parsed as maven coordinates, and replaced with the location where that file *would* go if it was downloaded into the `libraries` dir. So the `[net.minecraft:client:1.21.5-20250325.162830:mappings@txt]` entry gets replaced with something like `<install root>/libraries/net/minecraft/client/1.21.5-20250325.162830/1.21.5-20250325.162830-mappings.txt`.
* unquoted entries refer to paths inside the installer jar, and that file is extracted to a temp directory; the datamap entry is replaced with the path to that file. the `/data/client.lzma` file gets extracted into a temp dir and its entry replaced with something like `<a temp dir on your system>/data/client.lzma`
* entries surrounded in single quotes simply have the single quotes stripped off. So the `'1.21.5-20250325.162830'` entry gets replaced with `1.21.5-20250325.162830` without the quotes

In practice: the only single-quote entry is the mcp version, the only extracted entry is the `data/<side>.lzma` file, and everything else is maven coordinates. I think most of the maven coordinates do not refer to real files either and they are created by further processors.

Finally the datamap is amended with a few extra entries:

* `SIDE` contains `"client"` or `"server"`
* `MINECRAFT_JAR` contains the path to the minecraft jar on the system
* `MINECRAFT_VERSION` contains the minecraft version
* `ROOT` contains the installation root directory
* `INSTALLER` contains the path to the installer jar
* `LIBRARY_DIR` contains the library directory (`{ROOT}/libraries` when installing the server)

These go alongside `MAPPINGS`, `MOJMAPS`, `MERGED_MAPPINGS`, `BINPATCH`, `MC_UNPACKED`, `MC_SLIM`, `MC_EXTRA`, `MC_SRG`, `PATCHED`, and `MCP_VERSION` from the installer manifest. Any argument to a processor invocation can substitute any of these variables.

TIME TO ACTUALLY PROCESS.

* Giant hack: If the processor to run is `installertools` and the args list has `--task` followed by `DOWNLOAD_MOJMAPS`, skip it if the mojmaps are already downloaded locally. (Worth mentioning that the fatjar installers were taped onto the system very recently.)
* Something about `outputs` that I don't really understand. I think the idea is that if a processor is expected to create a file at a certain location, that can be registered in `outputs` in the installer manifest json, and if the file already exists the processor will be skipped. This feature is not used by the installer though.
* Otherwise the processor jar is popped into a `URLClassLoader` and its `main` method is called with the given arguments after variable subbing

Just for reference, a sample processor json

```json
{
  "sides": [
    "server"
  ],
  "jar": "net.neoforged.installertools:jarsplitter:2.1.2",
  "classpath": [
    "net.neoforged.installertools:jarsplitter:2.1.2",
    "net.sf.jopt-simple:jopt-simple:5.0.4",
    "net.neoforged:srgutils:1.0.0",
    "net.neoforged.installertools:cli-utils:2.1.2"
  ],
  "args": [
    "--input",
    "{MC_UNPACKED}",
    "--slim",
    "{MC_SLIM}",
    "--extra",
    "{MC_EXTRA}",
    "--srg",
    "{MERGED_MAPPINGS}"
  ]
},
```

### The actual processors

These run top-to-bottom. I'll need to look at these closer. I have not reproduced all invocation arguments because there are a zillion

* On the server: [Installertools](https://github.com/neoforged/installertools) with `--task` [`EXTRACT_FILES`](https://github.com/neoforged/InstallerTools/blob/46f40cbc4eeb0098921b4f31182157d30467ae16/src/main/java/net/neoforged/installertools/ExtractFiles.java)
  * Pulls out `data/run.bat`, `data/run.sh` etc etc from the installer jar, chmods the shell scripts
* On the server: Installertools with `--task` [`BUNDLER_EXTRACT`](https://github.com/neoforged/InstallerTools/blob/46f40cbc4eeb0098921b4f31182157d30467ae16/src/main/java/net/neoforged/installertools/BundlerExtract.java)
  * Unbundles libraries from the server jar and puts them in `{ROOT}/libraries`
* On the server: Installertools with `--task` `BUNDLER_EXTRACT` `--jar-only`
  * Unbundles the server jar and puts it in `{MC_UNPACKED}`
* Installertools with `--task` [`MCP_DATA`](https://github.com/neoforged/InstallerTools/blob/46f40cbc4eeb0098921b4f31182157d30467ae16/src/main/java/net/neoforged/installertools/McpData.java) `--key` `mappings`
  * Processes (somehow) `[net.neoforged:neoform:1.21.5-20250325.162830@zip]` into `{MAPPINGS}`
* Installertools with `--task` [`DOWNLOAD_MOJMAPS`](https://github.com/neoforged/InstallerTools/blob/46f40cbc4eeb0098921b4f31182157d30467ae16/src/main/java/net/neoforged/installertools/DownloadMojmaps.java)
  * Downloads them to `{MOJMAPS}`
  * As mentioned before, hackily skipped if mojmaps are already downloaded
* Installertools with `--task` [`MERGE_MAPPING`](https://github.com/neoforged/InstallerTools/blob/46f40cbc4eeb0098921b4f31182157d30467ae16/src/main/java/net/neoforged/installertools/MergeMappings.java) `--left` `{MAPPINGS}` `--right` `{MOJMAPS}` `--output` `{MERGED_MAPPINGS}` `--classes` `--fields` `--methods` `--reverse-right`
  * Very incheresting
* [Jarsplitter](https://github.com/neoforged/InstallerTools/tree/main/jarsplitter)
  * On the client the input is `{MINECRAFT_JAR}` and on the server it's `{MC_UNPACKED}`
  * looks like it populates `{MC_SLIM}` and `{MC_EXTRA}`
	* Also takes mappings as input; if a class exists on the "`getOriginal()`" side of anything in the mappings, it goes in `MC_EXTRA`, otherwise it goes in `MC_SLIM`
	* TODO run the installer and characterize these classes
* [AutoRenamingTool](https://github.com/neoforged/autorenamingtool)
  * Input is MC_SLIM, output is MC_SRG, uses MERGED_MAPPINGS.
	* Args used: `--ann-fix`, `--ids-fix`, `--src-fix`, `--record-fix`.
	* ART is their `tiny-remapper`like program
* [Binarypatcher](https://github.com/neoforged/InstallerTools/tree/main/binarypatcher)
  * Applies the `<side>.lzma` file and puts the result in `{PATCHED}`

`EXTRACT_FILES` is a little strange, really feels like the installer should do that itself.

Jarsplitter means that ART and binarypatcher don't have to carry dead weight like images and json files, or remap classes that don't need remapping.

### And that's the end of the installer

tada

