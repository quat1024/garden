# Season 2 Icon Generator

```{=html}
<form>
<label for=label>Label</label>
<textarea id=label rows=3 cols=10>YOUR
MOD
NAME</textarea>
<label for=background>Background</label>
<input id=background type=color value="#f66151">
<label for=accent>Accent</label>
<input id=accent type=color value="#a51d2d">
<label for=fontsize>Font size (0 for auto)</label>
<input id=fontsize type=number value=100>
</form>

<p>
<canvas id=bigcanvas width=512 height=512></canvas>
</p>

<p>
<canvas id=smallcanvas width=128 height=128></canvas>
</p>

<script>"use strict";
var bigcanvas, smallcanvas;
var label, background, accent, fontsize;

function drawOnto(canvas) {
	const ctx = canvas.getContext("2d");
	const width = canvas.width;
	const height = canvas.height;
	
	//background
	ctx.fillStyle = background.value;
	ctx.strokeStyle = "none";
	ctx.fillRect(0, 0, width, height);
	
	//border
	const thickness = width / 25;
	const wedgeSize = width / 4;
	ctx.lineWidth = thickness * 2; //half the border falls outside the canvas
	ctx.strokeStyle = accent.value;
	ctx.strokeRect(0, 0, width, height);
	
	ctx.beginPath();
	ctx.lineWidth = thickness;
	ctx.moveTo(width - wedgeSize * 1.3, height);
	ctx.lineTo(width, height - wedgeSize * 1.3);
	ctx.stroke();
	//ctx.closePath();
	
	ctx.fillStyle = accent.value;
	ctx.strokeStype = "none";
	ctx.beginPath();
	ctx.moveTo(width, height);
	ctx.lineTo(width - wedgeSize, height);
	ctx.lineTo(width, height - wedgeSize);
	ctx.fill();
	ctx.closePath();
	
	//text
	const lines = label.value.split("\n");
	
	let size = parseInt(fontsize.value);
	if(size == 0) {
		var longestChars = Math.max(...lines.map(line => line.length));
		if(longestChars == 0) longestChars = 1; //pff
		const sizeW = ((width - thickness * 2) * 1.5) / longestChars; //magic jetbrains mono number
		
		const sizeH = ((height - thickness * 2) * 0.9) / lines.length; //magic number
		
		size = Math.min(sizeW, sizeH);
	}

	ctx.fillStyle = accent.value;
	ctx.font = `bold ${size}px "JetBrains Mono"`;
	ctx.textBaseline = "top";
	
	var x = thickness * 2;
	//var y = height / 2 - ((lines.length - 1) * size) / 2 + (size / 3);
	var y = thickness * 2 + (size / 30); //magic jetbrains mono number
	for(const line of lines) {
		ctx.fillText(line, x, y);
		y += size;
	}
}

function go() {
	drawOnto(bigcanvas);
	drawOnto(smallcanvas);
}

function ready() {
	bigcanvas = document.getElementById("bigcanvas");
	smallcanvas = document.getElementById("smallcanvas");
	label = document.getElementById("label");
	background = document.getElementById("background");
	accent = document.getElementById("accent");
	fontsize = document.getElementById("fontsize");
	
	label.addEventListener("input", go);	
	background.addEventListener("input", go);
	accent.addEventListener("input", go);
	fontsize.addEventListener("input", go);
	go();
	
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
