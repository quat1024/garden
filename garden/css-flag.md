# annoyingly overengineered css-only pup flag

Dimensions and proportions eyeballed from [here](http://www.puppyprideflag.com/). Uses a lot of ill-advised CSS grid and `border-radius` shenanigans.

```{=html}

<p>
<input type=checkbox id=dbg><label for=dbg>Debug colors</label>
<input type=checkbox id=rsz><label for=rsz>Make it resizable</label>
</p>

<style>
.flag {
  width: 100%;
  aspect-ratio: 5/3;
  outline:5px solid black;
}

.pup {
  --blue: rgb(23, 23, 150);
  --red: rgb(235, 38, 41);
  --black: black;
  --white: white;
  background: linear-gradient(30deg,
    black       0%,
    black       calc(2 / 19 * 100%),
    var(--blue) calc(2 / 19 * 100%),
    var(--blue) calc(4 / 19 * 100%),
    black       calc(4 / 19 * 100%),
    black       calc(6 / 19 * 100%),
    var(--blue) calc(6 / 19 * 100%),
    var(--blue) calc(8 / 19 * 100%),
    white       calc(8 / 19 * 100%),
    white       calc(11 / 19 * 100%),
    var(--blue) calc(11 / 19 * 100%),
    var(--blue) calc(13 / 19 * 100%),
    black       calc(13 / 19 * 100%),
    black       calc(15 / 19 * 100%),
    var(--blue) calc(15 / 19 * 100%),
    var(--blue) calc(17 / 19 * 100%),
    black       calc(17 / 19 * 100%),
    black       100%
  );
  display: grid;
  grid-template-columns: 0.8fr minmax(250px, 1fr) 0.8fr;
  grid-template-rows: 1fr minmax(40px, 17%) 1fr;
}

.pup .bone {
  display: block;
  grid-area: 2/2/3/3;
  background-color: var(--red);
  position: relative;
  overflow: visible;
}

.pup .bone .knobpos {
  position: absolute;
  left: 0;
  top: -25%;
  height: 150%;
  aspect-ratio: 1/2;
  overflow:visible;
  
  display: grid;
  grid-template-areas: "a" "b";
}

.pup .bone .knobpos.right {
  left: unset;
  right: 0;
  transform:rotate(180deg);
}

.pup .bone .knobpos .knob {
  transform:translateX(-50%);
  width:100%;
  aspect-ratio:1/1;
  background-color: var(--red);
  border-radius:100%;
  
  grid-area: a;
  & + .knob {
    grid-area: b;
  }
}

.pup .bone .knobpos .extr {
  transform:translateX(-50%);
  height:100%;
  aspect-ratio:3/2;
  background: linear-gradient(to right, transparent 0%, transparent 50%, var(--red) 50%);
  border-radius:100% 120% 100% 100%;
  
  grid-area: a;
  & + .extr {
    grid-area: b;
    border-radius: 100% 100% 120% 100%;
  }
}

body:has(#dbg:checked) {
  .pup .bone .knobpos {
    background-color: rgba(250, 250, 50, 0.5);
    .knob {
      --red: pink;
    }
    .extr {
      --red: rgba(0,255,0,0.5);
    }
  }
}

body:has(#rsz:checked) {
  .flag {
    overflow: hidden;
    resize: both;
  }
}
</style>
<div class="flag pup">
<div class="bone">
<div class="knobpos">
<div class="knob"></div><div class="knob"></div>
<div class="extr"></div><div class="extr"></div>
</div>
<div class="knobpos right">
<div class="knob"></div><div class="knob"></div>
<div class="extr"></div><div class="extr"></div>
</div>
</div>
</div>
```