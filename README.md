New incarnation of my dotfiles, plus many more.

For the dotfiles themselves, look at `playbooks/roles/dotfiles/`.


# Deploying against Vagrant #

Ansible will use the `vagrant` user to ssh (I'm using vagrant's public insecure
ssh key because my ssh keys come from a smartcard; this setup seems as less
hassle to me than creating a ssh key just for this and later forgetting about
it).

Once you have lxc-net and resolvconf set up for <container>.lxc, do the usual `vagrant
up`, `vagrant provision`, or if you want:

```bash
$ ansible-playbook playbooks/playbook.yml -i inventories/vagrant
```


# Deploying against production #

Ansible will use the `deploy` user to ssh (see roles/common/vars)

```bash
$ ansible-playbook playbooks/playbook.yml -i inventories/production
```


## Setting up a new host ##

As usual, yadda yadda:

```bash
$ adduser deploy
$ usermod -aG sudo deploy
```

``` bash
$ ssh-copy-id -f playbooks/roles/common/files/deploy.pub <target host>
```


# Building a Stretch image #

If you don't trust the Debian Stretch in Vagrant servers, you can build your own
Stretch lxc image (following the official scripts) and use it for the
Vagrantfile.

Change the Vagrantfile so it is looking for an image called `stretch`.

Inside this repo, do:

```
$ git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
$ sudo make -C debian-vm-templates/custom-lxc-vagrant stretch
$ vagrant up
```
