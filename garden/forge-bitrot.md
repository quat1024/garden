# Forge, Bitrot, and You; or, The `e04c5335922c5e457f0a7cd62c93c4a7f699f829` Problem

Minecraft Forge needs several third-party libraries and a few data files to run. When creating Forge for 1.3, 1.4, and 1.5, the Forge developers made the choice to not include all of these dependencies in the primary Forge installation. Instead, they are downloaded from Forge's web servers the first time you launch the game.

This has now become a problem, since Forge no longer hosts these twelve-year-old files on their web server, and the downloader encounters other problems attempting to download them. (You might see error messages mentioning the string "`e04c5335922c5e457f0a7cd62c93c4a7f699f829`".)

But it's not all bad news. There are several ways to get Forge the files it wants to download, and the folks at [Prism Launcher](https://prismlauncher.org/) maintain a mirror of all relevant files.

## Workaround 1: Just use Prism Launcher

You don't *have* to use Prism Launcher. But it's very good at launching old versions of the game, and if you create a Forge 1.3, 1.4, or 1.5 instance it will automatically download the files from their mirror before launching the game. You don't have to do a thing.

## Workaround 2: Pass a Java argument (1.5 only)

In Forge for 1.5, you can change the URL Forge contacts by passing a Java argument. Sadly this feature does *not* exist in Forge for 1.3 or 1.4.

To do this, add

```
-Dfml.core.libraries.mirror=https://files.prismlauncher.org/fmllibs/%s
```

to your game's Java arguments, then launch the game. This will make Forge contact Prism's mirror instead of its broken URL and the files should download successfully. After the files are downloaded you don't need to keep this argument, but it doesn't hurt anything.

The process for setting Java arguments is different across different launchers. Sorry, I don't know how all the launchers work.

## Workaround 3: Get the files yourself

If the files are already on your PC in the location Forge expects to find them, Forge will think it already downloaded the files, and will not attempt to contact the dead web server. All you need to do is track down copies of the files Forge is trying to download and put them in the correct location.

### Download the files

You can use Prism Launcher's mirror service to download the files Forge expects to find. Here are some links to all the relevant files on Prism's mirror.

#### 1.3.2

Forge for 1.3.2 needs three files.

* `argo-2.25.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/argo-2.25.jar
  * Hash: `bb672829fde76cb163004752b86b0484bd0a7f4b`
* `guava-12.0.1.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/guava-12.0.1.jar
	* Hash: `b8e78b9af7bf45900e14c6f958486b6ca682195f`
* `asm-all-4.0.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/asm-all-4.0.jar
	* Hash: `98308890597acb64047f7e896638e0d98753ae82`

#### 1.4.x

Forge for Minecraft 1.4.x needs four files: **the same files as Forge for 1.3.2, *plus*** this file.

* `bcprov-jdk15on-147.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/bcprov-jdk15on-147.jar
	* Hash: `b6f5d9926b0afbde9f4dbe3db88c5247be7794bb`

#### 1.5.2

Forge for Minecraft 1.5.2 needs six files.

* `argo-small-3.2.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/argo-small-3.2.jar
	* Hash: `58912ea2858d168c50781f956fa5b59f0f7c6b51`
* `guava-14.0-rc3.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/guava-14.0-rc3.jar
	* Hash: `931ae21fa8014c3ce686aaa621eae565fefb1a6a`
* `asm-all-4.1.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/asm-all-4.1.jar
	* Hash: `054986e962b88d8660ae4566475658469595ef58`
* `bcprov-jdk15on-148.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/bcprov-jdk15on-148.jar
	* Hash: `960dea7c9181ba0b17e8bab0c06a43f0a5f04e65`
* `scala-library.jar`
	* Mirror: https://files.prismlauncher.org/fmllibs/scala-library.jar
	* Hash: `458d046151ad179c85429ed7420ffb1eaf6ddf85`
* `deobfuscation_data_1.5.2.zip`
	* Mirror: https://files.prismlauncher.org/fmllibs/deobfuscation_data_1.5.2.zip
	* Hash: `446e55cd986582c70fcf12cb27bc00114c5adfd9`

