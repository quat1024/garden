# No, we're not destroying software

Sigh. [The C programmers at at it again.](https://antirez.com/news/145)

> We are destroying software with complex build systems.

Well, yeah, I've worked with Gradle too. However, everyone's darling child *make* does not remain a "simple" build system for long; the people who [switched GHC to a `shake`-based program](http://simonmar.github.io/bib/papers/shake.pdf) (PDF) reported this:

```make
$1/$2/build/%.$$($3_osuf) : \
    $1/$4/%.hs $$(LAX_DEPS_FOLLOW) \
    $$$$($1_$2_HC_DEP) $$($1_$2_PKGDATA_DEP)
  $$(call cmd,$1_$2_HC) $$($1_$2_$3_ALL_HC_OPTS) \
    -c $$< -o $$@ \
    $$(if $$(findstring YES,$$($1_$2_DYNAMIC_TOO)), \
        -dyno $$(addsuffix .$$(dyn_osuf),$$(basename $$@)) )
  $$(call ohi-sanity-check,$1,$2,$3,$1/$2/build/$$∗)
```

*Real* software is more than a couple C89 files and a makefile.

The makefile I use for this garden is somewhat atrocious as well. I'm not claiming this is *good* `make`, just -- these are the things that tend to happen when you use macro-expansion systems. `echo -e` didn't work on Github Actions so I had to replace it with `printf`; regular expressions, so "elegant" and "beautiful", further sullied by peppering them with backslashes; basename subst garden comma comma dollar slash parens; awkwardly building Markdown lists out of sticks and rocks because I'm working at the level of text (but unix pipes are so elegant, right?).

```make
# listing.md contains links to all files
$(garden)/listing.md: $(subst $(garden)/listing.md,,$(garden-sources))
	mkdir -p $(@D)
	printf "# Listing\n\nAll files in my garden:\n\n" > $(garden)/listing.md
	echo $(basename $(subst $(garden)/,,$(garden-sources))) | sed "s/ /\n/g" | sort | uniq | sed -E "s/(.*)/\* [\1](\/\1)/g" >> $(garden)/listing.md
```

God help me if I ever put a space in a filename. These "elegant" programs are dragging us back into the world of "special characters".

I agree that the version of Make that exists in my head is an elegant system. The Make that actually exists is not.

> We are destroying software with an absurd chain of dependencies, making everything bloated and fragile.

JS guys have litigated this for decades at this point; I can't say anything that hasn't already been said. Taking on dependencies without thinking sure is "destroying" software IMO, but using them *at all* is not. People do actually care about bundle sizes in the JS world.

I sometimes see C guys bringing up their ecosystem's terrible packaging story as evidence against *all* dependencies -- sorry you have trouble with dependencies, the rest of us are fine though!

> We are destroying software telling new programmers: "Don’t reinvent the wheel!". But, reinventing the wheel is how you learn how things work, and is the first step to make new, different wheels.

Reinventing the wheel *is* how you learn how things work, yes. Which is why new programmers reinvent wheels all the time, both as part of education, as part of hobby projects, and yes even in production. Point is I don't think this is a real thing people say to the degree of dogmaticism that this guy seems to think.

> We are destroying software pushing for rewrites of things that work.

Oh but I thought you wanted people to reinvent the wheel?

These thoughts together don't form a coherent ideology, so I'm willing to bet "please reinvent wheels" came from a perspective of the C programming world, and "don't rewrite working things" came from the "complaining about Rust" world, which is surprisingly populous for some reason. Having the cake and rewriting it too!

> We are destroying software claiming that code comments are useless.

Literally whooooooooooooo

> We are destroying software by making systems that no longer scale down: simple things should be simple to accomplish, in any system.

"Scaling down" is highly contextual. People fall into a trap of making snap judgements about (e.g.) web framework complexity, by comparing how complicated the `<h1>hello world!</h1>` program is to set up. This would be a great way to judge software complexity if all we did was write hello world programs, and is just like if you judged framework performance entirely on microbenchmarks.

## You're cherrypicking

Yes, because I agree with some points (hate this *move-fast break-things* ethos), the spirit behind others, and also five of the points are just rehashed versions of "don't take dependencies" so I didn't want to repeat all of them

## In short

* C programmer is upset other languages excel at things C doesn't. Full story at 11.
* "Software Considered Harmful" Considered Harmful Considered Harmful (Considered Harmful)
* Kill your heroes I guess.