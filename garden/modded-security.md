# Modded Minecraft security concerns

This page is a work in progress.

## `log4shell`

A vulnerability in the third-party library Apache Log4j.

If an attacker can cause a certain string to get printed to the game log, they can execute arbitrary code on the server. (The logger will connect to the attacker's server using a protocol called a "JNDI lookup", and execute whatever Java code it finds there. Yes, it's as ridiculous as it sounds.)

In the context of Minecraft, even if the server is whitelisted, people *not* on the whitelist can log messages to the console by *attempting* to connect to the server.

It also works in the other direction; yuor client logs all chat messages it receives, so servers can send your client a chat message which executes arbitrary code on your client.

### where is log4j

It's a component of vanilla Minecraft. It's not a component of Java; updating java won't update log4j.

### mitigations

Java version 8u121 disabled-by-default the ability for JNDI lookups to execute code, fixing the worst of the issues.

TODO write some stuff about how to check the version of log4j.

The log4j version that actually fixed all the remote-code-execution bullshit is `2.17.1`. The version Mojang themselves ships as part of 1.7.10's [metadata](https://piston-meta.mojang.com/v1/packages/ed5d8789ed29872ea2ef1c348302b0c55e3f3468/1.7.10.json) is, uh, `2.0-beta9`. Vulnerable.

Most launchers do *not* trust Mojang's metadata file and grab their own version of log4j.

During the initial fervor surrounding this bug it was suggested to set some `formatMsgNoLookups` variable. This does **not** prevent the problem even though it sounds like it would.

### sources

* This bug is famous enough to get its own [wikipedia page](https://en.wikipedia.org/wiki/Log4Shell).
* https://web.archive.org/web/20240616040703/https://www.lunasec.io/docs/blog/log4j-zero-day/
* Disabling-by-default the jndi lookups in 8u121: https://www.oracle.com/java/technologies/javase/8u121-relnotes.html (section "Improved protection for JNDI remote class loading")

## Bibliocraft arbitrary file write

Discovered by Exopteron and described here https://github.com/Exopteron/BiblioRCE .

Bibliocraft allows players to write books. Book data is stored in `world/books/` with a filename containing the user-selected "author" and "title". However, the filename logic is vulnerable to *path traversal*, which allows writing books outside of the intended `world/books/` directory.

A player can set their author name to `../../mods` and write a "book" to the `mods/` directory, which remotely installs a mod onto the server. The mod will be loaded by Forge on the next server restart. All mods are just blocks of Java code, so this achieves arbitrary code execution.

(First, Exopteron discovered that the 1.7.10 optimization mod "CoreTweaks" was vulnerable to having its files overwritten with the Bibliocraft file-writing primitive. Later they discovered this method of writing to the `mods/` directory.)

### mitigations

Fixed in BiblioCraft v(something).

I've heard about a "GTNH fork of bibliocraft". Unless you are playing gtnh you will need to go out of your way to install it. Old modpacks will not automatically update their version of bibliocraft.

If the server is whitelisted, only whitelisted players can cause arbitrary code execution in this way.

## Java serialization problems

TODO short, friendly description of deserialization vulnerabilities? Kinda tricky to explain! something like

> Java contains a *serialization* and *deserialization* feature, which allows converting Java objects to and from sequences of bytes. Many mods decided to use Java serialization to implement their multiplayer networking code - a client serializes some object, sends it over the internet to the server, and the server deserializes the object.
>
> The deserialization process works in three steps:
>
> * read the bytes from the internet,
> * deserialize whatever Java object those bytes contain using `ObjectInputStream`,
> * check that the Java object has the correct type.
> 
> The problem is that *any* Java object can be deserialized with `ObjectInputStream`, even a type of object called a "gadget": objects which lead to arbitrary code execution when they are deserialized. It doesn't matter that the gadget is of the wrong type; the damage has already been done.
> 
> Putting it all together: when a client sends a message to the server, they can embed a serialized form of some gadget, knowing that the server will deserialize it and trigger the arbitrary code execution.

And this also works in the other direction; a malicious server can send you a gadget knowing your client will deserialize it and trigger code execution.

The existing term in the Java security space is ["Mad Gadget"](https://opensource.googleblog.com/2017/03/operation-rosehub.html). For some reason it picked up the name "bleeding pipe" when applied to Minecraft mods specifically. Not sure why?

### mitigations

There's a mod called [PipeBlocker](https://modrinth.com/mod/pipeblocker).

The trick is that Java deserialization is "safe" if *only* objects of the expected type are permitted to be deserialized. PipeBlocker replaces all usages of `ObjectInputStream` with its special `FilteredInputStream`, which crashes the game *before* deserializing an object of an unexpected type.

### sources

* prism's post (light on details) https://prismlauncher.org/news/bleedingpipe-alert/
* `ysoserial` (more about this class of bug) https://github.com/frohoff/ysoserial
  
  > It should be noted that the vulnerability lies in the application performing unsafe deserialization and NOT in having gadgets on the classpath.

## Straight up malware

You know, the fracturiser shit.

*All* Java mods are just chunks of Java code which can do anything; "anything" includes "stealing your passwords".

### mitigations

All known traces of mods containing this malware have been scrubbed from curseforge and modrinth a while ago. Both platforms implemented some kind of lightweight static-analysis based "security scanner"; I don't think either platform has made the details public.

To the best of the modded community's knowledge, noone has tried this again, but we just don't know :tm:

Download mods from trusted people, play modpacks from trusted curators.

