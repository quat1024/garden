# Linux

I should have done this sooner. Windows 10 support ending is probably a good time as any.

I *thought* I liked computer-tinkering but kept bouncing off the nerd linux distros because they needed too much tinkering. So I went for Linux Mint as something more complete out-of-the-box.

I'm going to install it on my **Dell XPS 15 9560** laptop. I think that's the model name anyway.

> n.b. I'm going with dualboot for now in case Linux doesn't work out or in case I need to use Windows-only software (the school semester is starting soon). This isn't an ideal setup because if I decide to fully use Linux, the linux partition will be located on the second half of the disk and I can't extend it backwards (...right?). Part of why I'm obsessively writing down everything is so that, in case I need to reinstall Linux, I will know what I did to the system.

## Shrinking the Windows partition

To start, I deleted a bunch of old files. I use scoop package manager so `scoop cleanup *` removed old versions of programs. Also installed wiztree and looked around for any large files I forgot about, which prompted me to uninstall some games I haven't played in a while.

In total my Windows install consumes about 310gb off the 1tb SSD this laptop has, and that includes some goodies like the hibernation file, the Mint installer iso, and some files like images and music that I don't need to keep on the windows install.

Windows loves to put non-movable files at the end of its partitions so you can't shrink them. I had to disable and delete restore points (search "restore point" in start menu -> System Protection tab -> Configure -> Disable System Protection, and press Delete to remove the existing files) before Disk Management would allow shrinking the Windows partition. They can be turned back on after shrinking the partition, but tbh I've never used a restore point before.

In all, my system ssd had:

* 500mb unallocated space at the start (hm?)
* 500mb EFI System Partition
* 942.7gb allocated to Windows, showing as C
* A 9gb mystery partition
* A 1.06gb mystery partition
* 10mb unallocated space at the end

Some of the unallocated space *might* be slack to keep an SDD happy?

I went ahead and deleted the mystery partitions. Now that I think about it, might have been OEM factory troubleshooting stuff? Oh well!!!

I've also heard that leaving some unallocated space on an SSD can make them happier but I've also heard that's an urban legend, so maybe i'll keep a gig or two blank.

The new plan:

* leave the unallocated start space & the EFI system partition intact
* shrink Windows to 500gb
* allocate the rest to linux

You can't create linux filesystem partitions in Windows Disk Management, so I'm off to reboot into the Mint installer.

## Weird Tip!

I'm booting the linux install media off a cheap SD card adapter, it's all I have. Sometimes the adapter takes too long to start up or something and I can't choose it as a boot option.

This helps:

* Boot the laptop, mash F12 to get to boot options, usb device isn't there.
* Go to "boot options" as if I want to change between legacy boot/UEFI boot options.
* Press ESC without changing anything. The laptop will now reboot and for some reason it takes longer to boot this time.
* Mash F12 again. Seems to be enough time to allow the sd card reader to initialize.

Plugging in the adapter before rebooting out of Windows also helps.

Poking around in the BIOS, looks like there are also options to enable SD boot using the onboard SD card reader instead of this adapter. Maybe turning off some fast start-related options could help too.

## "Rapid Storage Technology"

I was prompted by the installer to turn off "Intel Rapid Storage Technology" with a link to https://help.ubuntu.com/rst .

I don't have any RAID setups to worry about so it seems there are two steps:

* set a registry key in Windows, which will cause it to avoid looking for intel rst
* then, before the next boot, disable the feature BIOS side in favor of something called AHCI

This sent me down a rabbit hole.

It seems like Windows will automatically disable the relevant Intel RST options if it is booted in Safe Mode. The instructions here were much more useful than Ubuntu's page: https://gist.github.com/chenxiaolong/4beec93c464639a19ad82eeccc828c63

Basically:

* Run a command to boot windows into Safe Mode on next startup.
  
  ```cmd
  bcdedit /set {current} safeboot minimal
  bcdedit /set safeboot minimal
  ```

  I'm not sure whether you need the `{current}` so I just tried both.

* Reboot into the BIOS and change "System Configuration -> SATA Operation" to AHCI.
* Boot Windows into safe mode. It will automatically disable Intel RST.
* Boot Windows normally to check if it works.

<details><summary>The rabbit hole in question</summary>

1. First i went to the BIOS just to check if there was any AHCI setting. There is, under  "System Configuration -> SATA Operation".
2. Then in windows, the relevant registry keys are on that page. Rebooted.
3. Changed the bios setting to AHCI. Rebooted.
4. The computer then booted into "dell supportassist" instead of Windows. Not good! Reread the page again .. forgot to change all the regedit keys. Ughhh. Fortunately Windows was able to boot again after flipping the option back to RST in the bios.
5. Changed more registry keys. Rebooted and changed BIOS setting back to AHCI. Windows still wouldn't boot.

