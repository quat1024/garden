# Running a modpack on a server

## 0. Is there a server pack?

First, check to see if the modpack provides a "server pack". On CurseForge, they can be found under "Additional Files". [Here's an example](https://www.curseforge.com/minecraft/modpacks/raspberry-flavoured/files/6526594/additional-files).

Download the server pack and unzip it to a new folder on your Minecraft server. Follow the instructions inside the server pack, if any were provided. Otherwise, if a start script is provided (some kind of `.bat` or `.sh`), run that; if there's no script, there will be a jar you can run with `java -jar`.

If there is no server pack, you'll need to create one yourself.

## 1. Download the modpack with a launcher

If you try to download a modpack from CurseForge with the "download" button, you will find a zip containing `manifest.json` and an `overrides` folder. You can't do anything with these files directly. These files are for your modded Minecraft *launcher*. Just open the CurseForge launcher, or Prism Launcher, or Modrinth, or whatever and download the modpack normally through its interface, as if you were going to play singleplayer.

Your launcher will download all the files mentioned in `manifest.json` and assemble a copy of the modpack on your computer.

## 2. Make sure Java is installed on your server

On your dedicated server, make sure [the appropriate version of Java](versions) is available.

## 3. Create a clean Fabric/Neoforge installation on your server

On your dedicated server, create a folder dedicated to your Minecraft server.

* **fabric:** Download the [Minecraft Server Launcher](https://fabricmc.net/use/server/) and put it in this folder.
* **neoforge:** Download the [NeoForge installer](https://neoforged.net/), put it in this folder, and run it with `java -jar`.
* **forge:** Download the [Forge installer](https://files.minecraftforge.net/net/minecraftforge/forge/index_1.20.1.html), put it in this folder, and run it with `java -jar`.

You *probably* don't have to grab *exactly* the same version of Fabric/Neoforge/etc that the modpack uses, but it won't hurt.

Now, run the server once. On Fabric, this is when you'd run the Minecraft Server Launcher with `java -jar`. On NeoForge, after running the installer you'll have a `.bat` or `.sh` script you can use.

Why start the server *now*?

* It gives modloaders a chance to do their first-run tasks and create empty `mods`/`config` directories.
* It gives Minecraft a chance to create `server.properties` and the EULA file.
* It gives you a chance to decide whether you agree with the EULA, configure `server.properties`, and test that everything is working before installing >100 mods and massively bogging down the server's startup time. If you want to test connecting to the server, do it with a vanilla client.

## 4. Copy the modpack from your client to the server

Go back to your launcher, and copypaste all of the modpack's files from your client to the dedicated server.

You'll want to merge them together. For example, the contents of the `mods` folder on your client should get placed in the `mods` folder on the server.

When in doubt, just copy it to the server. In the past, you may have been required to comb through and delete any client-only mods from the server's `mods` folder, because they would crash when launched on the server. This shouldn't be a problem with well-coded client mods nowadays.

## 5. Start the server again

Start the modded Minecraft server using the same command you used in step 3. If all goes well, you should see a lot more log messages as all of the mods initialize, and you should be able to connect from your modded client.

# More things to explore

TODO: test these out to see how much easier/harder they are

* **Assemble the server pack on your computer first**. Basically run the fabric/neo installer on your PC, copy the modpack files in, then transfer the whole bundle to your dedicated server. Kinda worried about OS differences though, like, does the neo installer copy different files when it is ran on PC vs Linux? I imagine a popular setup is a Windows client connecting to a Linux server
* **ServerPackCreator**. Looks like [a nice tool](https://github.com/Griefed/ServerPackCreator) to create server packs. Seems quite fancy, and geared toward modpack authors wanting to build a server pack for their own players to download. But you could probably download a pack using the curseforge launcher and then run ServerPackCreator on the result.
* **Standalone downloader tools like Packwiz**. [This redditor](https://old.reddit.com/r/feedthebeast/comments/1m9s2qx/generic_installing_a_modpack_on_linux/n5acpbv/) was able to find success using [Packwiz](https://packwiz.infra.link/). In my mind packwiz is categorized alongside tools for *authoring* modpacks, not really for end-users to download them, but if it works it works!

See also comp500's ["big list of modpack things"](https://gist.github.com/comp500/13ae6f058221196077fb19953ac608c7), although most of these are for modpack authors as well