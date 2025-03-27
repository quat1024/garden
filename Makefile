# i dont think im gonna change these anyway...
garden := garden
static := static
out    := out

# surely theres a simpler glob syntax...
garden-sources := $(shell find $(garden) -type f) $(garden)/listing.md
garden-outs    := $(patsubst $(garden)/%.md,$(out)/%.html,$(garden-sources))

static-sources := $(shell find $(static) -type f)
static-outs    := $(patsubst $(static)/%,$(out)/%,$(static-sources))

all: $(garden-outs) $(static-outs) $(out)/pagefind

# listing.md contains links to all files
$(garden)/listing.md: $(subst $(garden)/listing.md,,$(garden-sources))
	mkdir -p $(@D)
	printf "# Listing\n\nAll files in my garden:\n\n" > $(garden)/listing.md
	echo $(basename $(subst $(garden)/,,$(garden-sources))) | sed "s/ /\n/g" | sort | uniq | sed -E "s/(.*)/\* [\1](\/\1)/g" >> $(garden)/listing.md

# create .html files from .md sources using pandoc
$(out)/%.html: $(garden)/%.md mytemplate.html filter.lua
	mkdir -p $(@D)
	pandoc --from=markdown+autolink_bare_uris+raw_attribute $< -o $@ --template=mytemplate.html --lua-filter=filter.lua --mathml

# copy static resources as-is
$(out)/%: $(static)/%
	mkdir -p $(@D)
	cp $< $@
	
# run pagefind after creating all the html files
$(out)/pagefind: $(garden-outs) $(static-outs)
	npx -y pagefind --site $(out)

.PHONY: clean serve open push
clean:
	rm -rf ./out

serve:
	miniserve -v $(out) --index index.html

open:
	start http://[::1]:8080

push:
	git add .
	git commit -m "lazy commit"
	git push