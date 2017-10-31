New incarnation of my dotfiles, plus many more.

For the dotfiles themselves, look at the roles being used in the `dotfiles.yml`
playbook.


# Dependencies #

```
vagrant vagrant-libvirt vagrant-sshfs ansible
```


# Deploying against Vagrant #

```bash
vagrant up
```

or if you want to call ansible outside of vagrant:

```bash
$ ansible-playbook all.yml -i inventories/vagrant -vv
```


# Deploying against production #

Ansible will use the `deploy` user to ssh (see roles/common/vars).

```bash
$ ansible-playbook all.yml -i inventories/production
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
