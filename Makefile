garden-special := garden/makefile.md garden/listing.md garden/blog/index.md
garden-sources := $(shell find garden -name "*.md" -type f) $(garden-special)
garden-outs    := $(patsubst garden/%.md,out/%.html,$(garden-sources))

blog-sources   := $(shell find blog -name "*.md" -type f)
blog-outs      := $(patsubst blog/%.md,out/blog/%/index.html,$(blog-sources))

static-sources := $(shell find static -type f)
static-outs    := $(patsubst static/%,out/%,$(static-sources))

outs           := $(garden-outs) $(blog-outs) $(static-outs)
slow-outs      := out/pagefind

tool-out       := tmp/tool/

$(shell mkdir -p out)
$(shell mkdir -p tmp)

# remove some ancient make cruft by defining this as empty...
.SUFFIXES:

# default target (`make`) excludes pagefind cause it's a little slow. `make all` to get it
.PHONY: no-search all
no-search: $(outs)
all: no-search $(slow-outs)

# a java tool, because sometimes you need a real programming language, not bash >.>
$(tool-out)/Tool.class: Tool.java
	javac "$<" -d "$(@D)"

# quine?
garden/makefile.md: Makefile Tool.java
	printf '# Makefile\n\nThe makefile behind the [garden](garden). Not claiming it is any good.\n\n```makefile\n' > "$@"
	cat Makefile >> "$@"
	printf '\n```\n\n## `Tool.java`\n\n```java\n' >> "$@"
	cat Tool.java >> "$@"
	printf '\n```' >> "$@"

# garden listing, using a trick to make it only outdated when the list of files change, i don't care about the actual contents.
# cf. https://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes
# the listing itself is generated with the java tool
garden-sources-no-listing := $(filter-out garden/listing.md,$(garden-sources))
tmp/listing-dirty: FORCE
	$(if $(filter-out $(shell cat "$@" 2>/dev/null),$(garden-sources-no-listing)),echo "$(garden-sources-no-listing)" > $@)
garden/listing.md: tmp/listing-dirty $(tool-out)/Tool.class
	java -cp $(tool-out) Tool gardenListing "garden/" "$@"

# blog listing, using the same trick and the same tool
blog-sources-no-index := $(filter-out blog/index.md,$(blog-sources))
tmp/blog-listing-dirty: FORCE
	$(if $(filter-out $(shell cat "$@" 2>/dev/null),$(blog-sources-no-index)),echo "$(blog-sources-no-index)" > $@)
garden/blog/index.md: tmp/blog-listing-dirty $(tool-out)/Tool.class
	java -cp $(tool-out) Tool blogListing "blog/" "$@"

# garden files (pattern rule)
out/%.html: garden/%.md mytemplate.html filter.lua
	mkdir -p $(@D)
	pandoc --from=markdown+autolink_bare_uris+raw_attribute $< -o $@ --template=mytemplate.html --lua-filter=filter.lua --mathml --wrap=preserve --highlight-style=kate --variable=quat_filename="$<"

# blog files (pattern rule that just has slightly different path math? eugh)
out/blog/%/index.html: blog/%.md mytemplate.html filter.lua
	mkdir -p $(@D)
	pandoc --from=markdown+autolink_bare_uris+raw_attribute $< -o $@ --template=mytemplate.html --lua-filter=filter.lua --mathml --wrap=preserve --highlight-style=kate --variable=quat_filename="$<"

# copy static resources as-is (pattern rule)
out/%: static/%
	mkdir -p $(@D)
	cp $< $@
	
# run pagefind nly oafter creating html files
out/pagefind: $(outs)
	npx -y pagefind --site out

.PHONY: clean serve open push
clean:
	rm -rf ./out
	rm -rf ./tmp
	rm $(garden-special)

serve:
	miniserve -v out --index index.html

open:
	start http://[::1]:8080

push:
	git add .
	git commit -m "lazy commit"
	git push

# fake perpetually out-of-date target, used by the listing trick
FORCE: