# aur.git

This is an experimental mirror of the aur.git repository backing [the AUR](https://aur.archlinux.org).

**This is a fork,** to host personalizations of packages.

## as a remote of `~/.cache/yay/$PKG`

Example `.git/config` of `~/.cache/yay/texlive-installer`:

```gitconfig
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	url = https://aur.archlinux.org/texlive-installer.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
## ... above generated by yay
## ... below added by user
[remote "p13n"]
	url = git@github.com:bryango/aur.git
	fetch = +refs/heads/texlive-installer:refs/remotes/p13n/texlive-installer  ## restrict fetch heads
	push = master:texlive-installer  ## push to branch: texlive-installer
[remote]
	pushdefault = p13n               ## push to remote: p13n
```
