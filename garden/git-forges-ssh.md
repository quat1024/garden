# SSH and git forges

The process is pretty much the same across Forgejo-ish services and Github.

Codeberg: https://docs.codeberg.org/security/ssh-key/

github: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

Tangled has awful documentation but works pretty much the same.

1. `cd ~/.ssh`.
2. Generate a fresh key with `ssh-keygen -t ed25519 -a 100` or similar.
	* I like to give each key a name and use one key per service, instead of the default `id_ed25519` key
3. Paste the public half of the key (the `.pub` file) into the git forge's settings.
4. In `.ssh/config` (create if it doesn't exist), tell SSH to use the right key when connecting to a host:

   ```
   Host codeberg.org
     HostName codeberg.org
     User git
     IdentityFile ~/.ssh/my-awesome-key
   ```
   
   * `Host codeberg.org` means you can talk about this host using `codeberg.org`, e.g. `ssh codeberg.org` on the command line.
   * Both Forgejo and Github make everyone connect through the same SSH user named `git`. Actual users are differentiated based off the public key. Setting this value in the ssh config file means it doesn't have to be mentioned everywhere, e.g. `ssh codeberg.org` instead of `ssh git@codeberg.org`.
   * IdentityFile sets the key to use for the ssh connection.
   
5. Test the connection with `ssh -T codeberg.org`.
   * `-T` means SSH doesn't do any virtual terminal stuff; makes sense since these git forges don't actually provide a terminal.
   * Tangled doesn't seem to offer a test service.
6. Fix up any git remote URLs.

Codeberg seems to want this format: `ssh://git@codeberg.org/quat/mods.git`

Github (and Tangled) seems to want this format: `git@github.com:quat1024/mods.git` / `git@tangled.sh:highlysuspect.agency/mods`

I am not sure if they are interchangeable after doing some more url-fiddling? prefixing the github-style URL with `ssh://` just broke it.
