# Syncthing

Basically as of mid-2025, the Syncthing Situation is Crazy™.

* There was this program called Synctrayzor but it fell into disrepair
* The main Android syncthing app fell into disrepair
* Syncthing is nearing completion of version 2, which is going to break-for-good a lot of these old programs

Trying to make sense of it all...

## Structure

If you download a Syncthing executable [from the bottom of the page here](https://syncthing.net/downloads/) and double-click it, it will perform file synchronization tasks and host a configuration webapp at http://localhost:8384/ . This binary is available for basically all operating systems. It will Just Work.
 
However, Syncthing doesn't come with any deeper integration into the operating system, such as "running in the background without a console window", "automatically starting at boot", or "a handy little tray icon". These things are maintained by separate people in separate projects.

The rub: installing two separate moving parts can be annoying, so some of these OS-integration programs *also* manage their own copy of Syncthing...

## Windows

There are two "Windows integrations" programs I'm aware of for Syncthing on Windows:

* [Syncthing Windows Setup](https://github.com/Bill-Stewart/SyncthingWindowsSetup/) by Bill Stewart
  * Automatically starts syncthing when you log on
  * Adds Start menu entries to start/stop syncthing and open the configuration GUI
  * Helps you configure the windows firewall
* [Syncthing Tray](https://martchus.github.io/syncthingtray/) by Martchus
  * Automatically starts syncthing when you log on
  * Adds a tray icon you can use to manage syncthing
  * Adds context menu icons to do... something (maybe only on Linux?)
  * Adds system notifications when Syncthing tasks complete

I'll try both and report back...

### Syncthing Windows Setup

* It will download and install the official `syncthing.exe` for you, into a folder of your choosing.
* It will create a Windows scheduled task to start Syncthing when you log in.
* It creates Start menu shortcuts to start, stop, and open the config page in a browser.

That's it really. In the installer there's a config page where you can set the auto-upgrade interval, details about the configuration UI, etc; no need to change any of that stuff.

Overall I like this option. You install it and it works, no fuss. Appealing how it has few "moving parts" other than the official Syncthing program. N.B.: You might have to [click through a warning about self-signed certs](https://github.com/Bill-Stewart/SyncthingWindowsSetup/issues/66) the first time you use the "Syncthing Configuration Page" shortcut.

### Syncthingtray

Much more heavyweight program.

Setup can be a bit confusing because there are three options about how it relates to Syncthing:

* it can launch and connect to a builtin copy of Syncthing
* it can launch and connect to a version of Syncthing that you download separately
* it can connect to a version of Syncthing that you manage yourself

I don't see any shell extension / right-click context menu stuff, at least not on Windows when installed via Scoop.

### Migrating off synctrayzor

* Close Synctrayzor (right click tray icon -> quit)
* Dig up the synctrayzor installation directory (for me this was `C:/Users/quat/scoop/apps/synctrayzor/current` since im a [scoop](https://scoop.sh/)er)
* Click on the `data` folder
* Copy the entire `syncthing` folder to a safe place
  * Note that Synctrayzor keeps its config file in `data/config.xml`. This won't be needed.
  * You only need to back up `data/syncthing/`.

Then paste this over the configuration folder of another installation. For Syncthing Windows Setup, Syncthingtray, and `syncthing.exe` it looks like the magic directory is `%LOCALAPPDATA%/Syncthing`.

Syncthingtray users then need to right-click the tray icon, Settings, Tray, and press "Insert values from local Syncthing configuration". This will update the API key to match the API key from the backup and fix Syncthingtray's ability to control Syncthing.

## Android

I think the good one is [Syncthing-Fork by catfriend1](https://f-droid.org/en/packages/com.github.catfriend1.syncthingandroid/). Yes, it's only on F-Droid / github releases and not the Google Play Store; I think google was being annoying to the developer and requiring them to remove certain features(?).

It just kinda works?

By default I noticed it set up Camera folder as a syncthing folder; you can choose to share it with other devices or simply remove the syncthing folder.