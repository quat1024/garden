# Season 2 Icon Generator

Some color picker tools:

* [una's colorspace toy](https://unascribed.com/junk/colorspaces.html)
* [Materal Design colors](https://m2.material.io/design/color/the-color-system.html#tools-for-picking-colors).

```{=html}
<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@700&display=swap" rel="stylesheet">

<form>
<label for=label>Label</label>
<textarea id=label rows=3 cols=10>YOUR
MOD
NAME</textarea>
<label for=background>Background</label>
<input id=background type=color value="#DC8ADD">
<label for=accent>Accent</label>
<input id=accent type=color value="#613583">
<label for=fontsize>Font size (0 for auto)</label>
<input id=fontsize type=number value=0>
<label for=bg>Background (square)</label>
<input id=bg type=file accept="image/*">
<label for=opacity>Bg opacity</label>
<input id=opacity type=range min=0 max=100 value=20>
<label for=txtbg>Text bg over background</label>
<input id=txtbg type=range min=0 max=100 value=0>
<label for=bspace>Banner spaces</label>
<input id=bspace type=checkbox>
</form>

<h2>Mod Menu (128&times;128)</h2>
<p><canvas id=smallcanvas width=128 height=128></canvas></p>

<h2>Neoforge (480&times;120)</h2>
<p><canvas id=bannercanvas width=480 height=120></canvas></p>

<h2>Web (500&times;500)</h2>
<p><canvas id=bigcanvas width=500 height=500 style="border-radius: 83.35px"></canvas></p>
<p>(border-radius on this canvas matches Modrinth)</p>

<script>"use strict";
var bigcanvas, smallcanvas, bannercanvas;
var label, background, accent, fontsize, bg, opacity, txtbg, bspace;

var canvasForBg;

function drawOnto(canvas, wide, round) {
	const ctx = canvas.getContext("2d");
	const width = canvas.width;
	const height = canvas.height;
	
	const thickness = wide ? height / 14 : height / 20;
	const something = wide ? 1.5 : 1.3;
	const wedgeSize = height / 4;
	
	let lines = label.value.split("\n");
	if(wide) lines = [lines.join(bspace.checked ? " " : "")];
	let size = parseInt(fontsize.value);
	if(size == 0) {
		var longestChars = Math.max(...lines.map(line => line.length));
		if(longestChars == 0) longestChars = 1; //pff
		const sizeW = ((width - thickness * 2) * 1.5) / longestChars; //magic number
		const sizeH = ((height - thickness * 2) * 0.9) / lines.length; //magic number
		size = Math.min(sizeW, sizeH);
	}
	
	//font placement
	var x = thickness * 2;
	var y;
	if(wide) {
		ctx.textBaseline = "middle";
		y = height / 2 + (size / 10); //magic jetbrains mono number
	} else {
		ctx.textBaseline = "top";
		y = thickness * 2 + (size / 30); //magic jetbrains mono number
	}
	
	//background color
	ctx.fillStyle = background.value;
	ctx.strokeStyle = "none";
	ctx.fillRect(0, 0, width, height);
	
	//background image
	ctx.globalAlpha = parseFloat(opacity.value) / 100;
	if(wide) {
		const aspect = width / height;
		const sWidth = canvasForBg.width;
		const sHeight = sWidth / aspect;
		const sYStart = canvasForBg.height / 2 - sHeight / 2;
		
		//console.log(`0, ${sYStart}, ${sWidth}, ${sHeight}`);
		ctx.drawImage(canvasForBg,
			0, sYStart, sWidth, sHeight,
			0, 0, width, height);
	} else {
		ctx.drawImage(canvasForBg, 0, 0, width, height);		
	}
	
	//txtbg
	if(!wide) {
		ctx.globalAlpha = parseFloat(txtbg.value) / 100;
		ctx.fillRect(0, 0, width, y + (lines.length * size));
	}
	
	ctx.globalAlpha = 1;
	
	//border
	ctx.lineWidth = thickness * 2; //half the border falls outside the canvas
	ctx.strokeStyle = accent.value;
	ctx.strokeRect(0, 0, width, height);
	if(round) {
		ctx.beginPath();
		ctx.roundRect(0, 0, width, height, width * 0.1667); //from modrinth's css
		ctx.stroke();
	}
	
	ctx.beginPath();
	ctx.lineWidth = thickness;
	ctx.moveTo(width - wedgeSize * something, height);
	ctx.lineTo(width, height - wedgeSize * something);
	ctx.stroke();
	
	ctx.fillStyle = accent.value;
	ctx.strokeStype = "none";
	ctx.beginPath();
	ctx.moveTo(width, height);
	ctx.lineTo(width - wedgeSize, height);
	ctx.lineTo(width, height - wedgeSize);
	ctx.fill();
	ctx.closePath();
	
	//text
	ctx.fillStyle = accent.value;
	ctx.font = `bold ${size}px "JetBrains Mono", monospace`;

	for(const line of lines) {
		ctx.fillText(line, x, y);
		y += size;
	}
}

function go() {
	drawOnto(smallcanvas, false, false);
	drawOnto(bannercanvas, true, false);
	drawOnto(bigcanvas, false, true);
}

function loadBackground() {
	const img = new Image();
	img.src = URL.createObjectURL(bg.files[0]);
	img.onload = () => {
		canvasForBg = new OffscreenCanvas(img.naturalWidth, img.naturalHeight);
		console.log(`Created new offscreen canvas with size (${canvasForBg.width},${canvasForBg.height})`);
		const bgCtx = canvasForBg.getContext("2d");
		bgCtx.clearRect(0, 0, canvasForBg.width, canvasForBg.height);
		bgCtx.drawImage(img, 0, 0, canvasForBg.width, canvasForBg.height);
		
		go();
	};
}

function ready() {
	bigcanvas = document.getElementById("bigcanvas");
	smallcanvas = document.getElementById("smallcanvas");
	bannercanvas = document.getElementById("bannercanvas");
	label = document.getElementById("label");
	background = document.getElementById("background");
	accent = document.getElementById("accent");
	fontsize = document.getElementById("fontsize");
	bg = document.getElementById("bg");
	opacity = document.getElementById("opacity");
	txtbg = document.getElementById("txtbg");
	bspace = document.getElementById("bspace");
	
	canvasForBg = new OffscreenCanvas(128, 128);
	
	label.addEventListener("input", go);	
	background.addEventListener("input", go);
	accent.addEventListener("input", go);
	fontsize.addEventListener("input", go);
	bg.addEventListener("input", loadBackground);
	opacity.addEventListener("input", go);
	txtbg.addEventListener("input", go);
	bspace.addEventListener("input", go);
	go();
	
	//firefox keeping form values
	if(bg.value) loadBackground();
	
	document.querySelector("form").addEventListener("submit", e => e.preventDefault());
}

document.addEventListener("DOMContentLoaded", ready);
</script>

<style>
form {
  display: grid;
  grid-template-columns: max-content max-content;
  gap: 5px 15px;
}
</style>
```