This is when I tried the safe mode trick and that worked okay.

For some reason I couldn't access the stock Windows Recovery Environment (might have been in one of those partitions I deleted 👀) so it's fortunate changing the BIOS setting back to RAID/Intel RST allowed Windows to boot again.

</details>

## The actual installation part

Not too hard. I used whatever out-of-the-box partition setup the installer made and didn't configure anything myself.

Wifi just works ™️.

## Post install

Mint opens this nice first-run setup window.

* Pick a color theme
* Set up "Timeshift" restore points
* Driver installation
* System updates

### Color theme and fonts

I don't like the Ubuntu font very much so I went with the preinstalled Noto as a system font, and installed Jetbrains Mono through the software manager for the monospace font (although the preinstalled Bitstream something-or-other wasn't bad either). Coming from Windows/stock Android, it's interesting to me that changing the system fonts is allowed and encouraged.

I picked a red theme. It's nice but sometimes the red is used as an accent color in a place I don't expect, then it looks like an error...!

### Graphics drivers

I manually made a timeshift snapshot before mucking with drivers just in case. For some reason it crashed the first time without making a snapshot 😬

This laptop has a slightly-failing "GTX 1050 Mobile". By default the open-source nouveau driver is used but I've heard people say the proprietary NVIDIA driver is better. The "driver manager" dialog lets you switch em easily. Reboot.

### System updates

Lots and lots of updates which were created after the installation media was burned. The first thing to update is mintupdate itself, then about 127 other packages totalling a gigabyte.

## IntelliJ IDEA

I just extracted the tar gz into a random folder (i created `~/Programs`) and it worked fine.

## Java

The packages in question: `openjdk-8-jdk`, `openjdk-17-jdk`, `openjdk-21-jdk`.

These JDKs all get installed separately in `/usr/lib/jvm/`. When configuring a path to Java it'd be best to use this path instead of the `/usr/bin/java` symlink.

To configure the version of "system Java" if it is needed, there is a script called `update-java-alternatives`. This script basically just calls `update-alternatives` (a standard package system feature) on all the java binaries like java, javac, javadoc, javap etc etc.

## Prism Launcher

The flatpak gave me sandboxing-related shit (TODO: write the shit, i microblogged about it)

The standalone tar gzs didn't work out of the box, probably needed to install Qt libraries on my system.

This leaves the appimage. Which worked!

