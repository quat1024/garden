# Bugs in Portal 2

I'm not trying to make fun of Valve, or be all "look at how stupid Valve is for daring to ship a game with a minor glitch in it". None of these bugs negatively affect the campaign experience and many of them require complicated setups or custom maps to create the necessary circumstances. I like Portal 2, this list is compiled out of love. These are the sorts of things you notice when you have a passionate and dedicated fanbase.

More bugs: https://nekz.me/glitches.html, https://wiki.portal2.sr/List_of_Glitches

## Puzzlemaker

### 45 degree glass

Glass or grating can be rotated in 90 degree increments using the editor handle. *Extremely* rarely, it is possible for glass to turn in a 45 degree increment instead of 90 degrees. From some camera angles, the glass turns green in the editor. In the built map, the glass is built incorrectly. It seems to happen more often on low FPS? Could be placebo...

### Fake antlines using hotkeys

[Yuuubi has a steam guide about this](https://steamcommunity.com/sharedfiles/filedetails/?id=395550329). Basically:

* select object 1 with the mouse
* press K to enter antline mode
* press Delete to remove object 1
* finish placing the antline by clicking on object 2

You now have an antline from object 2 to... nowhere. Dirtying the puzzle in any way will cause the antline to reroute. After it reroutes 8 times it will turn into a signage to nowhere instead.

### Box-selecting cube droppers

If you box-select a region with cube droppers and then translate the region, cube droppers move 2 grid squares, but everything else moves 1 grid square.

### Angled panel color

Angled panels on portalable surfaces appear unportalable after resizing the puzzle. Moving the angled panel in the editor will fix the color. They are still portalable when compiling the map.

### Floor/ceiling observation rooms

* Align the editor's camera so that a floor or ceiling is directly underneath the "observation room" icon in the pallete.
* Click on the observation room in the pallete.
* Without moving the mouse, click on the puzzle.

Now you have an observation room on the floor or ceiling, normally an illegal place to put them.

### Rare crash when blocking a stair

If you connect antlines to a stair, and then surround the stair with geometry or lightstrips or similar so there is no possible antline path, the game can very rarely crash.

## Puzzlemaker maps

### Skip the entry door trigger

If the entry door is on top of a portalable surface, it is possible to enter the puzzle and dip into that portal surface without hitting the trigger marking entry into the puzzle. So start-of-puzzle effects won't happen: no "auto-drop first cube" cubedroppers, no dynamic light from the large observation room, and no music.

### Visible nodraw in one entry corridor

One of the Puzzlemaker entry corridor instances (the one with a line of yellow tiles along the bottom) has visible nodraw on the inside edge of the tile, visible if you walk to the right and look at the floor. This was fixed in BEEMOD's version of the instance.

### Bouncy stairs

Sometimes if you jump off stairs you will get sent a lot higher than a normal jump.

### Grating texture transparency

The transparency of the grating texture is very different depending on your antialiasing settings. With antialiasing turned off, it is hard to see through the grating, and with antialiasing at 8x, it can sometimes be *so* transparent it's hard to see the grating in the first place.

### `restart` vs `restart_level`

If you run `restart` in the console, it looks like the game exits the "community map" state. The pause menu won't show options to rate the map in the Steam Workshop, and completing the map will kick you back to the main menu with an error about "the server being closed" or something.

If you run `restart_level`, everything works as expected.

This is notable because `restart_level` appears to be an undocumented command. It does not appear in the console's autocomplete.

### Laser segment limit

If you place a very large amount of laser cubes in a map and redirect a laser through all of them, it will eventually stop working.

TODO research this more, I don't remember the details.

### Fake bouncy props

When painted with blue gel, frankencubes turn blue, and jumping on them causes you to bounce. But the frankencube *itself* does not bounce.

Seems to apply to all NPCs other than turrets (frankencubes, cameras, wheatley) and also maybe `prop_physics_override` (I faintly remember a workshop map where office chairs exhibited this effect)

### Particle effect at world origin

TODO not sure what causes this but I remember seeing laser particles come from 0, 0, 0 at least once

### Light bridge lag spike

The particle effect placed at the end of a lightbridge beam is not precached, so turning on a lightbridge for the first time causes a lag spike.

This was fixed in BEEMOD by placing an emitter for that particle texture in a dev room somewhere. You can also work around it in vanilla puzzlemaker by placing an active-at-map-start light bridge anywhere.

### Orange funnel particles through wall

If orange funnels are placed on a 1-puzzlemaker-unit thick surface, particles are visible from the other side of the wall.

## General gameplay

### Blocked portals

If there's grating blocking the far side of a portal, you can't walk through the portal. But cubes can go through the portal.

If there's a light bridge blocking the far side of a portal, cubes can't go through the portal. But you can walk through the portal.

### "corner glitch"

If you block the through-portal shadow of something with your player, the object kinda gets stuck in place. You can then walk as far away as you want and the object will still be stuck. It's a bit of a weird glitch.

### Grating is portalable

Normally you only can't place portals on grating because it's applied to surfaces that portal shots pass through. But in certain scenarios you can bump a portal from a collidable surface onto grating. And then it's revealed that grating *is* considered portalable. (for example, `sp_a4_tb_catch`)

### Illegal grab positions

The singleplayer grab controller works by dragging the cube towards a point in front of you (using a simulated spring?). You may have noticed that if you hold a cube in a weird spot, or if you are holding a cube while being far away from it, the spring breaks and the game forces you to let go.

This is governed by an "error" variable, which can be shown on screen with `player_held_object_debug_error 1`. The error is increased when the spring is too long, and it's also *multiplied* by some constant if there is something between you and the cube. Once the error passes some threshold (100?) you are forced to drop the cube. The error decays to 0 over time.

The multiplicative increase is supposed to *quickly*, but not *immediately*, cause you to drop the cube when you're grabbing it through a wall. But if the error value is already 0, the multiplicative increase doesn't do anything! So if you are careful you can hold objects in illegal positions.

You can do this in puzzlemaker by placing a sheet of glass on the floor, enabling the debug command, holding a cube, and very very slowly and gently rotating the camera until the cube is on the far side of the glass.

### "Grab glitch"

In singleplayer, if you grab an object while it passes through a portal, it can start magnetizing towards you from the location it *exited* the portal. Depending on the portal positions this can appear as the object taking the "long way around" to reach your hands, floating through all the space *between* your portals to reach you, instead of just going through the portal.

This appears to be tick-perfect, but I'm not sure which tick (the tick before it passes through, or after?)

### Sleeping cubes

If a cube goes to sleep (because it hasn't been moved in a while) on top of a closed portal, placing the other portal won't wake the cube and it will continue to float.

BEEMOD includes a partial workaround: its autoportals have a tiny `trigger_push` that activates when the portal is opened.

### Sleeping laser cubes

Laser cubes seem to go into a "deep sleep" when they have a laser running through them, probably to prevent physics engine jank from randomly knocking the cube out of alignment.

If a laser cube is supported in some way, like being on another cube or on your head, and a laser is running through it, the supporting material can be removed and the laser cube will continue to float. Disturbing the cube or removing the laser will finally make it fall.

### Cube button friction

When a cube button becomes pressed, the cube inside becomes more slippery than usual to help it slide into the base of the button. When a cube button becomes unpressed, all cubes nearby return to their normal slipperiness.

I worded that carefully: What happens if a cube is removed from a button without actually unpressing it, which can be done by holding the button down with another cube?

Well, it stays slippery forever. It's even more slippery than a cube painted with orange gel.

### Worldportal portal particles

If you shoot a portal through a worldportal, the "portal beam" particles travel from you to the *true* location of the portal, not to the apparent location through the worldportal.

Visible in Finale 2 when you shoot into the moving room (it's true location is off to the side), and also visible in Puzzlemaker maps, when you shoot through the door separating the elevator room from the entry/exit corridors.

### Feet and head on different sides of a portal

If your head looks through a portal but you haven't gone all the way through the portal yet, you can still shoot from your camera's position, which you normally can't do. This allows you to kind of spiderman around on the ceiling and connect two portal surfaces which can't see each other. Odd. 

### Gel blob momentum

Gel blobs have their momentum set to 0 when you save and load the game.

### Unexploded gel bombs

If you set a gel bomb on the ground very gently, it will not blow up. You can then nudge it around. If you press on it too hard, it will pop.

### Blue gel double-bounce

When you first jump on blue gel, you just barely don't have enough height to clear a 256 unit ledge (2 blocks in puzzlemaker). But you do have enough height on the rebound.

### Cheesing speed gel

Orange gel's speedup is based on the duration you've been walking on orange gel, not the distance covered. You can crouch and/or walk in circles on small patches of orange gel to get more speed than you're supposed to get.

### Gel on bridges

Gel on bridges goes away when you save and load the game. Not a problem for vanilla because the only maps with gel and bridges are co-op maps, where you can't save anyway.

### Laser cube delay

If you turn on a laser pointing at a laser cube, it takes a tick for the cube to start emitting a laser. Ditto for when it's turned off I think.

### Lasers can't get visually blocked by nonrendered things

If a laser is blocked by something culled out of view, the laser can *appear* to be not blocked. This is visible in Pull the Rug if you crouch down before entering the puzzle. This doesn't affect gameplay logic.

### Laser and bridge immunity after exiting a portal

If a laser or bridge encounters a wall right after exiting a portal, it can go through the wall.

Probably also affects funnels since they are also "projected"

### Laser receiver saveload

If a laser receiver is already active when the game is loaded, it won't display its ball-of-light particle effect. To see the particle you need to deactivate and reactivate the laser receiver.

### Edge-on laser receivers

Laser receivers can be hit at extremely shallow angles. The laser will brush past the receiver, but it will still turn on.

### Laser cube / funnel collision

If you place a laser cube in a funnel, and then take it back out again before it comes to a rest, it stops colliding with the player.

Only happens to laser cubes, not other types of cube.

### Extended funnel effect

Sometimes when leaving a funnel, you will keep the funnel physics for about one second, like a temporary "excursion funnel glitch" that doesn't require crouching or coming to a complete stop.

It seems to be positional (when you find a spot that works, it usually works consistently). I think it happens more often on vertical funnels. TODO more research I guess lol.

### Loud funnels

With certain arrangements of funnels and portals, sometimes the funnel emitter sound effect becomes *much* louder than it should be. I don't know if this happens to all sounds or just the funnel sounds, but either way it's most *annoying* when it happens to the funnel. Real ones know.

### Randomly falling out of funnels

Sometimes you just fall out of an excursion funnel!

It seems to be highly position sensitive; when it happens, it always seems to happen around the same spot in the funnel. If the funnel is coming through a portal, moving the portal a tiny bit usually fixes it, or wiggling around the player just before reaching the magic spot.

### Gel funnel warp

If you point a funnel at itself using portals, gel blobs in the funnel only want to occupy the space between the exit portal & the point of intersection. They will teleport from the point of intersection to the entry portal, without actually riding along that part of the funnel.

## Co-op bugs

### Grab controller bugs

Co-op uses a "viewmodel grab controller" instead of singleplayer's physical grab controller. When you pick up a cube it is seemingly removed from the physics simulation and rendered as part of the portalgun; when you drop it, it is spawned fresh inside the level. This was done to avoid P-Body (who is always the *client* in a networked game) having to deal with physics latency.

But it has a number of bugs:

* If you can interact with the cube at all, you can take it. Even if the cube is on the far side of grating, or through a gap too small to fit the cube, you can take it with you.
* Because the cube is no longer in the level they had to reimplement "can't take cubes through fizzlers" logic.  But the simulated cube used for this scenario *only* tests for collision with fizzlers, not with walls or floors. If you grab a cube, crouch, and look straight down, you can take it *under* fizzlers.

### Laser cube / funnel collision, part 2

If you place laser cube in a funnel it loses collision with players, just like in singleplayer. Then when you hold the cube and look straight down, your momentum will be [cancelled entirely](https://www.youtube.com/watch?v=61Cnb_wy9Qg). This can be used to hover in the air, fight against the force of a funnel, etc. This effect doesn't happen in singleplayer, only co-op.

I believe the speedrunner types call it "Holding Laser Cube Levitation"

## Mapping errors

### Walled off by platforms in Turret Factory

[Whatever was happening here!](https://old.reddit.com/r/Portal/comments/wqy8ca/weird_placement_glitch_on_portal_2_on_switch_it/)

> So fun fact: what happened here is that you probably made a save very early into the level loading, most likely through the menu. This makes the game freak out and sometimes will make panels from other tracks to place on one track. Most of the time it is only 2 tracks, but in your case it ended up being 3. This is even reproducible on all versions of the game. In fact, I have lost speedrun of this game to this very glitch.

### Floating checkbox in Funnel Intro

The checkbox next to the exit door in Funnel Intro is clearly floating several inches away from the wall.

I *think* this is rumored to be a holdover from Portal 1's artstyle. Portal 1 uses framed checkboxes, Portal 2 has them embedded into the wall. So maybe this originally had a framed checkbox, and when they removed the frame, they forgot to move the checkbox closer to the wall.

### Nodraw heaven in Laser Platform

TODO, find my pictures of this, but there's a nodraw room easily accessible by portal bump.

### Getting stuck above coop disassemblers

Some co-op maps have a light bridge which can be pointed into the exit area. If one player goes through the exit-area fizzler, the other player can lift them up with the light bridge, where they can jump on top of one of the exit disassemblers and get softlocked.

## Well-known speedrun tricks

Everyone has seen SGDQ portal speedruns so I'll only include the ones I think are more interesting / obscure.

### Button glitch

Certain buttons can get stuck down if they are pressed and released in the same tick. I'll defer to the [speedrun geniuses](https://wiki.portal2.sr/Button_Glitch) on the explanation.

There are actually three kinds of button glitch:

* "simultaneous output button glitch", only relevant in certain maps because it depends how the inputs/outputs are set up and what the button is connected to
* "button save glitch", triggerable on any button, but requires a save/load
* "delayed output button glitch", triggerable on any button, but only by P-Body in co-op

### Faithplate Intro dialogue

Placing any prop on the exit button causes glados to begin congratulating you. Saves time because the game will never advance to the next map while glados is yapping.

### Laser switching

It takes a tick or two for lasers to turn off. Switching a laser from one receiver to another can briefly cause both of them to be active.

Combined with the tendency for doors to not close *on* you if you're pressing up against the door with movement keys, you can cheese a lot of puzzles where the exit door is opened by more than one laser. Notably, Dual Lasers and Triple Lasers.

### Out-of-bounds pausing

When you're out of bounds, pausing resets your velocity to 0. This is used in the [out-of-bounds route](https://youtu.be/YoCU8oxhCOU?si=fKmFt0ENG2Bcy8w4&t=1170) to make a jump which can't otherwise be made in Turret Factory out-of-bounds, and also to instakill your speed from some funnel-glitches to work around the very low acceleration in that state. 

### Cube through wall

Physics objects can go through thin walls if there is a portal placed nearby. Speedrunners seem to call this the "item edge glitch". Notably used in Smooth Jazz to glitch a cube into the exit room and trigger the anti-softlock.

## Not really bugs

### Turret cheesing

When a turret loses track of you, it first does a "searching" animation, then does another animation where the turret's laser chaotically boioioings back into place. This second animation cannot be interrupted in any way. The turret cannot see you until its laser is stable again.

Maybe this makes lore sense? The turret can't see you because it's looking around too fast? Either way, it can be used to cheese a lot of turret puzzles.

### Light bridge camera snap

If you chop yourself with a light bridge, your camera pitch is reset to horizontal. Probably intentional, it might make bridge climing easier? But weird.

In puzzlemaker, if you create a strobing light bridge and walk on it, your camera is constantly reset to horizontal.

### Puzzlemaker antline routing

It's not the best. Lots of situations where an antline will kink to the left only to immediately kink back to the right, do a little loop de loop, adamantly refuse to take the shortest path, etc.

### Prop elevator

In singleplayer, stack two cubes near a wall or corner, stand on the top one, and pick up the bottom one while repeatedly jumping. The bottom cube tries to move closer to you, but in the process it drags the top cube upwards, and you go along for the ride.

Can be used to cheese a lot of puzzles with at least two cubes.

### Cube jumping for distance

Valve fixed HL2-style prop climbing by putting a cooldown on your "use" key. But there's still enough time to throw a cube, have it bounce off a wall, and jump on it, which allows you to cross larger gaps than you should be able to. You can even repeatedly catch and rethrow the cube to cross ridiciulously long distances.

### Cube jumping for height

Similarly, if you're oscillating between two floor portals and you have a cube, you can drop the cube into the portals then jump off it from the apex of your oscillation for extra height. This can be repeated forever. Not really a bug, but since it means you can get infinite height from nothing except a cube and some dryer lint, puzzle authors consider it cheese.

Can also be done using a blue-gelled floor to reflect your velocity back up.
