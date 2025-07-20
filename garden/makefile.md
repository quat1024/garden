# Makefile

The makefile behind the [garden](garden). Not claiming it is any good.

```makefile
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
$(tool-out): MakeIndex.java
	javac "$<" -d "$(@D)"

# quine?
garden/makefile.md: Makefile MakeIndex.java
	printf '# Makefile\n\nThe makefile behind the [garden](garden). Not claiming it is any good.\n\n```makefile\n' > "$@"
	cat Makefile >> "$@"
	printf '\n```\n\n## `MakeIndex.java`\n\n```java\n' >> "$@"
	cat MakeIndex.java >> "$@"
	printf '\n```' >> "$@"

# garden listing, using a trick to make it only outdated when the list of files change, i don't care about the actual contents.
# cf. https://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes
# the listing itself is generated with the java tool
garden-sources-no-listing := $(filter-out garden/listing.md,$(garden-sources))
tmp/listing-dirty: FORCE
	$(if $(filter-out $(shell cat "$@" 2>/dev/null),$(shell echo "$(garden-sources-no-listing)" | shasum)),echo "$(garden-sources-no-listing)" | shasum > $@)
garden/listing.md: tmp/listing-dirty $(tool-out)
	java -cp $(tool-out) MakeIndex gardenListing "garden/" "$@"

# blog listing, using the same trick and the same tool
blog-sources-no-index := $(filter-out blog/index.md,$(blog-sources))
tmp/blog-listing-dirty: FORCE
	$(if $(filter-out $(shell cat "$@" 2>/dev/null),$(shell echo "$(blog-sources-no-index)" | shasum)),echo "$(blog-sources-no-index)" | shasum > $@)
garden/blog/index.md: tmp/blog-listing-dirty $(tool-out)
	java -cp $(tool-out) MakeIndex blogListing "blog/" "$@"

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
	
# run pagefind after creating all the html files
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

# fake target that's the opposite of .PHONY (perpetually out-of-date)
FORCE:
```

## `MakeIndex.java`

```java
import java.io.*;
import java.util.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.nio.file.attribute.*;

class MakeIndex {
  public static void main(String[] args) throws IOException {
    System.out.println("hello");
    
    if(args[0].equals("gardenListing")) {
      writeGardenListing(get(args[1]), get(args[2]));
    } else if(args[0].equals("blogListing")) {
      writeBlogListing(get(args[1]), get(args[2]));
    } else {
      throw new RuntimeException("unknown op " + args[0]);
    }
    System.out.println("Done");
  }
  
  static Path get(String arg) {
    return Paths.get(arg).toAbsolutePath().normalize();
  }
  
  static void writeGardenListing(Path gardenSrc, Path listingMd) throws IOException {
    System.out.println("gardenSrc: " + gardenSrc);
    System.out.println("listingMd: " + listingMd);
    
    List<Meta> metas = readMetas(gardenSrc).stream()
      .sorted(Meta::compareByTitle)
      .toList();
    
    List<String> out = new ArrayList<>();
    out.add("# Listing");
    out.add("");
    out.add("There are currently <b>" + metas.size() + "</b> files in the garden.");
    out.add("");
    for(Meta m : metas) out.add("* " + m.mdLink());
    
    Files.createDirectories(listingMd.getParent());
    Files.write(listingMd, out, StandardCharsets.UTF_8);
    //System.out.println(String.join("\n", out));
  }
  
  static void writeBlogListing(Path blogSrc, Path blogListingMd) throws IOException {
    System.out.println("blogSrc: " + blogSrc);
    System.out.println("blogListingMd: " + blogListingMd);
    
    List<Meta> metas = readMetas(blogSrc).stream()
      .peek(it -> {
        if(it.date == null) throw new IllegalArgumentException("Post at '" + it.bareUrl + "' has no date");
      })
      .sorted(Meta::compareByDate)
      .toList();
    
    List<String> out = new ArrayList<>();
    out.add("# Blog");
    out.add("");
    for(Meta m : metas) {
      out.add("* " + m.date + " &ndash; " + m.mdLink("blog/", "/"));
      if(m.blurb != null) {
        out.add("  ");
        out.add("  " + m.blurb);
      }
      out.add("");
    }
    Files.createDirectories(blogListingMd.getParent());
    Files.write(blogListingMd, out, StandardCharsets.UTF_8);
    //System.out.println(String.join("\n", out));
  }
  
  static class Meta {
    String bareUrl;
    String title;
    String date;
    String blurb;
    
    int compareByTitle(Meta other) {
      return title.toLowerCase(Locale.ROOT).compareTo(other.title.toLowerCase(Locale.ROOT));
    }
    
    int compareByDate(Meta other) {
      return -date.compareTo(other.date);
    }
    
    String mdLink() {
      return mdLink("", "");
    }
    
    String mdLink(String pre, String post) {
      return "[" + escapeForMdLink(title) + "](" + pre + escapeForMdLink(bareUrl) + post + ")";
    }
  }
  
  static Meta readMeta(Path base, Path md) throws IOException {
    Meta m = new Meta();
    m.bareUrl = fwdString(chopExtension(chopStart(base, md)));
        
    boolean yamlMode = false;
    for(String line : Files.readAllLines(md)) {
      if("---".equals(line)) {
        yamlMode = !yamlMode;
        continue;
      }
      if(yamlMode) {
        if("...".equals(line)) {
          yamlMode = false;
          continue;
        }
        if(line.startsWith("title:")) m.title = line.substring(6).trim();
        if(line.startsWith("date:")) m.date = line.substring(5).trim();
        if(line.startsWith("blurb:")) m.blurb = line.substring(6).trim();
      }
      
      //parse titles out of the first heading in the document
      if(m.title == null && !yamlMode && line.startsWith("#")) {
        do { line = line.substring(1); } while(line.startsWith("#"));
        m.title = line.trim();
      }
    }
    
    if(m.title == null) m.title = m.bareUrl;
    
    return m;
  }
  
  static List<Meta> readMetas(Path dir) throws IOException {
    List<Meta> m = new ArrayList<>();
    Files.walkFileTree(dir, new SimpleFileVisitor<Path>() {
      @Override
      public FileVisitResult visitFile(Path md, BasicFileAttributes attrs) throws IOException {
        if(!md.toString().endsWith(".md")) return FileVisitResult.CONTINUE;
        m.add(readMeta(dir, md));
        return FileVisitResult.CONTINUE;
      }
    });
    return m;
  }
  
  /// path math ///
  
  // start:  /a/b/c/
  // sub:    /a/b/c/something/foo.txt
  // result: something/foo.txt
  static Path chopStart(Path start, Path sub) {
    return sub.subpath(start.getNameCount(), sub.getNameCount());
  }
  
  static Path chopExtension(Path p) {
    String filename = p.getFileName().toString();
    int dot = filename.indexOf('.');
    if(dot == -1) return p;
    else return p.resolveSibling(filename.substring(0, dot));
  }
  
  //Always use / as the path separator even on windows >.>
  static String fwdString(Path p) {
    StringBuilder b = new StringBuilder(p.getName(0).toString());
    for(int i = 1; i < p.getNameCount(); i++) b.append('/').append(p.getName(i).toString());
    return b.toString();
  }
  
  /// markdown gunk ///
  
  static String escapeForMdLink(String s) {
    return s.replace("(", "\\(").replace(")", "\\)").replace("[", "\\[").replace("]", "\\]");
  }
}

```