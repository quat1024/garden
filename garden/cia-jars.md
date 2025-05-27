# CIA jars?

How I got here:

* This 404 media article: https://www.404media.co/the-cia-secretly-ran-a-star-wars-fan-site/
* links to this knowledge database by Ciro Santilli: https://ourbigbook.com/cirosantilli/cia-2010-covert-communication-websites
* in it, he [mentions](https://ourbigbook.com/cirosantilli/cia-2010-covert-communication-websites#jar-reverse-engineering): "TODO it would be cool to have a look at the JARs and see if they have anything in common that makes for a good fringerprint. Would not help find new ones, but would help to confirm possible hits."

I work on modded Minecraft stuff so I happen to be somewhat decent at reversing Java. Jars are simply zips of classes and Java classes are famously easy to decompile. I'll be using [fabricmc/Enigma](https://github.com/fabricmc/enigma) to work around the obfuscated class names; it's a tool we use in modded Minecraft to pick names for obfuscated classes, fields, and methods.

## Initial thoughts

In modded Minecraft we often deal with [ProGuard](https://www.guardsquare.com/proguard) output. Proguard tends to put all the classes in the same package;  you'd have a "flat" structure like this.

```
./a.class
./b.class
./c.class
```

This isn't the structure found in these jars. These jars do contain a package structure, even though the packages are also renamed to one-letter names. So these jars were probably not obfuscated with ProGuard.

I'm not familiar with other Java obfuscator products used in the 2010-2013ish period in question.

## Newsupdatesite jar

I downloaded this jar: https://web.archive.org/web/20110208072027/http://newsupdatesite.com/update.jar

The manifest:

```
Manifest-Version: 1.0
Ant-Version: Apache Ant 1.7.1
Created-By: 1.5.0_17-b04 (Sun Microsystems Inc.)
```

(with three blank lines at the end).

[The `<applet>` tag on newsupdatesite.com](https://web.archive.org/web/20110208071716/http://newsupdatesite.com/) embeds the jar like this:

```
<applet archive="/web/20110208071716oe_/http://newsupdatesite.com/update.jar" code="a.a.a.c" height="0" mayscript="true" width="0">
  <param name="education" value="5000"><param name="computers" value="5000"><param name="medicine" value="5000"><param name="science" value="5000"></applet>
```

So `a.a.a.c` is probably a good place to start looking

## String obfuscation

In `a.a.a.c` (which I renamed to `AppletMain`) I see evidence of string obfuscation.

Here is a portion of the `static { }` block of that class, as decompiled with Vineflower.

```java
	static {
		String[] var10000 = new String[6];
		char[] var10003 = "}po\u0006\u000eRo.7\u0018\u0019n$\"\u0014XG".toCharArray();
		int var10005 = var10003.length;
		char[] var10004 = var10003;
		int var7 = var10005;

		for (int var1 = 0; var7 > var1; var1++) {
			char var10007 = var10004[var1];
			byte var10008;
			switch (var1 % 5) {
				case 0:
					var10008 = 55;
					break;
				case 1:
					var10008 = 35;
					break;
				case 2:
					var10008 = 65;
					break;
				case 3:
					var10008 = 86;
					break;
				default:
					var10008 = 124;
			}

			var10004[var1] = (char)(var10007 ^ var10008);
		}

		var10000[0] = new String(var10004).intern();
    //... more string deobfucation loops like this one...
```

`var10000` is a name Vineflower invented. At the end of the `static { }` block, the string array is assigned to a `private static String[] z` (seems to always be called `z`) and these strings are always used instead of string literals everywhere in the jar.

This string obfuscation is painfully easy to defeat. Everything is nicely self-contained and you can simply copy-and-paste the decompiled code into something like `jshell`.

It might be fun to do some dynamic analysis using something like Objectweb ASM to strip out everything from the jar other than the obfuscated strings then just let the code run to see what the strings are. Then rewrite accesses to the `z` array to include string literals.

## Base64

`c/a/c.class` appears to be a Base64 encoder and decoder. An obfuscated string in a decoding routine decodes to `The given byte array is not base64 encoded.`. I don't see any hits on google or github for this specific string.

## Curious coding style involving one-element arrays

For example, `c/b/a/b.class` contains a `boolean[1]` array. On class initialization the single array element is set to `false`, and in `finalize` the array element is set to `true`. So I named the class `ThreadWithFinalizeCheck`.

Also `c/b/d.class` contains a similar `InputStream[]`, `ByteArrayOutputStream[]`, and `IOException[]` which are taken as constructor parameters. The class itself is a thread (extending `ThreadWithFinalizeCheck`) and only uses the first element of each of these arrays.

Using single-element arrays is a *rare* Java programming idiom to work around the language's lack of pointers. Idiomatic Java *very* rarely uses this pattern -- usually only to work around Java 8 lambda capture rules ("final or effectively final"). This code predates Java 8 though and I have never seen this pattern used all throughout a Java codebase like this. This makes me think whoever wrote this code was more familiar with C / C++ idioms about pointers.

## Pre-Java 1.4 exception cause handling

Here is `b/a/a/a.class`, renamed by me to `JSONException` since I found it inside JSON handling code. Variable names are also mine.

```java
public class JSONException extends Exception {
	private Throwable cause;

	public JSONException(String message) {
		super(message);
	}

	public JSONException(Throwable cause) {
		super(cause.getMessage());
		this.cause = cause;
	}
}
```

Ever since Java 1.4, exceptions can be *caused by* other exceptions; see https://docs.oracle.com/javase/8/docs/api/java/lang/Exception.html#Exception-java.lang.String-java.lang.Throwable- . But this `Throwable` constructor doesn't correctly propagate its argument as the *cause* of the JSONException.

So maybe this code dates to before Java 1.4. Or maybe it is simply incorrect and the author didn't know about the new exception causality stuff.

(later): I found it. This class is https://github.com/stleary/JSON-java/blob/JSON-java-1.4/JSONException.java . This is part of the "official" JSON reference implementation for Java by Douglas Crockford. It dates before Java 1.4.

## `applet.configs`

Here are some interesting looking classes I teased apart. All names are mine.

`XorObfuscator` is `a/a/b/a.class`

```java
public class XorObfuscator {
	public static byte[] unXorObfuscate(byte[] bytes) {
		long var1 = checksumFirstEightBytes(bytes);
		return unXorObfuscate(var1, bytes);
	}

	private static byte[] unXorObfuscate(long seed, byte[] bytes) {
		byte[] var3 = ByteUtils.slice(bytes, 8, bytes.length - 8);
		Random var4 = new Random(seed);
		byte[] var5 = new byte[var3.length];
		var4.nextBytes(var5);
		byte[] var6 = new byte[var3.length];

		for (int var7 = 0; var7 < var3.length; var7++) {
			var6[var7] = (byte)(var5[var7] ^ var3[var7]);
		}

		return var6;
	}

	private static long checksumFirstEightBytes(byte[] bytes) {
		byte[] var1 = ByteUtils.slice(bytes, 0, 8);
		return ByteUtils.someKindOfChecksumMaybe(var1);
	}
}
```

```java
public class ByteUtils {
  
  //...
  
	public static long someKindOfChecksumMaybe(byte[] bytes) {
		long var1 = 0L;
		long var3 = 255L;
		int var5 = 8;
		if (bytes == null) {
			bytes = new byte[0];
		}

		if (bytes.length < var5) {
			var5 = bytes.length;
		}

		for (int var6 = 0; var6 < var5; var6++) {
			long var7 = ((long)bytes[var6] & var3) << var6 * 8;
			var1 += var7;
		}

		return var1;
	}

	public static byte[] slice(byte[] bytes, int pos, int len) throws ArrayIndexOutOfBoundsException {
		if (pos + len <= bytes.length && len >= 0) {
			byte[] var3 = new byte[len];
			System.arraycopy(bytes, pos, var3, 0, var3.length);
			return var3;
		} else {
			throw new ArrayIndexOutOfBoundsException(obfuscatedStrings[2]);
		}
	}
  
  //...
}
```

The file `applet.configs` is deobfuscated with the function I named `XorObfuscator.unXorObfuscate`, i.e. the first eight bytes are read, fed through that funny function `someKindOfChecksumMaybe`, and fed into a `java.util.Random` to make a little one-time pad for xoring the rest of the file against.

Here is a deobfuscated copy of `applet.configs` using this method.

```
#Applet Properties
#Fri Feb 05 12:04:29 EST 2010
Applet.BundleSize=2
ResponseKey.UserData.0.Size=89
ResponseKey.UserData.2.Size=40
ResponseKey.TextItem=textType
RequestKey.UserData.0.Size=92
RequestKey.Count=COUNT
ResponseKey.Index=id
Applet.ThreadName=Updater-zwikzwoq
Applet.Categories=education;computers;medicine;science;
ResponseKey.UserData.2=bvbbie
ResponseKey.UserData.1=azhfokgem
ResponseKey.UserData.0.Encoding=base64
Servlet.Url=/servlet/Feeds
ResponseKey.UserData.0=qazzzvozbnx
ResponseKey.Description=detail
RequestKey.UserData.1=lbzfbab
RequestKey.UserData.0=puoicji
ResponseKey.TextData=title
Response.Zip=set
ResponseKey.UserData.1.Encoding=base64
ResponseKey.UserData.1.Size=44
RequestKey.IndexId=id
RequestKey.UserData.1.Size=44
ResponseKey.Link=loc
RequestKey.UserData.0.Encoding=base64
ResponseKey.ImageItem=IMG
ResponseKey.UserData.2.Encoding=base64
JS.PreLoad.Method=getnewsimages
ResponseKey.ImgUrl=imageREF
RequestKey.Offset.IsQuery=set
RequestKey.Count.IsQuery=set
RequestKey.UserData.1.Encoding=base64
RequestKey.Category=group
RequestKey.Offset=idx
Request.Zip=set
JS.Update.Method=newsupdate
Applet.MinCache=2
```

Maybe worth noting that the class that ends up driving the parsing of this file, `a/a/a/b.class` (which I named simply "AppletConfigs"), first checks `MANIFEST.MF` for a key named "Settings". If it is present, that file is loaded instead. Otherwise the adjacent `applet.configs` file is loaded. It is always deobfuscated in the same way

## Work in progress mappings

Are available at https://codeberg.org/quat/cia .

## string notes

I haven't written that objectweb asm deobfuscator so I'm doing it manually by copy-pasting things into jshell. There aren't a lot of classes in the jar. This really feels like some sort of off-the-shelf string obfuscator tool but I don't know which one.

Class name on the left - the class name inside the real jar, class name on the right - my choice of class name. The number, colon, and space are mine, everything else is from the jar.

### `a.a.a.c` / `a.a.a.AppletMain`

```
0: JS.PreLoad.Method
1: JS.Update.Method
2: Servlet.Url
3: Applet.Categories
4: Applet.MinCache
5: Applet.ThreadName
```

### `a.a.a.b.d`

```
0: UTF8
1: Content-Type
2: application/json
3: GET
4: POST
5: gzip
6: Content-Encoding
7: Accept-Encoding
8: RequestKey.Count
9: RequestKey.Category
10: RequestKey.Offset
11: RequestKey.IndexId
12: RequestKey.Category.IsQuery
13: RequestKey.IndexId.IsQuery
14: RequestKey.UserData.
15: ResponseKey.Index
16: .IsQuery
17: RequestKey.Offset.IsQuery
18: Request.Zip
19: ResponseKey.ImageItem
20: Response.Zip
21: .Size
22: ResponseKey.TextItem
23: ResponseKey.ImgUrl
24: RequestKey.Count.IsQuery
25: ResponseKey.Description
26: Applet.BundleSize
27: ResponseKey.TextData
28: ResponseKey.UserData.
29: ResponseKey.Link
```

### `a.a.a.d`

```
0: applet.configs
1: Settings
2: /META-INF/MANIFEST.MF
```

### `a.a.a.e`

```
0: Thread-
1: ' border='0'/>
2: </a>
3: ' alt='
4: <img src='
5: <a href='javascript:void(0)' onclick='window.open("
6: ","w")'>
```

I haven't figured out what this class is good for yet, but there are hints of

* `<img src='` var4.d() `' alt='` var4.b() `' border='0'/>`
* `<a href='javascript:void(0)' onclick='window.open(` ax.c() `","w")'>` var3 `</a>`

### `b.a.a.b`

```
0: ] not found.
1: JSONArray[
2: ] is not a JSONObject.
3: A JSONArray text must start with '['
4: Expected a ',' or ']'
```

### `b.a.a.c`

```
0: A JSONObject text must end with '}'
1: Expected a ':' after a key
2: Expected a ',' or '}'
3: A JSONObject text must begin with '{'
4: null
5: Bad value from toJSONString: 
6: JSON does not allow non-finite numbers
7: JSON does not allow non-finite numbers.
8: Null pointer
9: ] not found.
10: JSONObject[
11: ] is not a JSONArray.
12: \b
13: \t
14: ""
15: \u
16: \r
17: \n
18: 000
19: \f
20: Null key.
```

Ok, these strings are matching classes from `org.json`, eg https://github.com/stleary/JSON-java/blob/master/src/main/java/org/json/JSONObject.java .

### `b.a.a.g`

```
0: Unterminated string
1: Substring bounds error
2: true
3: ,:]}/\"[{;=#
4: false
5: null
6: Missing value.
7:  of 
8:  at character 
9: Unclosed comment.
```

String 3 is: comma, colon, right square bracket, right curly brace, forward slash, back slash, double quote, left square bracket, left curly brace, semicolon, equals, number sign. I don't trust my website to not mangle that string lol.

### `c.a.c` / `c.a.Base64`

```
0: The given byte array is not base64 encoded.
```

### `c.b.c`

```
0: StreamReader
1: Unable to read stream fully within alloted time.
2: Slice size out of range.
```

### `c.b.d`

```
0: Error reading stream caused by: 
```

### `c.b.a.c`

```
0: This method is not supported.
```

This class is an `ObjectInput` and `ObjectOutput` throwing this string as a `new IOException` in most of the methods

### `c.b.a.d`

```
0: No HostHook defined to read from.
1: No HostHook defined to write to.
2: The given object is not assignable to a java.io.ObjectInput class
```

Extends `c.b.a.c`

