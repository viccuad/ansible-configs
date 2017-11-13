New incarnation of my dotfiles, plus many more.

# Where are your dotfiles? #

Look at the [roles][roles] that the `dotfiles` role depends onto, [here][dotfiles]

[roles]: https://github.com/viccuad/ansible-configs/tree/master/roles
[dotfiles]: https://github.com/viccuad/ansible-configs/blob/master/roles/dotfiles/meta/main.yml


# Dependencies #

```
apt install vagrant vagrant-libvirt vagrant-sshfs ansible
```


# Deploying against Vagrant #

```bash
vagrant up
```

or if you want to call ansible outside of vagrant:

```bash
$ ansible-playbook -i inventories/vagrant -vv all.yml
```


# Deploying against production #

Ansible will use the `deploy` user to ssh (see roles/common/vars).

```bash
$ ansible-playbook -i inventories/production all.yml
```


## Setting up a new host ##

Yadda yadda:

```bash
$ adduser deploy
$ usermod -aG sudo deploy
```

``` bash
$ ssh-copy-id -f roles/common/files/deploy.pub <target host>
```


# Creating your own Stretch image #

Change the Vagrantfile so it is looking for an image called `stretch.box`.
Inside this repo, do:

```
git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
sudo make -C debian-vm-templates/custom-lxc-vagrant stretch
vagrant box add stretch.box --name stretch.box
rm stretch.box
vagrant up
```


# Creating your own Buster image #

Change the Vagrantfile so it is looking for an image called `buster.box`.
Inside this repo, do:

```
git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
sed -i 'Ns/.*/DISTRIBUTIONS = jessie stretch buster sid/' debian-vm-templates/vmdebootstrap-libvirt-vagrant/Makefile
sudo make -C debian-vm-templates/vmdebootstrap-libvirt-vagrant buster
vagrant box add buster.box --name buster.box
rm buster.box
vagrant up
```
