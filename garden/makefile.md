# Makefile

The makefile behind the [garden](garden). Not claiming it is any good.

```makefile
# surely theres a simpler glob syntax
garden-sources := $(shell find garden -name "*.md" -type f) garden/makefile.md garden/listing.md
garden-outs    := $(patsubst garden/%.md,out/%.html,$(garden-sources))

static-sources := $(shell find static -type f)
static-outs    := $(patsubst static/%,out/%,$(static-sources))

.PHONY: no-search all

# default target (`make`) excludes pagefind cause it's a little slow. `make all` to get it
no-search: $(garden-outs) $(static-outs)
all: no-search out/pagefind

garden/makefile.md: Makefile
	mkdir -p $(@D)
	printf '# Makefile\n\nThe makefile behind the [garden](garden). Not claiming it is any good.\n\n```makefile\n' > garden/makefile.md
	cat Makefile >> garden/makefile.md
	printf '\n```' >> garden/makefile.md

# listing.md contains links to all files
garden-sources-no-listing := $(subst garden/listing.md,,$(garden-sources))
garden/listing.md: $(garden-sources-no-listing)
	mkdir -p $(@D)
	printf "# Listing\n\nAll files in my garden:\n\n" > garden/listing.md
	echo $(basename $(subst garden/,,$(garden-sources-no-listing))) | sed "s/ /\n/g" | sort | uniq | sed -E "s/(.*)/\* [\1](\/\1)/g" >> garden/listing.md

# create .html files from .md sources using pandoc
out/%.html: garden/%.md mytemplate.html filter.lua
	mkdir -p $(@D)
	pandoc --from=markdown+autolink_bare_uris+raw_attribute $< -o $@ --template=mytemplate.html --lua-filter=filter.lua --mathml --wrap=preserve --highlight-style=kate

# copy static resources as-is
out/%: static/%
	mkdir -p $(@D)
	cp $< $@
	
# run pagefind after creating all the html files
out/pagefind: $(garden-outs) $(static-outs)
	npx -y pagefind --site out

.PHONY: clean serve open push
clean:
	rm -rf ./out

serve:
	miniserve -v out --index index.html

open:
	start http://[::1]:8080

push:
	git add .
	git commit -m "lazy commit"
	git push
```