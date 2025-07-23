# Digital gardening

A "digital garden" is somewhere on the internet to put notes and things you find interesting.

I have found gardening more fun than regular website-maintaining, so my entire website is now one big garden.

## My garden

is a [handful of Markdown files](https://github.com/quat1024/garden) assembled with `pandoc` and a shitty [Makefile](makefile). I [edit](/note-notes) it with vscode. It's hosted via github pages; CI runs `make` and serves the contents of the `out` directory. This is fairly spartan; that is intentional.

Using a pandoc "lua filter" I'm able to guess the `<title>` of the page from the first heading on the page (so I don't need to manually set a title), and rewrite intra-doc links (so I can just write `[text](page)` to create a link to `/page.html`). My makefile has a `make push` phony target that commits and pushes for me. This is all in service of making it easier to just *write* without worrying too much about the writing environment.

There are [better formats](https://github.com/jgm/djot) than Markdown, but the most important things are: I don't have to think about it when I type it, and it has easily accessible "tools for thought" (lists, tables, sections) that align with the way I think.

## Why garden

* *Learning in public:* Asking questions, recording the beginner's process. Making mistakes. Looking stupid!
* *Permanence:* Thoughts get lost on microblogging services.
* *Impermanence:* Noone expects a garden to stay static. I can edit and delete pages without bothering people.
* *Selfishness:* It's easier to access my notes if they're on the web.
* *Web 1.0:* It's my website and I can put whatever I damn well want on it, on my own terms. Hows that.

## Why not garden

There's plenty of reasons not to garden. I wrote about some [on my blog](/blog/digital_gardens/).

* *Too public:* You can't write private things in your notes.
* *Complexity:* Hosting notes is tricky and clutters up the repo containing the notes.
* *Headstrong:* You really think people *want* to read your notes?

I also think it's possible to work yourself into a corner trying to make your thoughts too "presentable". Honest thinking is *true* and *messy* and *disorganized*, especially when you are learning something for the first time.

## Their gardens

* I like the famous [wikiblogarden](https://www.todepond.com/wikiblogarden/) by todepond.
* [Una's garden](https://garden.unascribed.com/).
* [Arty's garden](https://garden.arty.gay/).

There's a [subreddit](https://www.reddit.com/r/DigitalGardens/). People seem to like Obsidian? There's a lot of commercial offerings; somehow I feel like that goes against the spirit of the thing.

## Against RSS

This section of my site doesn't have an RSS feed on purpose. When I write here, I don't put on a Web Publisher hat. I'm writing primarily for myself; if web passerbys like riffling through my pages, that's only a bonus. The lack of a feed means I don't feel pressured to write only about things that are "valuable" to my "audience", and I don't feel pressured to avoid writing for the sake of not "spamming people's feeds".

When Cohost closed, a lot of people were bringing up RSS as an alternative to keeping up with their friends online. I was never too fond of that idea because blogging and RSS *does* feel too "formal". A blog post feels like it needs to be an *event* with an introduction, exploration, and tidy conclusion. Not every thought is like that.

> blogging is for finished longform work or whatever. microblogging is for posting your lunch  
>   
> this is a secret third thing  
>   
> centiblogging

## "Gardening" is kind of silly isn't it

Sometimes I look back at this website and think "oh, 'digital gardening', also known as 'putting stuff on your website'". It has a web 1.0 feel to it somehow. The idea of a personal website created by "dumping whatever you want onto it" feels outdated? lately it's like every website needs to be chronological or have a clearly-defined topic or some central gimmick. Is that good or is that growthhacking nonsense