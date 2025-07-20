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
    out.add("There are " + metas.size() + " posts, but I don't blog as often now that I have the [garden](index).\n\nPlease pardon my dust, still migrating stuff here.");
    out.add("");
    for(Meta m : metas) {
      // \u2b50 -> star
      String pre = m.good ? "\u2b50 **" : m.draft ? "*" : "";
      String post = m.good ? "**" : m.draft ? " (draft)*" : "";
      
      out.add("* " + m.date + " &ndash; " + pre + m.mdLink("blog/", "/") + post);
      if(m.blurb != null) {
        out.add("  ");
        out.add("  > " + m.blurb);
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
    boolean good;
    boolean draft;
    
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
        if(line.startsWith("good:")) m.good = true;
        if(line.startsWith("draft:")) m.draft = true;
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
