# How I put pagefind on the site

There's a neat little tool called [pagefind](https://pagefind.app/) which allows your fully static site to have full-text search. I thought the process of [integrating it here](search) was surprisingly easy.

For context: I have an ersatz static site generator. I am writing in a markdown file right now, use `pandoc` to process them into HTML, and orchestrate the whole thing with a Makefile. But none of the Pagefind integration process required touching markdown or pandoc, since it indexes the HTML output I already produce as part of my static site generator.

## Running pagefind

The [quick start guide](https://pagefind.app/docs/) is very helpful. I just run `npx -y pagefind`, passing `--site out` since my website's html files are built in the `./out` directory.

This populates `./out/pagefind` with two kinds of file:

* compressed search indexes, in `pagefind/index/<stuff>.pf_index` and `pagefind/fragment/<stuff>.pf_fragment`
* an implementation of the search bar HTML widget, in `pagefind/pagefind-ui.js` and `pagefind/pagefind-ui.css`

## Integrating the widget

Then, all you need to do is include the stylesheet and the Javascript file on your webpage. This code:

```html
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="loading">Loading...</div>
<div id="search"></div>
<script>
window.addEventListener('DOMContentLoaded', (event) => {
  new PagefindUI({ element: "#search", showSubResults: true });
  document.getElementById("loading").remove();
});
</script>
```

produces this widget:

```{=html}  
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="loading">Loading...</div>
<div id="search"></div>
<script>
window.addEventListener('DOMContentLoaded', (event) => {
  new PagefindUI({ element: "#search", showSubResults: true });
  document.getElementById("loading").remove();
});
</script>
```

The sample HTML on pagefind's quick start page does not include the `Loading...` element. I added it so that if the page is loading slowly or if JS is turned off, people will know something is up.

## Tweaking what is indexed

I was worried that pagefind would index the footer, so searching `Back to garden entrance` would hit every page on the site. But it turns out pagefind automatically skips elements like `<nav>` and `<footer>`. Cool. It looks like [this is the full list of automatically-skipped elements](https://github.com/CloudCannon/pagefind/blob/d7d0b3a0f0eb12661cd2eb894ad02f10687a4ca0/pagefind/src/fossick/parser.rs#L31-L34).

There are config options; you can pass a CSS selector of elements to skip, or to index exclusively. You can also pepper `data-pagefind-` attributes directly into the HTML, which of course gums up the HTML a bit, but it's easier.

## Makefiles

This site is built with [a makefile](https://github.com/quat1024/garden/blob/trunk/Makefile). I am very much a makefile beginner.

I added the directory `$(out)/pagefind` to the `all` phony rule, so that running `make all` attempts to build `$(out)/pagefind`. Then I added a makefile rule to create this directory by running `npx -y pagefind`.

```makefile
$(out)/pagefind: $(garden-outs) $(static-outs)
  npx -y pagefind --site $(out)
```

Here `garden-outs` and `static-outs` are variables expanding to every HTML page generated using other rules. Pagefind needs to index these HTML files, so it can only run after they are generated.

Finally I noticed that pagefind can be a little slow. So I created another phony rule `no-search` which doesn't run pagefind. This way when I run `make` locally, it will skip pagefind, but in CI (or if I just want the Pagefind JS and CSS files locally) I can run `make all`.

```makefile
no-search: $(garden-outs) $(static-outs)
all: no-search $(out)/pagefind
```

## N.b.

Despite the `npx`, pagefind is not actually written in JS, they're just misusing npm as a convenient distribution mechanism. You can [install the binary](https://pagefind.app/docs/installation/) if you want.

The pagefind quick start guide mentions a `--serve` parameter. I think if you are dealing with a static site generator, you probably already have some way to serve the results locally (i have a `make serve` which runs [`miniserve`](https://github.com/svenstaro/miniserve)).

As far as I know, the pagefind `--serve` option is not any different from any other serving option... but it looks like some kind of ["pagefind playground"](https://github.com/CloudCannon/pagefind/blob/d7d0b3a0f0eb12661cd2eb894ad02f10687a4ca0/pagefind/src/serve.rs) is in the works. Ooh.