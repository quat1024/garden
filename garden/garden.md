# Digital gardening

Just somewhere on the internet to put notes and things you find interesting.

## My garden

is a [handful of Markdown files assembled with `pandoc` and a shitty Makefile](https://github.com/quat1024/garden). I edit it with vscode. It's hosted via github pages; CI runs `make` and serves the contents of the `out` directory.

Using a pandoc "lua filter" I'm able to guess the `<title>` of the page from the first heading on the page (so I don't need to manually set a title), and rewrite intra-doc links (so I can just write `[text](page)` to create a link to `/page.html`). Pandoc lua filters are pretty interesting!

I don't use it yet but I've been thinking about the `djot` format designed by the pandoc guy. It's a little bit better than markdown. Although the format supporting enough "tools for thought" to write useful notes is more important than the format being ideologically elegant or whatever.

## Why garden

* *Learning in public:* Asking questions, recording the beginner's process. Making mistakes. Looking stupid.
* *Permanence:* Thoughts get lost on microblogging services.
* *Impermanence:* Noone expects a garden to stay static. I can edit and delete pages without bothering people.
* *Selfishness:* It's easier to access my notes if they're on the web.
* *Web 1.0:* It's my website and I can put whatever I damn well want on it, on my own terms. Hows that.

## Why not garden

There's plenty of reasons not to garden. I wrote about them [on my blog](https://highlysuspect.agency/posts/digital_gardens/).

* *Too public:* You can't write private things in your notes.
* *Complexity:* Hosting notes is tricky and clutters up the repo containing the notes.
* *Headstrong:* You really think people *want* to read your notes?

## Their gardens

I like the famous [wikiblogarden](https://www.todepond.com/wikiblogarden/) by todepond. They just [write html](https://html.energy) and dont bother with this whole site-generator crap. Commendable.

There's a [subreddit](https://www.reddit.com/r/DigitalGardens/). People seem to like Obsidian. I don't use Obsidian but that's cool.