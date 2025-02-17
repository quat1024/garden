# OpenBSD signify

OpenBSD's `signify` is a tool for creating and verifying digital signatures. You can read more about the motivation behind it in [this presentation](https://www.openbsd.org/papers/bsdcan-signify.html) and [this post](https://flak.tedunangst.com/post/signify) by Ted Unangst, its creator. Third-parties have ported it to various non-BSD Linuces, typically under a name like `signify-openbsd` due to a name conflict with a random Perl script nobody uses.

I am just a random guy trying to figure out how it works. I am not an expert in cryptography and am not particularly good at Unix either.

The man page is [not *that* bad](https://man.openbsd.org/signify)..!

## Philosophy

* It is a fairly small program, created specifically for the needs of signing OpenBSD releases.
* One signature scheme is supported ([Ed25519](https://ed25519.cr.yp.to/)). As a result, keys are short and sweet; public keys fit comfortably on a QR code.
  * Solves a lot of problems with key distribution. Put it on a T-shirt.
* There is no key-revocation or key-expiry. (Their view is that those systems have their own problems.)

### Crash course in digital signatures

There is a secret key and a corresponding public key. With the secret key and a message to sign, you can create a *signature*. With the public key, the message, and the signature, you can verify that "someone with possession of the corresponding secret key" did indeed sign that exact message.

In practice: you trust that the *trusted party* is the only party with access to the secret key, the public key is widely distributed, and the message to sign is a computer program. Now, verifying a signature answers the question "was this program actually created by the trusted party, or was it modified in transit / did their servers get hacked?"

The reason the secret key cannot be derived from the public key, even though the two correspond, is fascinating, complex, and far above my pay grade.

# Using signify

The verbs are *-G*enerate, *-S*ign, *-V*erify. The nouns are *-p*ublic key, *-s*ecret key, *-m*essage.

* Generating keys requires a public and secret key, so you pass `-p` and `-s`.
* Signing files requires a message and a secret key, so you pass `-m` and `-s`.
* Verifying signatures requires a message and a public key, so you pass `-m` and `-p`.

You always need to label all arguments with these flags. There are no positional arguments. 

## Generating a keypair

Generate a keypair with `signify -G -p mykey.pub -s mykey.sec`.

You must use the naming convention `something.pub` and `something.sec` (for chosen values of `something`). Do not rename the files.

### Passphrases

`signify` will prompt for a passphrase. The passphrase is mixed into the secret key when signing: you need both the secret key *and* the correct passphrase to create a signature. This is the standard 2-factor security model: something you know (the phrase) and something you have (the secret key file).

If you do not want to provide a passphrase, pass `-n` when generating the key. But now anyone with possession of *only* the secret key can sign files as you. Consider your security model.

## Signing a file

Use `mykey.sec` to sign `message.txt` by running `signify -S -s mykey.sec -m message.txt`. If you provided a passphrase when generating the key, you will need to enter it now.

This creates a file `message.txt.sig`. Signing the same file with the same key will produce the same signature.

## Verifying a signature

To verify the signature of `message.txt` with `mykey.pub`, ensure that `message.txt.sig` exists alongside it, then run `signify -V -p mykey.pub -m message.txt`.

If the signature is correct, `signify` will print `Signature Verified` and exit with status 0. Otherwise it will print `signature verification failed` or some such and fail.

# Other things

That's enough to get started creating and verifying signatures. Here are some more things to know.

## Comments

When generating a keypair or signing a file, you may pass `-c "some comment"` to write a comment inside the key or signature files. Even after you create a key or signature, you may freely edit the comment with a normal text editor.

You may not *deface* the `untrusted comment: ` prefix that signify adds to your comment; this is a reminder to users that the comment is *not* inside the security boundary. Editing comments won't break the signature!

## "Embed mode"

Passing `-e` enables "embed mode", which changes where signatures go.

When signing, passing `-e` causes the `.sig` file to contain the signature information, concatenated before a copy of the original message.

When verifying a signature -- let's say you verify `message.txt` using `signify -V -e -m message.txt`.

* Normally `signify` reads the signature from  `message.txt.sig`, reads the message from `message.txt`, verifies the signature, and if and only if the signature is valid, exits with status 0.
* In embed mode, `signify` reads the signature from `message.txt.sig`, reads the message from all the trailing data in `message.txt.sig` (!), verifies the signature, and if and only if the signature is valid, *writes* the message to `message.txt` and exits with status 0.

Basically signing with `-e` turns the `.sig` into a signature + message container; verifying with `-e` "tears off" the signature and restores the original message. Now you don't need to distribute separate `something` and `something.sig` files -- assuming the file format allows junk at the beginning (like `.zip`), or you're okay with *requiring* users to verify the signature before using the file.

## Checklists

Generally in OpenBSD *hashes* of files are signed, not the files themselves. This is because both the OpenBSD `sha256` and the GNU `sha256sum` utilities support *checklists*, which are big checksum files containing the checksums for multiple other files at once.

Signing the checklist file is like signing all the files. The hash of each file is in the checklist, and the checklist is signed, so tampering with any file changes its hash, which would require updating this checklist file, which would break the signature -- a chain of trust. (Compare and contrast this method with signing a tarball.)

Here's the first five lines of [the AMD64 OpenBSD 7.6 checklist.](https://cdn.openbsd.org/pub/OpenBSD/7.6/amd64/SHA256.sig)

```
untrusted comment: verify with openbsd-76-base.pub
RWTkuwn4mbq8okbCvgY+qxWC/1SYi0ggMn1vYNE1mhfJQT3pyI5p0S7ykHcztKuPH5sujPe0nuZZTLEkF6RRVLG+2B7VoKKRkwM=
SHA256 (BOOTIA32.EFI) = d247251fbde091a12fc37c61e2aca158a9fe9bb503caa21659a5779e68137307
SHA256 (BOOTX64.EFI) = 63a0651534bcab13f6a5eddd022ece146a2fc725f2b05c85b03ccc6c93694579
SHA256 (BUILDINFO) = 7dce27e41a01ddca0b137af3f1392dede6a712103d0ed6fc58781bca7669acf2
```

