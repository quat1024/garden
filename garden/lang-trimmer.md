# Lang trimmer

For Minecraft-format language jsons.

```{=html}
<div id=area>
<textarea id=en_us rows=20 placeholder="en_us.json"></textarea>
<textarea id=other rows=20 placeholder="en_gb.json"></textarea>
<fieldset>
<legend>Settings</legend>
<p>
	<input type=checkbox id=rm_identical checked>
	<label for=rm_identical>Remove keys matching <code>en_us</code></label>
</p>
<p>
	<input type=checkbox id=rm_missing>
	<label for=rm_missing>Remove keys missing from <code>en_us</code></label>
</p>
<p>
	Indent result with:
	<input type=radio name=ind id=ind_tabs checked><label for=ind_tabs>Tabs</label>
	<input type=radio name=ind id=ind_spaces><label for=ind_spaces>Spaces</label>
	<input type=number id=ind_spaces_count value=2 min=1 max=10>
</p>
</fieldset>
<button id=go>Go</button>
<textarea id=result rows=20 placeholder=result></textarea>
</div>

<script>
"use strict";
const $ = x => document.getElementById(x);

document.addEventListener("DOMContentLoaded", e => {
	$("go").addEventListener("click", q => {
		let en_us = JSON.parse($("en_us").value || "{}");
		let other = JSON.parse($("other").value || "{}");
		
		if($("rm_identical").checked) {
			for(let key in en_us) {
				if(other[key] == en_us[key]) {
					delete other[key];
				}
			}
		}
		
		if($("rm_missing").checked) {
			for(let key of [...Object.keys(other)]) {
				if(!en_us[key]) {
					delete other[key];
				}
			}
		}
		
		let ind = "\t";
		if($("ind_spaces").checked) ind = " ".repeat($("ind_spaces_count").valueAsNumber);
		
		$("result").value = JSON.stringify(other, undefined, ind);
	});
});
</script>

<style>
#area {
	display: flex;
	flex-direction: column;
	align-items: stretch;
	gap: 5px;
}
#area button {
	font-size: 200%;
}
</style>
```

Use cases for "Remove keys matching `en_us`":

* Minecraft supports English variants like `en_gb` and `en_nz`, which only have minor spelling differences compared to `en_us`. Most of the lang entries are identical to `en_us`. 
* Minecraft falls back to `en_us` if it can't find a lang entry.
* We can therefore save a lot of space by removing lang entries from `en_gb.json` that are identical to entries in `en_us.json`.
* (Also handy for cleaning up situations where a translator copy-pastes lang entries from `en_us` into their WIP translation.)

Use case for "Remove keys missing from `en_us`": 

* If a mod is primarily developed in `en_us` and third-party translators contribute translations, when the mod developer removes a key in `en_us` it is possible they'll forget to remove the key from all translations.
* This can cause translation files to build up cruft over time and cause translators to spend time and effort reviewing translations of now-unused content.
* Be careful with this function:
	* This tool can't tell the difference between a key you intended to remove & a key you intended to merely rename.
	* Watch out for things like multiline tooltips, where the mod queries the localization system and uses as many language keys as it can find.
	* Examine a git diff afterwards to make sure nothing important was deleted.

This tool will always remove duplicate lang entries (choosing the *last* one) and reformat the language file, as a side-effect of using browser json utililties.

If the button doesn't do anything, check the browser console; it's either a bug in my code or ill-formatted JSON.
