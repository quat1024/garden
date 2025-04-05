# Why you shouldn't use ChatGPT to diagnose Minecraft errors

Scenario: We have two users.

User A is having trouble with Patchouli and sends their crash report to a discord support channel. I will spare you the full crashlog, but the critical part is this:

```
[02abr2025 17:54:48.537] [Worker-Main-5/ERROR] [net.neoforged.fml.ModContainer/LOADING]: Caught exception during event FMLCommonSetupEvent dispatch for modid patchouli
java.lang.ExceptionInInitializerError: null
	at TRANSFORMER/patchouli@1.21-88-NEOFORGE/vazkii.patchouli.common.book.BookRegistry.init(BookRegistry.java:42) ~[?:?]
	
	(...bunch of text...)
	
Caused by: java.lang.IllegalStateException: There should be exactly one IXplatAbstractions implementation on the classpath. Found: []
	at TRANSFORMER/patchouli@1.21-88-NEOFORGE/vazkii.patchouli.xplat.IXplatAbstractions.find(IXplatAbstractions.java:51) ~[?:?]
	at TRANSFORMER/patchouli@1.21-88-NEOFORGE/vazkii.patchouli.xplat.IXplatAbstractions.<clinit>(IXplatAbstractions.java:45) ~[?:?]
	... 15 more
```

This is a genuine problem with Patchouli booting - it's not able to find the platform-specific support code. There is [an open issue about it](https://github.com/VazkiiMods/Patchouli/issues/792); we don't really know what causes it yet. Something is breaking the ServiceLoader it uses within `IXplatAbstractions#find`? That shouldn't ever happen.

Anyway, user B shows up and pastes this wall-of-text into the discord channel. It is clearly generated with ChatGPT, something they later admit to.

<details><summary>Click to show it</summary>

> The log reveals that your Minecraft client crashed due to issues with mods not loading properly. Here are the key problems:
> 
> ## 1. Broken Mod State
>
> Repeated lines like this show up:
>
>    Cowardly refusing to send event [...] to a broken mod state
>
> This means NeoForge (mod loader) is identifying one or more mods as broken and is refusing to initialize events like `TextureAtlasStitchedEvent`, `EntityRenderersEvent$CreateSkullModels`, etc. These are important for rendering textures and models.
> 
> ## 2. Shader Issue
>
>    Shader rendertype_entity_translucent_emissive could not find sampler named Sampler2
>
> This indicates a missing or improperly configured shader. This could be from a mod with custom shaders.
> 
> ## 3. Crash Report
> 
>    [Render thread/FATAL] [...] Crash report saved to [...]\crash-2025-04-02_17.55.01-fml.txt
> 
> This confirms a full crash occurred during the render thread’s attempt to load or render assets.
> 
> ## Likely Causes
>
> * A mod failed to initialize properly, corrupting the render pipeline.
> * Mod compatibility issues (some mods may not work well with others or with your game version).
> * Possible resource loading failure (like animations, textures, or shaders).
> 
> ## What You Can Do
>
> 1. Check crash report file: Located at
> 
>    C:\Users\???\AppData\Roaming\.minecraft\crash-reports\crash-2025-04-02_17.55.01-fml.txt
>
> 2. Update all mods: Make sure they’re compatible with your version of Minecraft and NeoForge.
> 3. Narrow down the cause: Temporarily remove mods and reintroduce them one by one to isolate the issue.

</details>

Here it is again with my comments interspersed.

> ### 1. Broken Mod State
>
> Repeated lines like this show up:
>
>    Cowardly refusing to send event [...] to a broken mod state
>
> This means NeoForge (mod loader) is identifying one or more mods as broken and is refusing to initialize events like `TextureAtlasStitchedEvent`, `EntityRenderersEvent$CreateSkullModels`, etc. These are important for rendering textures and models.

These are important for *everything*, including bringing up the game in the first place. Textures and models are only one component of that.

The only reason Forge (and Neo) do this "refusing to send event" dance in the first place is to boot *enough* of the game to display the error in the Minecraft GUI. I don't like that it does this -- as anyone who's encountered a crash before knows, half the time it just displays something like `InvocationTargetException: null` or whatever which isn't the actual cause of the problem.

When you see these "cowardly refusing to send event to ..." lines, the best thing to do is **look above them** because the instigating problem will always be *before* them.

> ### 2. Shader Issue
>
>    Shader rendertype_entity_translucent_emissive could not find sampler named Sampler2
>
> This indicates a missing or improperly configured shader. This could be from a mod with custom shaders.

[This happens in *vanilla*](https://bugs.mojang.com/browse/MC/issues/MC-249414), LMFAO, and doesn't mean anything. The shader is from vanilla. This is a complete red herring.

> ### 3. Crash Report
> 
>    [Render thread/FATAL] [...] Crash report saved to [...]\crash-2025-04-02_17.55.01-fml.txt
> 
> This confirms a full crash occurred during the render thread’s attempt to load or render assets.

But the person seeking help already knew this, because that's the crash report they uploaded to Discord in the first place.

Also, here we see the AI starting to go off on a weird tangent about "the render thread"...

> ### Likely Causes
>
> * A mod failed to initialize properly, corrupting the render pipeline.

...for an issue that has absolutely to do with "the render pipeline".

The main Minecraft client thread just happens to be called "Render thread". It does rendering, sure, but also does other stuff. Much of the initial game-boot process happens on "the render thread". So just because a thread named "Render thread" crashed doesn't mean something is wrong with specifically rendering.

> * Mod compatibility issues (some mods may not work well with others or with your game version).

"some mods may not work well with others": Here we finally have some actual advice, although it's extremely generic and probably something you already knew.

"or with your game version": NeoForge would error about that before getting this far in the mod loading process, of course.

> * Possible resource loading failure (like animations, textures, or shaders).

Lol.

> ### What You Can Do
>
> 1. Check crash report file: Located at
> 
>    C:\Users\???\AppData\Roaming\.minecraft\crash-reports\crash-2025-04-02_17.55.01-fml.txt

Again, this is already the file that the user uploaded.

> 2. Update all mods: Make sure they’re compatible with your version of Minecraft and NeoForge.
> 3. Narrow down the cause: Temporarily remove mods and reintroduce them one by one to isolate the issue.

More generic broadly-applicable advice.

# Takeaways

* It's crystal-clear to me that Patchouli is causing the problem. It even matches an existing bug pattern found on the github. But this AI report makes no mention of Patchouli.
* The advice it gives is completely generic.
* It will send you on red herrings.
* Wasting support-channel space on
  
  > ## 3. Try Uploading This Crash Report You Already Uploaded
  >
  > You already uploaded the crash report located at:
  > 
  >     C:\Users\???\AppData\Roaming\.minecraft\crash-reports\crash-2025-04-02_17.55.01-fml.txt
  > 
  > Have you tried looking in there? Huh?
  
  helps nobody.

However, the general advice it gives isn't too terrible?

* Yes, "some mods may not work well with others".
* Yes, check the crash report file.
  * Obviously if you're asking for help with your crash report file, you already did that.
	* This is infinitely better than posting "help it crashed", posting a screenshot of Neo's terrible error GUI, or God forbid [the "exit code"](https://highlysuspect.agency/exit-code-1/).
* Yes, try updating mods to the latest version.
  * (Generally if you're playing someone else's modpack, though, be careful about updating mods willy-nilly)
* Yes, try removing some mods temporarily and seeing if that fixes the problem. If you don't know where to start, try removing half the mods.

It's just -- you don't need an AI to tell you that, given that it applies to literally every Minecraft problem, and half of all non-Minecraft tech support problems too.
