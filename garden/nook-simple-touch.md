# the Nook Simple Touch (2011)

Mine says "Model number BNRF300" on the about screen. It is black, has four pagination buttons on the left and right sides of the screen, and has a Micro SD card slot.

The devices seem to hold up pretty well from reports I'm seeing online; apart from the disgusting decaying soft-touch rubber.

## Timeline of events

* 2011: B&N releases the Nook Simple Touch.
* ???: B&N releases firmware 1.2.1.
* 2012-2013: jeff_kz creates [NookManager](https://xdaforums.com/t/root-nookmanager-graphical-rooter-for-1-2-x-and-beyond.2040351/), a bootable rooting application based on ClockworkMod Recovery.
  * You flash it to an SD card, boot it, click a few buttons, and it's rooted.
* Some time later: B&N releases firmware 1.2.2. Sadly NookManager does not work on it.
* 2018: nmyshkin publishes [an updated NookManager](https://xdaforums.com/t/nst-g-updating-nookmanager-for-fw-1-2-2.3873048/) that works on 1.2.2.
  * Still updated thru 2024.
  * Also updates some of the apps included in NookManager.
* June 2024: B&N [discontinues Internet services](https://help.barnesandnoble.com/hc/en-us/articles/19894497906715-Retired-NOOK-Devices) for their old nooks, including the Simple Touch.
* 2024: nmyshkin publishes ["The Phoenix Project"](https://xdaforums.com/t/nst-g-the-phoenix-project.4673934/), a series of ready-to-install disk images preconfigured with custom reader apps, custom home screens (made in *Tasker?!*), battery savings, and more
  * You flash it to an SD card, boot it, restore the image onto your device, and it's like a clone of theirs.
* 2025: I start writing this document.

## Bypassing registration

B&N wanted all Nooks to be registered to a B&N account. A device on its initial setup screen (the "out-of-box experience" or "OOBE") will prompt for a wifi connection and then fail the connection test (claiming there is no internet) because B&N took down the registration servers.

There is an intended way around the registration process that B&N hid in their own firmware. This method was [discovered by XDA user crazy_jake in 2011](https://xdaforums.com/t/q-nook-touch-require-registration-before-root.1162693/post-15616921).

* Restart the device.
* On the OOBE screen, select a language.
* Accessing the "Factory screen":
  * hold the top-right page turn button,
  * keep holding it, swipe from left to right across the top of the screen.
  * A "Factory" button appears in the upper left corner. Touch it.
* Bypassing the out of box experience:
  * At the bottom of the screen there are two buttons, but they're not symmetrically arranged around the center of the screen.
  * Hold the top-right page turn button again. Touch the location where the third button would go (lower-right).
  * The "Skip Oobe" button appears. Touch it.

A registration-bypassed Nook will periodically try and contact B&N servers about registration. This will drain the battery more quickly. The best way to re-register an unregistered device is probably just flashing nmyshkin's Phoenix Project Phase 1 image, which is simply registered to their account -- now that the servers are dead, it doesn't matter that the account isn't actually yours :)

## Factory resetting

Reboot the device while holding the lower-left and lower-right page turn buttons, then follow the directions on the screen.

Make sure you know how to bypass registration (and the battery-draining consequences of it) before resetting! If you're planning on rooting/customizing your device and it still *thinks* it's registered to a B&N account, make a backup with NookManager before attempting to reboot - you can't otherwise get back to that state.

## "Rooting?"

There are, apparently, no security measures to speak of. Damn thing just boots unsigned code off an SD card.

This also means they are difficult devices to "brick" (barring hardware failure) because you can just boot whatever you want at any time and restore from any backups, even other people's backups.

I think there are two main avenues, both by nmyshkin: [the updated NookManager](https://xdaforums.com/t/nst-g-updating-nookmanager-for-fw-1-2-2.3873048/) and the [Phoenix Project](https://xdaforums.com/t/nst-g-the-phoenix-project.4673934/).

### Updated NookManager

NookManager roots your current device. If you have files saved onto it, they will remain.

There are three versions of the updated NookManager you can download, which vary in the amount apps they install onto your device.

* "Classic" is simply updated versions of apps from the original NookManager.
* "Traditional" makes it into, basically, a weird android tablet with an Android-like launcher.
* "Stealth" keeps the original B&N user interface but you can launch into custom stuff with a key combination.

#### Regarding Win32DiskImager

The NookManager instructions refer to this program "Win32DiskImager". The downloads for that are now hosted [here](https://sourceforge.net/projects/win32diskimager/), although I personally used the more popular [balenaEtcher](https://etcher.balena.io/) to complete that step.

### Phoenix Project

Phoenix Project images are backups that nmyshkin took of their own Nook devices. When you install a Phoenix Project image, your device turns into a clone of theirs. Your account will be replaced with theirs (which is, again, meaningless because the internet services are gone) and I believe will lose any files saved to the Nook's internal storage.

There are also three "phases". Phase 1 is simply a stock device registered with nmyshkin's B&N account -- good if you want to avoid the battery-drain problems from an unregistered device. Phase 2 contains more preinstalled apps (including, hilariously, Kindle) and a custom homescreen created by nmyshkin, although the primary reading experience is B&N's official reader app.

Phase 3 further strips out more official B&N software; four versions are provided with four different third-party reader apps. Phase 3 builds use an older firmware revision (1.1.5) to support a "partial refresh" feature on some of these readers.

### Choosing

Most of the B&N user interface is broken with the discontinuation of online services. So I don't think there's a need for Nookmanager "Stealth" mode or Phoenix phase 1 unless you really like the half-broken stock interface.

[nmyshkin](https://xdaforums.com/t/nst-g-the-phoenix-project.4673934/post-89921309) personally uses Phase 2.

I personally just used the NookManager (Classic) because I want to play around with it. (I don't think it comes with enough apps out-of-the-box.) If I just wanted a simple, working ereader i probably would have picked Phoenix phases 1 or 2.

## Apps

[Lots of apps on XDA](https://xdaforums.com/f/nook-touch-themes-and-apps.1202/). Most threads are by nmyshkin, what a surprise \^\^.

The Android Market/Google Play Store no longer works. Most contemporary apps tied to a specific network service do not work.

## More on registering

[This thread by nmyshkin](https://xdaforums.com/t/nst-g-really-removing-all-b-n-apps.3972941/) goes over the details.

Basically all of the stock B&N apps phone home all the time and drain the battery if you are unregistered. The options:

* Install a Phoenix Project image registered to nmyshkin's account.
* Remove *all* the stock B&N apps and use third-party launchers, ereader, and settings apps. (This includes the library and reader apps.) Then there's nothing to phone home to.

*Hmm:* is modding the b&n apks possible?

# Thank you nmyshkin

Just a note if they're reading this. You are amazing! I had no idea you could do this shit with Tasker lol!