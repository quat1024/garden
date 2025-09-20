# Working with multiple remotes in Git

## goal

I want to push the same project to multiple git forges.

* one remote per git forge: `codeberg`, `sleeping`, `tangled`, maybe even `github`, etc
* a remote called `all` where `git push all` pushes to all the remotes

## beforehand

You'll need your git committer email address to be something all of the Git forges accept.

Generally this means you can't use, say, github `noreply` faux-emails.

## on remotes

Basically:

* Git remotes can have more than one push URL.
* There's no rule against two different remotes sharing the same push URL.
* Git remotes can specify different URLs for fetching and pushing.

If you want to use multiple git forges, merging *everything* into a single mega-remote isn't the best solution, since you usually want to pull from just one (checking out a contributor's branch, manually syncing things back up, etc)

Being able to specify different fetch/push URLs is sort of a newer git feature I think. By default a remote contains one `url` which is used for fetching and pushing. You may also specify some `pushUrl`s which will be used instead of `url` for pushing. The `url` option is mandatory, so all remotes have a fetch URL whether you want it or not. If you don't want a fetch URL, something like `file:///dev/null` or `https://google.com` will satisfy the config schema but won't actually work.

## Commands

* `git remote add <name> <url>` to add a remote, as usual
	
* `git remote set-url --add <name> <url>` to add a new fetch URL (pulling)
	* add `--push` to add a push url

## getting familiar with `.git/config`

After `git remote add remoteone http://google.com`:

```
[remote "remoteone"]
	url = http://google.com
	fetch = +refs/heads/*:refs/remotes/remoteone/*
```

`google.com` is currently the fetch and push URL of this remote.

`fetch` is a "refspec", [documented here](https://git-scm.com/docs/git-fetch#Documentation/git-fetch.txt-refspec).

* I don't know what the `+` prefix means.
* Before the colon is `refs/heads/*` and after the colon is `refs/remotes/remoteone/*`. This defines a mapping between my local branches (in `refs/heads/`) and branches fetched from the remote (which would go in `refs/remotes/remoteone/`... if this was a real git remote)

After `git remote -u remoteone/trunk` (setting the upstream branch of `trunk` to `remoteone/trunk`)

```
[remote "remoteone"]
	url = http://google.com
	fetch = +refs/heads/*:refs/remotes/remoteone/*
[branch "trunk"]
	remote = remoteone
	merge = refs/heads/trunk
```

Branch "trunk" `remote` is [documented here](https://git-scm.com/docs/git-config#Documentation/git-config.txt-branchnameremote), `merge` is documented a few lines below.

(since `google.com` is not actually a git remote, this needed a plumbing command described below)

## trying this on a real project

Here's a project I've had set up for a while. It's on github :pensive:

```
[remote "origin"]
	url = https://github.com/quat1024/mods
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "trunk"]
	remote = origin
	merge = refs/heads/trunk
```

Let's start mirroring this to codeberg or something.

First i'll rename the remote from `origin` to `github` with `git remote rename origin github`. Now the file looks like this.

```
[remote "github"]
	url = https://github.com/quat1024/mods
	fetch = +refs/heads/*:refs/remotes/github/*
[branch "trunk"]
	remote = github
	merge = refs/heads/trunk
```

and several refs have been updated on my local repo.

Next i'll log into codeberg and create a new repository through the interface, then `git remote add codeberg <url>`.

```
[remote "github"]
	url = https://github.com/quat1024/mods
	fetch = +refs/heads/*:refs/remotes/github/*
[branch "trunk"]
	remote = github
	merge = refs/heads/trunk
[remote "codeberg"]
	url = https://codeberg.org/quat/mods.git
	fetch = +refs/heads/*:refs/remotes/codeberg/*
```

So `trunk` is still doing remote-tracking stuff from `github`. I guess I have to pick one?

Can push to codeberg with `git push codeberg`. Nice.

Did the same thing with tangled. Can push to tangled with `git push tangled`. Nice.

Clean this up: `git remote remove github`. This also removed the `[branch "trunk"]` section since it doesn't know its remote-tracking branch.

### making an `all` remote

Make the remote with a bogus fetch URL and add two push URLs to it.

```
git remote add all file:///dev/null
git remote set-url --add --push all "ssh://git@codeberg.org/quat/mods.git"
git remote set-url --add --push all "git@tangled.sh:highlysuspect.agency/mods"
```

```
[remote "codeberg"]
	url = ssh://git@codeberg.org/quat/mods.git
	fetch = +refs/heads/*:refs/remotes/codeberg/*
[remote "tangled"]
	url = git@tangled.sh:highlysuspect.agency/mods
	fetch = +refs/heads/*:refs/remotes/tangled/*
[remote "all"]
	url = file:///dev/null
	fetch = +refs/heads/*:refs/remotes/all/*
	pushurl = ssh://git@codeberg.org/quat/mods.git
	pushurl = git@tangled.sh:highlysuspect.agency/mods
```

Moment of truth:

```
quat@moon:~/dev/mc/mods$ git push -u all trunk
branch 'trunk' set up to track 'all/trunk'.
Everything up-to-date
Welcome to Tangled's hosted knot! 🧶
branch 'trunk' set up to track 'all/trunk'.
Everything up-to-date
```

Nice. Now my git config has this in it:

```
[branch "trunk"]
	remote = all
	merge = refs/heads/trunk
```

## other commands i learned

i knew about `git push -u <remote> <branch>` which does two things

1. sets `<remote>` as the "upstream" for branch `<branch>` (locally)
2. pushes the branch to the remote (which creates the corresponding branch on the remote)

i didn't know about `git branch -u <remote>/<branch>`, which only does the first one, *iff* the branch already exists on the remote. (specifically, the necessary condition is that your local git has to know about the remote's branch, which may require a `git fetch <remote>` to refresh things)

there is a way to manually tell git yes, don't worry kitten, there is a branch on that remote -- *but* i really doubt it'd work on real git remotes

```
# do not use this
git update-ref refs/remotes/<remote>/<branch> HEAD
```
