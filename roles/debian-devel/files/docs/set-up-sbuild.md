## Create chroots ##

See set-up-pbuilder-for-reproduc
Or alternatively, run sbuild-debian-developer-setup(1)

Or if you want to use apt-cacher-ng proxy, already set up:

## Test ##

Download hello package and build it
```
sudo sbuild -d unstable hello
```

```
sudo sbuild-createchroot --include=eatmydata,ccache,gnupg unstable /srv/chroot/unstable-amd64-sbuild http://127.0.0.1:3142/deb.debian.org/debian
```

## Destroy chroots ##

See
```
sudo sbuild-destroychroot unstable
```

## Update chroots ##

Update chroot with sbuild-update(1)
```
sudo sbuild-update -udcar update #update, distupgrade, clean, autoremove
```

## Clean chroots ##

Sometimes you can end up with dangling chroot sessions potentially taking up valuable system resources (find them with `schroot -l --all`). This command is useful:

```
sudo schroot --end-session --all-sessions
```