(There's also a deb packaged by something called makedeb? Not sure what that is.)

## Minecraft

It runs at native resolution, which is kind of a problem on a hidpi display when you're fillrate limited... (Most of my Windows hidpi-related problems were related to trying to upscale Minecraft.)

Entering fullscreen literally doubles the framerate though. I haven't tried mods like Sodium yet.

Kat told me about `gamescope` which can be used as a wrapper command to run games at lower resolutions and upscale them (the Steam Deck uses it?). Sounds like fun but I think I'll need to compile it myself or find a sketchy deb. (Also this reminds me, probably worth something to add wrapper command support to my Minecraft toolchains. would it be possible to run Minecraft through `gamescope` and still debug it?)

## The text editor

It's called "xed" and it's pretty nice, except by default there's a "bracket completion" plugin which adds closing quotes even when typing contractions in English text... sometimes people write things that aren't computer programs you know!!

Can turn that off with Edit -> Preferences -> Plugins -> Bracket Completion. It'd be nice to configure it to not happen when typing in Markdown files but alas there is no configuration.

You can set autosave to happen every 1 minute. While it's autosaving it will eat your input. :(

## Bluetooth keyboard

Well it straight up doesn't work through the graphical interface. You can pair and connect, but typing on the keyboard doesn't work. Cool!

Through googling I found [this blogspammy page](https://computingforgeeks.com/connect-to-bluetooth-device-from-linux-terminal/) about connecting to things using `bluetoothctl`, which has an absolutely fucking useless man page BTW, i had to google around to find it's part of "BlueZ".

At least it survived a reboot (I can even type my login password with the bluetooth keyboard). I'm not sure if it will survive a unpair/repair and I don't intend to find out :D

## Steam

I installed Steam through the installer program in Software Manager. Went uneventfully.

### Portal 2

For some reason mouselook wasn't working at first. I thought it'd be some freak bug but it turns out `cl_mouselook` was just set to 0. Lol.

Fullscreen seems... faked, somehow? Like even when the game is set to fullscreen 720p, it's just being upscaled to fill the whole display instead of changing my resolution to 720p. The mouse cursor is tiny, stuff can get composited over the game.

Puzzlemaker compiling does not work, I guess it's not able to run the compiler tools. TODO.

## Debs!

So from what I can tell a `.deb` is an `ar` archive of a few things:

* the deb format version
* metadata about the package, dependencies, authors, preinstall and postinstall scripts, etc.
* files to extract onto the system.

Installing the package bascically splats the contents of that last tarball into `/`.

Resources about packaging seem to conflate a few concepts:

* how to compile software (and how to compile software to the standards of Debian's archives, specifically)
* how to write metadata (and how to write metadata to the standards of Debian's archives, specifically)
* how to use Debian helpers to compile software without writing as much in your packaging files

And this will be further complicated by the fact that I'm actually on Mint which is derivative of Ubuntu which is derivative of Debian.

This place https://wiki.debian.org/Packaging is probably a good place to start looking.

I heard about a tool called `pbuilder` which can help you scaffold clean chroots to build packages with a better knowledge of the "system packages" that leak into the environment. Could be interesting. See also [landley/toybox](https://github.com/landley/toybox/blob/b8186ba3c4d9548da2ae8b8aaf388b2a04f1966b/scripts/install.sh#L96)'s "airlock" stuff. Of course, also, contianers.

## Grub

The bootloader. It's that thing you see when you first turn on the computer. On my computer, because I'm dual-booting, it has a menu allowing me to pick between Linux and Windows.

I think the configuration works like this:

* you configure the script in `/etc/default/grub`, and/or add some dropins in `/etc/default/grub.d`
    * I guess there's also ones in `/etc/grub.d` (no `default`). But arch wiki says don't touch those
* you run `update-grub`, which runs those scripts and puts the results in `/boot/grub/grub.cfg`. The grub bootloader itself reads that file (it's a little language they call "shell-like scripting")
    * I also see a program called `grub-mkconfig`, what's the difference
    * Oh `update-grub` is literally just a script which runs `grub-mkconfig -o /boot/grub/grub.cfg`

I made a dropin at `/etc/default/grub.d/69_quat.cfg`.

By default the grub menu is way too small owing to the laptop's 4k display; not only that but the program is clearly lagging from having to drive that many pixels. You can change the video mode using the `GRUB_GFXMODE` variable in one of those dropin files, but I don't want to know what happens if I accidentally pick a value that my system doesn't support. Instead I booted into the teeny tiny GRUB terminal and ran `videoinfo` to list the video modes. It was currently using `3840x2160x32` which is a bit much. I added `GRUB_GFXMODE=1024x768x32` to my dropin file, one of the supported options.

While I was there I also added `GRUB_TIMEOUT=5` to reduce the automatic countdown from 10 to 5 seconds.

One `update-grub` later and wahey it works. The Mint logo used as a boot splash is a little stretched-looking now (that'll happen when you stretch a 4:3 resolution to a 16:9 display). I don't care.

## "Drop-in files"

Those `.d` directories you find around the place.

I think the idea:

* installing a program creates a default configuration file, with options from the program author (and whoever packaged it for the distro)
* if the program is updated, this file might be overwritten with new defaults
* so to provide space for users to configure their stuff without getting stomped on by the package manager, the program also enunmerates files in these `something.d` directories and loads those config files too

It isn't a formal standard, just some place that software packagers set aside for users.

## Performance!

I am pleasantly surprised by system performance. After the bootloader finishes the rest of the system boots quite quickly. At one point I thought my Windows install was hosed, but I guess it always took that long to boot and I've been putting up with it.

And the Makefile used to build this site locally takes about five-ten seconds from a cold cache on Windows, but took only about one second on Linux!

I'd guess most of the speedup is from better filesystem performance (ext4 vs NTFS) better performance in "spawning a million tiny processes" workloads, and performance differences with the shells ("git bash" seems *much* slower than `cmd` on Windows, but who the hell wants to use `cmd` and `nmake`???)

## Things to look into later

* What on earth is going on with this Flatpak stuff. What is Flatpak. Why is Flatpak.
* You can disable mouse acceleration through the graphical interface but you can't disable *trackpad* acceleration. Ugh!!!
* Gotta set up gamescope
* Git credentials. There is Microsoft's `git-credential-manager` which i use on Windows, but i wonder if there's something that integrates with the [GNOME keyring](https://wiki.gnome.org/Projects/GnomeKeyring)? (i think that's what the the "Passwords and Keys" application is a frontend for).
    * I'd like to figure out the GNOME keyring in general, put some ssh keys there maybe...

I'd also like to research more systemd topics: useful commands for administration and checking in on things, what are "unit files" and how can I write my own, any useful "targets" to know, where are the logs and do I need to clean them, how to list important units, shit like that.
