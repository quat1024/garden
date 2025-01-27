# i dont think im gonna change these anyway...
garden := garden
static := static
out    := out

# surely theres a simpler glob syntax...
garden-sources := $(shell find $(garden) -type f)
garden-outs    := $(patsubst $(garden)/%.md,$(out)/%.html,$(garden-sources))

static-sources := ${shell find $(static) -type f}
static-outs    := $(patsubst $(static)/%,$(out)/%,$(static-sources))

# target
all: $(garden-outs) $(static-outs)

# use pandoc to convert .md to .html files
$(out)/%.html: $(garden)/%.md mytemplate.html filter.lua Makefile
	mkdir -p $(@D)
	pandoc --from=markdown+autolink_bare_uris $< -o $@ --template=mytemplate.html --lua-filter=filter.lua

# copy the rest as-is
$(out)/%: $(static)/%
	mkdir -p $(@D)
	cp $< $@

.PHONY: clean serve open
clean:
	rm -rf ./out

serve:
	miniserve -v $(out) --index index.html

open:
	start http://[::1]:8080
