# At Least One Link To Every Single Dealer's Den Vendor At FWA 2025

[This page](https://www.furryweekend.com/dealers-and-artists/) has a list of dealer's den vendors at FWA 2025. But it's an image, not text, and there's no clickable links. So here's my version.

All typos, errors, and ommissions are mine; I prepared this list using some OCR on the image and looking up everyone manually, first on bluesky then on google. Please report errors to me [on Bluesky](https://bsky.app/profile/highlysuspect.agency) or through my email address in the footer. I don't have twitter/instgram and those sites have really aggressive login walls, so I can't verify those accounts (and I am not interested in giving Twitter traffic anyway)

I do not have the capacity to do the artist's alley; there's just so many people and it's unpredictable.

**Heads up:** they just announced they're implementing a [virtual queue system](https://www.furryweekend.com/2025/05/introducing-a-virtual-queue-system-for-fwa2025/) to get into areas like the dealer's den. [People seem upset.](https://bsky.app/profile/furryweekend.com/post/3logxa2i47q2k).

```{=html}

<form id="sortform">
<fieldset><legend>Sort</legend>
<input type=radio id=byvendor name="sortby" checked /><label for=byvendor>Alphabetically</label>
<input type=radio id=bytable name="sortby" /><label for=bytable>By table</label>
</fieldset>
</form>

<script>
document.addEventListener("DOMContentLoaded", _ => {
  const h3s = Array.from(document.querySelectorAll("h3"));

  for(const h3 of h3s) {
    //add link icons inside all the h3s
    const a = document.createElement("a");
    a.className = "frag";
    a.href = "#" + h3.id;
    a.textContent = "🔗";
    h3.prepend(a);
  }
  
  for(const h3 of h3s) {
    //create sections from the implicit structure on the page (kinda awkward)
    let buf = [];
    let next = h3;
    do {
      buf.push(next);
      next = next.nextElementSibling;
    } while(next && next.nodeName != "H3" && next.nodeName != "H2")
    
    const section = document.createElement("section");
    h3.before(section);
    buf.forEach(it => section.appendChild(it));
    
    //put data-xx attributes on each section for easy sorting
    const txt = h3.textContent;
    const dash = txt.indexOf("-");
    const vendor = txt.slice(dash + 1).trim();
    const table = txt.slice(0, dash).trim();
    section.dataset.vendor = vendor.toUpperCase();
    section.dataset.table = table.replaceAll(/[^A-Za-z0-9]/g, ""); //remove the link emoji from the last loop...
  }
  
  //hook up sort buttons
  const coll = new Intl.Collator("en");
  for(const sortMethod of ["byvendor", "bytable"]) {
    const sorter = sortMethod == "byvendor" ?
      (a, b) => coll.compare(a.dataset.vendor, b.dataset.vendor) :
      (a, b) => coll.compare(a.dataset.table, b.dataset.table);
    
    document.getElementById(sortMethod).addEventListener("change", e => {
      for(const sortContainer of Array.from(document.querySelectorAll(".sortcontainer"))) {
        let buf = Array.from(sortContainer.children);
        buf.sort(sorter);
        sortContainer.replaceChildren(...buf);
        
        const target = document.querySelector("h3:target");
        if(target) {
          if(target.scrollIntoViewIfNeeded) target.scrollIntoViewIfNeeded();
          else if(target.scrollIntoView) target.scrollIntoView();
        }
      }
    })
  }
});
</script>

<style>
a.frag {
  margin-right: 0.5em;
  text-decoration: none;
  color: black;
}

a.frag:hover {
  text-decoration: underline;
}

label {
  padding-left:0.5ch;
}

#sortform {
  position: sticky;
  top: 0px;
  padding-top: 1ch;
  background-color: var(--bgcolor);
  z-index: 727;
}

h3 {
  /* guesstimating the height of the form */
  scroll-margin-top: 80px;
}

h3:target {
  background-color: var(--fgcolor);
  color: var(--bgcolor);
}
</style>
```

## Guests

```{=html}
<div class="sortcontainer">
```

### D1 - Ben Diskin

* Wikipedia: https://en.wikipedia.org/wiki/Benjamin_Diskin

### P5 - Charity (Lost-n-Found Youth)

* Website: https://www.lnfy.org/
* About: https://www.furryweekend.com/about/our-charity/

### E1 - Johnathan and Sasha's Big Booth of Doom

* Sasha R Jones' website: https://sasharjones.com/
* Sasha R Jones' Bluesky: https://bsky.app/profile/sasharjones.bsky.social
* Johnathan Vair Duncan's website: https://www.jonathanvair.com/
* Johnathan Vair Duncan's FA: https://www.furaffinity.net/user/stigmata/

### D9 - Jonah Scott

* Wikipedia: https://en.wikipedia.org/wiki/Jonah_Scott

### D2 - Pinkie Toons

* Website: https://www.pinkietoons.com/

### E3 - Red Means Recording

* Website: https://rmr.media/
* Links: https://rmr.media/findme

```{=html}
</div>
```

## Vendors

```{=html}
<div class="sortcontainer">
```

### A7 - A True Blue Artist

* Bluesky: https://bsky.app/profile/atrueblueartist.bsky.social
* Etsy: https://www.etsy.com/shop/aTrueBlueArtist
* FA: https://www.furaffinity.net/user/atrueblueartist/

### Q7 - Aisu Art

* Website: https://www.aisuart.com/
* Bluesky: https://bsky.app/profile/aisuart.com
* FA: https://www.furaffinity.net/user/aisu10/

### C9 - AR.GI.BI. Creative Studio

* Website: https://www.argibi.art/
* Bluesky: https://bsky.app/profile/argibi-art.bsky.social
* FA: https://www.furaffinity.net/user/argibiart/

### P10 - Art By Jinxsis / Pibble Party

* Website: https://www.pibble.party/
  * Store is currently closed for FWA

### Q1 - Art by Oomles

* Website: https://oomles.com/
* Bluesky: https://bsky.app/profile/oomles.bsky.social

### Q10 - Art of Lovewin

* Bluesky: https://bsky.app/profile/lovewin.bsky.social

### B4 - Art of Straya Obscura

* Website: https://artofso.com/
* Bluesky: https://bsky.app/profile/strayaobscura.bsky.social

### L5 - ArtSea Animal

* Website: https://www.artseaanimal.com/
* Bluesky: https://bsky.app/profile/artseaanimal.bsky.social

### P12 - Bewilderium

* Bluesky: https://bsky.app/profile/bewilderium.bsky.social

### R5 - Bewitched Ink

* I think this is their Etsy: https://www.etsy.com/shop/BewitchedInk

### B6 - BigCatDen Crafts

* Website: https://www.bigcatdencrafts.com/
* Bluesky: https://bsky.app/profile/bigcatdencrafts.bsky.social

### B3 - Bison Wares

* Bluesky: https://bsky.app/profile/bisonwares.bsky.social

### C5 - BlindCoyote

* Website: https://www.blindcoyote.com/ (has a linktree)
* Bluesky: https://bsky.app/profile/blindcoyote.com

### R3 - BoldKobold LLC

* Website: https://boldkobold.com/
* Bluesky: https://bsky.app/profile/boldkobold.bsky.social (seems abandoned)

### E7 - CAMP HOWL

* Website: https://www.camphowl.com/
* Bluesky: https://bsky.app/profile/camphowl.com

### P4 - CANIS-INFERNALIS

* Ko fi shop: https://ko-fi.com/canisinfernalis/shop
* Bluesky: https://bsky.app/profile/canisinfernalis.bsky.social

### A6 - Closet Geek

* Website: https://closetgeekllc.com/
* Bluesky: https://bsky.app/profile/closetgeekllc.bsky.social

### Q15 - CloudKBD

* Website: https://www.cloudkbd.com/
* Bluesky: https://bsky.app/profile/cloudkbd.bsky.social

### A4 - Cool Art Corner

* Website: https://www.coolart.store/

### L2 - Cooling Vests by ThermApparel

* Website: https://www.thermapparel.com/
  * they have a dedicated page for furries https://www.thermapparel.com/pages/furry lol

### R2 - Critter Kickback Festival

* Website: https://critterkickback.com/
* Webstore: https://critterkickback-shop.fourthwall.com/

### P11 - CryTime

* Website: https://crytime.art/
* Owner's Bluesky: https://bsky.app/profile/smdefelice.bsky.social

### Q4 - D. Bruin's Art and Prints

* Website: https://www.dbruin.com/ (currently down)
* Bluesky: https://bsky.app/profile/dbruinart.bsky.social
* FA: https://www.furaffinity.net/user/dbruin/

### B2 - Dead Bomb Art

* Website: https://www.deadbomb.com/
* Bluesky: https://bsky.app/profile/deadbombart.bsky.social

### F1 - Deer Hudson Crafts

* Link aggregate: https://deerhudsoncrafts.carrd.co/
* Bluesky: https://bsky.app/profile/deerhudson.bsky.social

### E2 - Fenris Publishing, LLC

* Website: https://www.fenrispublishing.com/
* Bluesky: https://bsky.app/profile/fenrispublishing.bsky.social

### Q3 - Foxclover

* I think this is their Etsy: https://www.etsy.com/shop/Foxclover
* and this might be their Bluesky: https://bsky.app/profile/foxclover.bsky.social
* but I'm not sure

### Q16 - FurBakery

* Bluesky: https://bsky.app/profile/furbakery.bsky.social

### F4 - Furry Flags presents Shifter Outpost

* I believe this is the right website: https://www.inanimorphs.com/

### P8 - FursuitGlasses.com

* Website: https://fursuitglasses.com/

### Q10 - Fuzzimutt

* Website: https://www.fuzzimutt.com/
* Bluesky: https://bsky.app/profile/fuzzimutt.bsky.social

### Q14 - Ghosty5am

* Link aggregate: https://linktr.ee/ghosty5am
* Bluesky: https://bsky.app/profile/ghosty5am.bsky.social

### P2 - Gideon's Corral

* FA: https://www.furaffinity.net/user/gideon/

### R4 - Glitzy Fox Studios

* Bluesky: https://bsky.app/profile/glitzyfox.bsky.social

### P6 - Golden Druid

* Website: https://goldendruid.com/
* Bluesky: https://bsky.app/profile/goldendruid.bsky.social

### A1 - Gremlins Grove

* Etsy: https://www.etsy.com/shop/GremlinsGrove (closed for FWA)
* Bluesky: https://bsky.app/profile/gremlinsgrove.bsky.social

### F2 - Heartleaf Games

* Website: https://thedelversguide.com/
* Bluesky: https://bsky.app/profile/heartleafgames.bsky.social

### C6 - Hey! It's Zray!

* Link aggregate: https://linktr.ee/Zraya
* Bluesky: https://bsky.app/profile/zray.bsky.social

### Q9 - Hibiscus Stitch

* Bluesky: https://bsky.app/profile/hibiscustitch.bsky.social

### Q5 - Inkmaven Art

* Website: https://www.inkmavenart.com/
* Bluesky: https://bsky.app/profile/inkmaven.bsky.social

### A7 - Interlinked Jewelry

* Website: https://www.interlinked-jewelry.com/
* Link aggregate: https://linktr.ee/interlinkedjewelry
* Bluesky: https://bsky.app/profile/interlinkedjewelry.bsky.social
* FA: https://www.furaffinity.net/user/interlinked-jewelry

### P3 - It's Mae Magic

* Link aggregate: https://itsmaemagic.carrd.co/

### R7 - JayeCreations

* Website: https://jayecreations.wixsite.com/jaye
* Link aggregate: https://linktr.ee/JayeCreations
* Bluesky: https://bsky.app/profile/jayecreations.bsky.social

### L6 - Katy Lipscomb LLC

* Website: https://www.katylipscomb.com/
* Link aggregate: https://linktr.ee/katy_lipscomb
* Bluesky: https://bsky.app/profile/katylipscomb.bsky.social

### C3 - Kikidoodle

* Website: https://kikidoodle.com/
* Bluesky: https://bsky.app/profile/kikidoodle.bsky.social

### D7 - King Guro

* Website: https://www.krisstarlein.com/
* Bluesky: https://bsky.app/profile/kingguro.bsky.social

### D3 - Lackofa

* Website: https://www.lackofa.com/
* Link aggregate: https://linktr.ee/lackofa
* Bluesky: https://bsky.app/profile/lackofa.bsky.social

### D5 - Lily Moon Suits

* Bluesky: https://bsky.app/profile/lilymoon-suits.bsky.social

### D4 - Limeythecheetah

* Website: https://limeythecheetah.com/
* Bluesky: https://bsky.app/profile/limeythecheetah.bsky.social

### P1 - LittleArrowDog

* Bluesky: https://bsky.app/profile/littlearrowdog.bsky.social (for adults)
* FA: https://www.furaffinity.net/user/littlearrowdog/

### F5 - LUCKY DRAGON & CO.

* Link aggregate: https://linktr.ee/sploggles (just has twitter on it basically)
* Webstore: https://sploggles.bigcartel.com/products (looks closed?)

### R6 - MangoPopArt

* Website: https://mangopopart.com/
* Bluesky: https://bsky.app/profile/mangopopart.bsky.social

### D8 - MOTEL777

* Website: https://www.motel777.xyz/
* More links: https://www.motel777.xyz/directory
* Bluesky: https://bsky.app/profile/motel777.xyz

### C8 - MR. KITTYS

* Etsy: https://www.etsy.com/shop/itsMRKITTYS
* Bluesky: https://bsky.app/profile/itsmrkittys.bsky.social (seems abandoned)

### A3 - NeonSlushie

* Website: https://www.neonslushie.com/
* Bluesky: https://bsky.app/profile/neonslushie.com

### R1 - Neurotic Sphynx

* Link aggregate: https://neuroticsphynx.carrd.co/
* Etsy: https://www.etsy.com/shop/NeuroticSphynx
* Bluesky: https://bsky.app/profile/ryuuyouki.bsky.social (for adults)
* FA: https://www.furaffinity.net/user/ryuuyouki

### E6 - Onnanoko

Can't find anything active.

### A8 - Otherworldly Alchemist

* Link aggregate: https://owalchemist.carrd.co/
* Website: https://www.otherworldlyalchemist.com/
* Bluesky: https://bsky.app/profile/owalchemist.bsky.social

### P9 - Papaya Badger

* Webstore: https://papayabadger.square.site/
* Link aggregate: https://papayabadger.carrd.co/
* Bluesky: https://bsky.app/profile/papayabadger.com

### Q2 - Paradoxxpalms

* Bluesky: https://bsky.app/profile/paradoxxpalms.bsky.social
* I think this is one webstore: https://payhip.com/paradoxxpalms

### C2 - Pawstar

* Website: https://pawstar.com/
* Bluesky: https://bsky.app/profile/pawstarofficial.bsky.social

### A5 - PawTory Works

* Website: https://www.pawtory.com/
* Bluesky: https://bsky.app/profile/pawtory.bsky.social

### C7 - Peri Pendrake

* Link aggregate: https://peripendrake.carrd.co/
* Bluesky: https://bsky.app/profile/peripendrake.bsky.social
* FA: https://www.furaffinity.net/user/stitchy-face

### P7 - Please Feed the Bear

* Website: https://pleasefeedthebear.com/
* Bluesky: https://bsky.app/profile/plsfeedthebear.bsky.social
* FA: https://www.furaffinity.net/user/candy

### Q6 - Poe Productions

* Website: https://poeproductions.org/
* Bluesky: https://bsky.app/profile/poeproductions.bsky.social

### D6 - Ratty Creations

* Etsy: https://www.etsy.com/shop/RattyCreationsShop
* Bluesky: https://bsky.app/profile/rattycreations.bsky.social

### F6 - Rocky's Roastery Coffee Co.

* Website: https://rockysroastery.com/

### A2 - Rukis Art

* Website: https://www.rukisart.com/
* Bluesky: https://bsky.app/profile/rukis.bsky.social
* FA: https://www.furaffinity.net/user/rukis

### E5 - Rysingson Accessories

* Webshop: https://rysingson-accessories.square.site/

### F3 - Scaly Shop

* Website: https://scaly.shop/
* Bluesky: https://bsky.app/profile/scaly.shop

### E7 - Scragster

* Website: https://clubscragster.com/
* Link aggregate: https://clubscragster.carrd.co/
* Bluesky: https://bsky.app/profile/clubscragster.com

### L1 - She-Jackal Arts

* Website: https://shejackalarts.carbonmade.com/

### C4 - Sorbet Jungle

* Website: https://www.sorbetjungle.com/
* Bluesky: https://bsky.app/profile/sorbetjungle.bsky.social

### F7 - Space Cat Creations

* Link aggregate: https://linktr.ee/spacecatcreations
* Webstore: https://ko-fi.com/spacecatcreations/shop
* Bluesky: https://bsky.app/profile/spacecatcreations.bsky.social

### E4 - STABLERCAKE ART + MERCH

* Website: https://stablercake.com/
* Etsy: https://www.etsy.com/shop/stablercake/ (closed)
* Bluesky: https://bsky.app/profile/stablercake.bsky.social

### A7 - Syko Gear Leather Werx

* Bluesky: https://bsky.app/profile/sykogearleather.bsky.social

### Q12 - The Pirate Artisans

* Website: https://www.pirateartisans.com/
* Bluesky: https://bsky.app/profile/pirateartisans.bsky.social

### P7 - Twining Tree Creations

* Website: https://www.twiningtree.com/
* Bluesky: https://bsky.app/profile/twiningtree.bsky.social

### L4 - Waffle Wishes

* Website: https://wafflewishes.com/

### B1 - Warhorse Workshop - Soap Pony

* Website: https://www.warhorseworkshop.net/ (I [can't connect](https://support.mozilla.org/en-US/kb/secure-connection-failed-firefox-did-not-connect?as=u&utm_source=inproduct))
* Etsy: https://www.etsy.com/shop/deserthorsedesign
* Bluesky: https://bsky.app/profile/warhorseworkshop.bsky.social (inactive)

### L3 - Weasel Gear

* Website: https://www.weaselgear.com/
* Bluesky: https://bsky.app/profile/weaselgear.com

### C1 - Weasels on Easels

* Website: https://www.weaselsoneasels.com/
* Bluesky: https://bsky.app/profile/weaselsoneasels.bsky.social

### B5 - Weighted Wildlife

* Creator's bluesky: https://bsky.app/profile/roaminbison.bsky.social
* Website: https://weightedwildlife.com/

### Q11 - Windy Woods Designs LLC

* Website: https://windywoodsdesigns.com/
* Link aggregate: https://linktr.ee/windywoodsdesigns
* Bluesky: https://bsky.app/profile/windywoodsdesigns.bsky.social

### Q13 - yocholol

* Website: https://yocholol.com/
* Bluesky: https://bsky.app/profile/yocholol.bsky.social

### Q8 - ZENOPHRENIC

* Link aggregate: https://zenophrenic.carrd.co/
* Bluesky: https://bsky.app/profile/zenophrenic.bsky.social

```{=html}
</div>
```

## Adult Vendors

```{=html}
<details>
<summary>Show adult vendors</summary>
<div class="sortcontainer">
```

### AD9 - Bad Dragon

Yeah yeah, whatever, you already know where to find them.

How about [an artist they ripped off](https://bsky.app/profile/tailends.bsky.social) instead?

### AD8 - Bed, Bound, and Beyond

* Website: https://www.bedboundbeyond.com/
* Bluesky: https://bsky.app/profile/bedboundbeyond.bsky.social

### AD5 - Fetish Zone (FZ, LLC.)

* Website: https://www.fetishzone.net/store/
* Bluesky: https://bsky.app/profile/fetishzone.com

### AD2 - Fluff & Stuff (formerly FurryDakimakura)

* Website: https://fluffandstuff.net/
  * https://furrydakimakura.com/ also seems to have exactly the same content
* Bluesky: https://bsky.app/profile/fluffandstuff.bsky.social

### AD1 - Frisky Critters

* Website: https://friskycritters.org/
* Bluesky: https://bsky.app/profile/friskycritters.bsky.social

### AD3 - Naughty by Nature

I can't find them; they share the same name as a hip-hop group which is dwarfing Google results.

### AD6 - Something Squishy Toys

* Website: https://somethingsquishytoys.com/
* Bluesky: https://bsky.app/profile/squishytoys.bsky.social

### AD4 - Stray Toys

* Website: https://straytoys.com/
* Bluesky: https://bsky.app/profile/straytoys.bsky.social

### AD7 - Xenocat Artifacts

* Website: https://shop.xenocat-artifacts.com/
* Bluesky: https://bsky.app/profile/xenocatartifacts.bsky.social

```{=html}
</div>
</details>
```

# Lessons I Have Learned Making This List

* Many people don't seem to know you can use any domain you like as a Bluesky handle, [e.g. my account](https://bsky.app/profile/highlysuspect.agency). Not only does it look nice, it's a de-facto form of verification.
* Some people have a link aggregate (eg. linktree) and also a website, but the link aggregator has links that I can't find while clicking around the website, and then I can't find a link to the linktree from the website either.
* It makes sense to close your webstore during cons, but *also* removing the products from view? That said this could definitely be ecommerce platforms being ecommerce platforms, and they don't offer that feature
* Double-check that your website actually works...!
