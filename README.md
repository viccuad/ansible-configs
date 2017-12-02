New incarnation of my dotfiles, plus many more.

# Where are your dotfiles? #

Look at the [roles][roles] that the `dotfiles` role depends onto, [here][dotfiles]

[roles]: https://github.com/viccuad/ansible-configs/tree/master/roles
[dotfiles]: https://github.com/viccuad/ansible-configs/blob/master/roles/dotfiles/meta/main.yml


# Dependencies #

```bash
$ apt install vagrant vagrant-libvirt vagrant-sshfs ansible
```

# Deploying against Vagrant #

```bash
$ vagrant up
```

or if you want to call ansible outside of vagrant:

```bash
$ ansible-playbook -i inventories/vagrant/hosts -vv all.yml
```


# Deploying against production #

Ansible will use the `deploy` user to ssh (see roles/common/vars).

```bash
$ ansible-playbook --vault-password-file=vault_pass.sh -i inventories/production/hosts all.yml --check
```

To decrypt/encrypt the vault:
```bash
$ ansible-vault encrypt vault.yml --vault-password-file=../../../../vault_pass.sh
```


## Setting up a new host ##

Yadda yadda:

```bash
$ adduser deploy # empty password to disable login by password
$ usermod -aG sudo deploy
$ echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
```

``` bash
$ ssh-copy-id -f -i roles/bootstrap/files/vic.pub deploy@<target host>
```


# Creating your own Buster image #

Change the Vagrantfile so it is looking for an image called `buster.box`.
Inside this repo, do:

```bash
$ git clone https://anonscm.debian.org/git/cloud/debian-vm-templates.git
$ sed -i 'Ns/.*/DISTRIBUTIONS = jessie stretch buster sid/' debian-vm-templates/vmdebootstrap-libvirt-vagrant/Makefile
$ sudo make -C debian-vm-templates/vmdebootstrap-libvirt-vagrant buster
$ vagrant box add buster.box --name buster.box
$ rm buster.box
$ vagrant up
```
