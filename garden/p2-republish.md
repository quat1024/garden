# Republishing portal 2 maps

I have a [going theory](https://github.com/ValveSoftware/portal2/issues/456) that the "new URL bug" is *partially* caused by [the 31-bit Steam ID rollover](https://github.com/ValveSoftware/portal2/issues/317) (maps with IDs greater than 2147483647).

## Geneosis's method

Here is [Geneosis's method](https://steamcommunity.com/sharedfiles/filedetails/?id=142353952) for using Cheat Engine to update maps.

* Open Puzzlemaker for the map you want to update.
* Publish it as hidden. This will create a new URL. Copy down the item ID in the new URL and call it the "bugged id"/
* Open the publish screen again, but don't publish the map yet.
* Usiing Cheat Engine, search the game's memory for the bugged ID, and replace it with the item-to-update's ID in Portal 2's memory.
* Click "publish". This second publish will update the existing map.
* Delete the extraneous hidden map from your workshop.

The first publish sets the "current item ID" variable to a known value, you use Cheat Engine to find this value and replace it with the correct one, and then publishing uses the correct value.

## My theory

* Open the `.p2c` for the map you want to publish. Convert the `FileID` to a *signed 32-bit integer* which I will call the "truncated ID".
* Open the publish screen.
* Use Cheat Engine to replace the "truncated ID" with the correct item ID in the game's memory.
* Publish the map.

Of course this will not work for all republishing situations - Geneosis's guide is from 2013, so apparently the new-URL bug predates the item ID rollover.

My theory is that these days, you can't fix URL bugs by modifying the p2c (Bisqwit's method) because the game always truncates the file ID to 32 bits while loading the file. But the variable used to hold the item ID *is* ultimately 64 bits which is why replacing it using Cheat Engine works.

## Step-by-step

I will republish "Destack": https://steamcommunity.com/sharedfiles/filedetails/?id=3425844055

This item has ID `3425844055` in base 10.

* Open the p2c in notepad. At the top you can see the file ID. It is `0x00000000CC323B57`.
* Open Windows Calculator and set it to "programmer" mode.
  * Above the calculator buttons, there's a setting that says `QWORD`, `DWORD`, `WORD`, or `BYTE`; cycle it to `QWORD` (64-bits).
* Click on `HEX` and paste in the hex file ID. In my case, I paste in `0x00000000CC323B57`.

![](/p2-url/qword.png)

* Next to `DEC`, verify that this matches the item ID of the published map. I can see the number `3,425,844,055` which does indeed match.
* Click on the `QWORD` label one time, cycling to `DWORD` mode (32 bits). The decimal readout now says `-869,123,241` for me.
  * This number is the "bugged ID".
* Open Portal 2. Edit the map in Puzzlemaker, make whatever changes you need to make.
* Hmm

## Hmm I don't think this works

Testing workarounds for the URL bug is a hell of a time to *not* get the URL bug