```{=html}
<details><summary>Historical information (click to expand)</summary>
```

#### 1.5.0

Instead of `deobfuscation_data_1.5.2.zip`, get this file for 1.5.0 Forge:

* `deobfuscation_data_1.5.zip`
	* Mirror: https://files.prismlauncher.org/fmllibs/deobfuscation_data_1.5.zip
	* Hash: `5f7c142d53776f16304c0bbe10542014abad6af8`

The other five files are the same.

#### 1.5.1

Instead of `deobfuscation_data_1.5.2.zip`, get this file for 1.5.1 Forge:

* `deobfuscation_data_1.5.1.zip`
	* Mirror: https://files.prismlauncher.org/fmllibs/deobfuscation_data_1.5.1.zip
	* Hash: `22e221a0d89516c1f721d6cab056a7e37471d0a6`

The other five files are the same.

```{=html}
</details>
```

I've included the SHA-1 hash of each file since it shows up in Forge's error reports. This information is harvested from the [Prism Launcher source code](https://github.com/PrismLauncher/PrismLauncher/blob/d68269eca837df08a59a0997177ed460eb9df69a/launcher/minecraft/VersionFilterData.cpp).

### Find your `.minecraft` folder

For Windows users, this is probably in `C:/Users/` *&lt;your username&gt;* `/AppData/Roaming/.minecraft/`. You can quickly navigate nearby by typing `%APPDATA%` into the address bar of Windows Explorer.

Any launcher advertising "multiple instances" (like Prism, MultiMC, whatever) probably doesn't use this global `.minecraft` folder; consult your launcher's documentation.

### Place the files in the correct location

In your `.minecraft` folder, make a folder called `lib` if one does not already exist, and move the files you downloaded into that folder.

Make sure to keep the same filenames so Forge knows which is which. For example, if you downloaded a file from `https://files.prismlauncher.org/fmllibs/`**`argo-2.25.jar`**, it should go in `.minecraft/lib/`**`argo-2.25.jar`** without renaming it.

### That's it

Next time you launch Forge, it should notice these files have already been downloaded, and will not attempt to use its now-broken downloader.

## Appendix A: Manually finding which files to download

In your `.minecraft` folder, look for a file named `ForgeModLoader-client-0.log`. It might have a different name depending on the Forge version. Open this file with a text editor like Notepad.

```{=html}
<details><summary>Here is a sample of what the log might look like, from the last time I tried to run Forge 1.4.7 (click to expand)</summary>
```

```
2022-12-27 19:34:23 [INFO] [ForgeModLoader] Forge Mod Loader version 4.7.35.556 for Minecraft 1.4.7 loading
2022-12-27 19:34:23 [FINEST] [ForgeModLoader] All core mods are successfully located
2022-12-27 19:34:23 [FINEST] [ForgeModLoader] Discovering coremods
2022-12-27 19:34:23 [FINEST] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/argo-2.25.jar
2022-12-27 19:34:23 [INFO] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/argo-2.25.jar
2022-12-27 19:34:24 [FINEST] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/guava-12.0.1.jar
2022-12-27 19:34:24 [INFO] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/guava-12.0.1.jar
2022-12-27 19:34:24 [FINEST] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/asm-all-4.0.jar
2022-12-27 19:34:24 [INFO] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/asm-all-4.0.jar
2022-12-27 19:34:24 [FINEST] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/bcprov-jdk15on-147.jar
2022-12-27 19:34:24 [INFO] [ForgeModLoader] Downloading file http://files.minecraftforge.net/fmllibs/bcprov-jdk15on-147.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] There were errors during initial FML setup. Some files failed to download or were otherwise corrupted. You will need to manually obtain the following files from these download links and ensure your lib directory is clean. 
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/argo-2.25.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/guava-12.0.1.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/asm-all-4.0.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/bcprov-jdk15on-147.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] <===========>
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The following is the errors that caused the setup to fail. They may help you diagnose and resolve the issue
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The downloaded file argo-2.25.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting bb672829fde76cb163004752b86b0484bd0a7f4b). The download did not succeed correctly and the file has been deleted. Please try launching again.
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The downloaded file guava-12.0.1.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting b8e78b9af7bf45900e14c6f958486b6ca682195f). The download did not succeed correctly and the file has been deleted. Please try launching again.
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The downloaded file asm-all-4.0.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting 98308890597acb64047f7e896638e0d98753ae82). The download did not succeed correctly and the file has been deleted. Please try launching again.
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The downloaded file bcprov-jdk15on-147.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting b6f5d9926b0afbde9f4dbe3db88c5247be7794bb). The download did not succeed correctly and the file has been deleted. Please try launching again.
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] <<< ==== >>>
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] The following is diagnostic information for developers to review.
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] Error details
java.lang.RuntimeException: The downloaded file argo-2.25.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting bb672829fde76cb163004752b86b0484bd0a7f4b). The download did not succeed correctly and the file has been deleted. Please try launching again.
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.performDownload(RelaunchLibraryManager.java:548)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.downloadFile(RelaunchLibraryManager.java:467)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.handleLaunch(RelaunchLibraryManager.java:132)
	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:155)
	at cpw.mods.fml.relauncher.FMLRelauncher.relaunchClient(FMLRelauncher.java:92)
	at cpw.mods.fml.relauncher.FMLRelauncher.handleClientRelaunch(FMLRelauncher.java:26)
	at net.minecraft.client.Minecraft.main(Minecraft.java:2243)
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] Error details
java.lang.RuntimeException: The downloaded file guava-12.0.1.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting b8e78b9af7bf45900e14c6f958486b6ca682195f). The download did not succeed correctly and the file has been deleted. Please try launching again.
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.performDownload(RelaunchLibraryManager.java:548)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.downloadFile(RelaunchLibraryManager.java:467)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.handleLaunch(RelaunchLibraryManager.java:132)
	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:155)
	at cpw.mods.fml.relauncher.FMLRelauncher.relaunchClient(FMLRelauncher.java:92)
	at cpw.mods.fml.relauncher.FMLRelauncher.handleClientRelaunch(FMLRelauncher.java:26)
	at net.minecraft.client.Minecraft.main(Minecraft.java:2243)
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] Error details
java.lang.RuntimeException: The downloaded file asm-all-4.0.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting 98308890597acb64047f7e896638e0d98753ae82). The download did not succeed correctly and the file has been deleted. Please try launching again.
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.performDownload(RelaunchLibraryManager.java:548)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.downloadFile(RelaunchLibraryManager.java:467)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.handleLaunch(RelaunchLibraryManager.java:132)
	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:155)
	at cpw.mods.fml.relauncher.FMLRelauncher.relaunchClient(FMLRelauncher.java:92)
	at cpw.mods.fml.relauncher.FMLRelauncher.handleClientRelaunch(FMLRelauncher.java:26)
	at net.minecraft.client.Minecraft.main(Minecraft.java:2243)
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] Error details
java.lang.RuntimeException: The downloaded file bcprov-jdk15on-147.jar has an invalid checksum e04c5335922c5e457f0a7cd62c93c4a7f699f829 (expecting b6f5d9926b0afbde9f4dbe3db88c5247be7794bb). The download did not succeed correctly and the file has been deleted. Please try launching again.
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.performDownload(RelaunchLibraryManager.java:548)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.downloadFile(RelaunchLibraryManager.java:467)
	at cpw.mods.fml.relauncher.RelaunchLibraryManager.handleLaunch(RelaunchLibraryManager.java:132)
	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:155)
	at cpw.mods.fml.relauncher.FMLRelauncher.relaunchClient(FMLRelauncher.java:92)
	at cpw.mods.fml.relauncher.FMLRelauncher.handleClientRelaunch(FMLRelauncher.java:26)
	at net.minecraft.client.Minecraft.main(Minecraft.java:2243)
2022-12-27 19:34:26 [INFO] [STDERR] Exception in thread "main" java.lang.RuntimeException: java.lang.RuntimeException: A fatal error occured and FML cannot continue
2022-12-27 19:34:26 [INFO] [STDERR] 	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:175)
2022-12-27 19:34:26 [INFO] [STDERR] 	at cpw.mods.fml.relauncher.FMLRelauncher.relaunchClient(FMLRelauncher.java:92)
2022-12-27 19:34:26 [INFO] [STDERR] 	at cpw.mods.fml.relauncher.FMLRelauncher.handleClientRelaunch(FMLRelauncher.java:26)
2022-12-27 19:34:26 [INFO] [STDERR] 	at net.minecraft.client.Minecraft.main(Minecraft.java:2243)
2022-12-27 19:34:26 [INFO] [STDERR] Caused by: java.lang.RuntimeException: A fatal error occured and FML cannot continue
2022-12-27 19:34:26 [INFO] [STDERR] 	at cpw.mods.fml.relauncher.RelaunchLibraryManager.handleLaunch(RelaunchLibraryManager.java:228)
2022-12-27 19:34:26 [INFO] [STDERR] 	at cpw.mods.fml.relauncher.FMLRelauncher.setupHome(FMLRelauncher.java:155)
2022-12-27 19:34:26 [INFO] [STDERR] 	... 3 more
```

```{=html}
</details>
```

Look for the lines marked with `***`. Here are the lines from the above log.

```
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/argo-2.25.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/guava-12.0.1.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/asm-all-4.0.jar
2022-12-27 19:34:24 [SEVERE] [ForgeModLoader] *** Download http://files.minecraftforge.net/fmllibs/bcprov-jdk15on-147.jar
```

To use Prism's mirror instead of the broken Forge web server, simply replace `http://files.minecraftforge.net` with `https://files.prismlauncher.org`. In this example, I would be left with these URLs:

```
https://files.prismlauncher.org/fmllibs/argo-2.25.jar
https://files.prismlauncher.org/fmllibs/guava-12.0.1.jar
https://files.prismlauncher.org/fmllibs/asm-all-4.0.jar
https://files.prismlauncher.org/fmllibs/bcprov-jdk15on-147.jar
```

You can now paste these URLs into your Web browser to download them.

If you cannot use the Prism mirror, you can also try [pasting the `files.minecraftforge.net` URLs into the Internet Archive Wayback Machine](https://web.archive.org/web/20150601000000*/http://files.minecraftforge.net/fmllibs/argo-2.25.jar). Make sure to pick a suitable year on the calendar, like 2015.

## Appendix B: Trivia

The `e04c5335922c5e457f0a7cd62c93c4a7f699f829` string in question is the SHA-1 hash of "`Moved Permanently`". Forge attempts to download the data files over `http://` URLs, and the web server is *trying* to redirect to a more secure `https://` URL, but the downloader Forge uses does not follow redirects and treats *the body of the 302 error* as the file it's trying to download.

This is moot; even if the downloader *did* follow redirects, the URLs are still 404 errors.

## Appendix C: Mod development environments

If you are *developing* mods for 1.3/1.4/1.5, the Gradle-based toolchain [voldeloom](https://codeberg.org/CrackedPolishedBlackstoneBricksMC/voldeloom/) that I contribute to takes care of the library downloads using a task called `shimForgeLibraries` on 1.3 and 1.4, and by setting the `fml.core.libraries.mirror` property on 1.5. Reverse-engineering Forge for this project is how I learned about the `fml.core.libraries.mirror` argument.

## Appendix D: Wait a minute, what launcher are you using anyway?

So you might have came to this page from a search engine. If you did, *please* email me and tell me what launcher you are using that requires you to manually fix this problem.

I am just curious -- I don't *think* the official Forge installers work on Mojang's launcher anymore, and the only other launchers I know of capable of launching old versions of the game are the ones sharing Prism's lineage (including MultiMC), which already solve this problem for you.
