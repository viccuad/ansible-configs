New incarnation of my dotfiles, plus many more.

For the dotfiles themselves, look at `playbooks/roles/dotfiles/`.


# Using it with Vagrant #

Ansible will use the `vagrant` user to ssh.

Once you have lxc-net and resolvconf set up for <container>.lxc, do the usual `vagrant
up`, `vagrant provision`, or if you want:

```bash
$ ansible-playbook playbooks/playbook.yml -i inventories/inventory-vagr
```


# Using it directly #

Ansible will use the `deploy` user to ssh (see roles/common/vars)

```bash
$ ansible-playbook playbooks/playbook.yml -i inventories/inventory-dev
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
