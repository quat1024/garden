# ssh keys

magic folder, `~/.ssh`.

* on a windows computer it's in %USERPROFILE%
* on a linux computer it's a hidden directory

ssh structure:

* client/server
* as the ssh client, you connect to an ssh server

.ssh on the client:

* `config`, configuration for your ssh client
* generally it's a dumping ground for keys too

.ssh on the server:

* `authorized_keys`, public keys who are permitted to log on, one per line

making an ssh keypair

* cd into your .ssh folder
* run `ssh-keygen`
* flag `-t ed25519`: newer cryptography method
* flag `-f some_filename`: pick a more understandable filename
* flag `-C "some comment"`: write a comment into the file so you remember what the key is for
* `ssh-keygen -t ed25519 -f some_filename -C "some comment"`

understanding an ssh keypair

* you get two files, `my_key` and `my_key.pub`
* the file with no extension is the private key. it's like a password
* the file with `.pub` is a public key. it's like a username
* in reality:
  * if a message is encrypted with the public key, it can be decrypted only with the private key
  * this means, a server can encrypt some arbitrary message with your public key, then *ask you what the message was*, and if you can answer correctly, it proves you have the private key
  * isn't that interesting

ok but how do i use this to log in

* two things need to happen:
  * tell your client to offer your public key to the server
  * tell your server that the owner of this public key is authorized to connect
* offering the key can be done thru the command line, but it's frequently done through the .ssh/config file
* authorizing the key to the server is done by adding the public key to `.ssh/authorized_keys` on the server
* one authorized key per line
* additional wrinkle: the ssh server wants to ensure that noone else can read or write your authorized_keys file (if anyone could write to it, anyone would be able to add themself to the authorized list)
  * ssh-copy-id automatically does it
  * all it does is ssh into the remote and run this script https://github.com/openssh/openssh-portable/blob/master/contrib/ssh-copy-id#L288
* get familiar with `ssh -v`. this causes your client to spam about what it's doing


this is now just about ssh-copy-id - it's just a shell script actually, lol

* line 42-62: check that the shell works (just shell things)
* line 65: set DEFAULT_PUB_ID_FILE to the first `.pub` file it can find in your .ssh directory
* line 85 is "use_id_file"
  * does some checks (that the corresponding private key is readable, that you specified a public key not a private key), then sets GET_ID to a program that reads the file
* line 117-180: arg parsing
* tells you what key it's going to upload
* line 204: using a scratch file (because it's a shell script and there's no good datatypes...)
* line 213: try to login with all keys and if login *succeeds*, ignore it
  * this means the key is already uploaded
* line 278: installkeys_sh
  * this is where the "magic" happens
  * basically it produces a oneliner to run on the target machine that creates the authorized_keys file with the correct permissions (if it does not exist), cats the contents of stdin into the authorized_keys file, then runs `restorecon` on it if the program exists (apparently req'd for SELinux stuff)
  * not really sure where the keys get piped in tho...?