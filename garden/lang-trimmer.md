# Lang trimmer

Use case:

* Minecraft supports English variants like `en_gb` and `en_nz`, which have minor spelling differences compared to `en_us`.
* Most of the lang entries are identical to `en_us`. Minecraft falls back to `en_us` if it can't find a lang entry.
* We can therefore save a lot of space in the jar by removing lang entries from `en_gb.json` that are identical to entries in `en_us.json`.

```{=html}
<div id=area>
<textarea id=en_us rows=20 placeholder="en_us.json"></textarea>
<textarea id=other rows=20 placeholder="en_gb.json"></textarea>
<button id=go>Go</button>
<textarea id=result rows=20 placeholder=result></textarea>
</div>

<script>
"use strict";
document.addEventListener("DOMContentLoaded", e => {
	document.querySelector("#go").addEventListener("click", q => {
		let en_us = JSON.parse(document.querySelector("#en_us").value || "{}");
		let other = JSON.parse(document.querySelector("#other").value || "{}");
		
		for(let key in en_us) {
			if(typeof other[key] == "string" && other[key] == en_us[key]) {
				delete other[key];
			}
		}
		
		document.querySelector("#result").value = JSON.stringify(other, undefined, "\t");
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

If the button doesn't do anything, check the browser console
