[![pipeline status](https://gitlab.com/viccuad/ansible-configs/badges/master/pipeline.svg)](https://gitlab.com/viccuad/ansible-configs/commits/master)


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

## Deploying nested VMs inside a *dotfiles* VM ##

The *dotfiles* VM deployed with this *ansible-configs* project is already
prepared for nested KVM. Remember that the host needs to have enabled nested KVM
(you can achieve this by applying the libvirt task or dotfiles role).

If you want to spawn nested vagrant VMs inside a *dotfiles* VM, do:

```bash
$ VAGRANTNESTED=yes vagrant up dotfiles
```

(This will deploy your vagrant *dotfiles* VM with a different setup of the
libvirt management network interface. For more info, look at the `vagrantfile`)

Now you can login into the *dotfiles* VM, and there you can either deploy again
this project or any other vagrant project normally.


# Deploying against production #

Ansible will use the `deploy` user to ssh (see roles/common/vars).

Install the private roles with:

```bash
# ansible-galaxy install -r galaxy-roles.yml --roles-path ./roles --force
```

and then run the playbooks:

```bash
$ ansible-playbook --vault-password-file=vault_pass.sh --ask-become-pass -i inventories/production/hosts all.yml --limit=<host> --check
```

To decrypt/encrypt the vault:

```bash
$ ansible-vault encrypt inventories/production/group_vars/all/vault.yml --vault-password-file=vault_pass.sh
```

Or run just one role:
```bash
$ ansible localhost -m include_role -args var=foo --become --ask-become-pass
```

## Setting up a new host ##

Yadda yadda:

```bash
$ adduser deploy # empty password to disable login by password
$ usermod -aG sudo deploy
$ echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
$ apt install sudo # if minimal installation
```

``` bash
$ ssh-copy-id -f -i roles/bootstrap/files/vic.pub deploy@<target host>
 # or do it by hand if no password set up
```

# Deploying against *localhost* when host is not on inventory #

Whether you are aiming for the vagrant or the production deployment, what you
need to do is just add *localhost* under the correct group in
`inventories/{vagrant,production}/hosts`. For example:

``` bash
    [dotfiles]
    adotfiles ansible_host=192.168.111.2 ansible_private_key_file=.vagrant/machines/dotfiles/libvirt/private_key
 -> localhost
    [dotfiles:children]
    desktop
```

And then run the normal deployment, in this case:

```bash
$ ansible-playbook --vault-password-file=vault_pass.sh --ask-become-pass -i inventories/production/hosts -vv dotfiles.yml --check
```

or
```bash
$ ansible-playbook -i inventories/vagrant/hosts -vv dotfiles.yml
```

I have chosen this approach so one can select whatever playbook to be
applied to localhost, and at the same time minimize errors when applying
playbooks locally.


# Creating your own Debian image #

Change the Vagrantfile so it is looking for an image called `local/buster`.
Inside this repo, do:

```bash
$ git clone https://salsa.debian.org/cloud-team/vagrant-boxes.git
$ sudo make -C vagrant-boxes/vmdebootstrap-libvirt-vagrant buster
$ vagrant box add vagrant-boxes/vmdebootstrap-libvirt-vagrant/buster.box --name local/buster
$ sudo rm -rf vagrant-boxes/vmdebootstrap-libvirt-vagrant/*.box
```


# Running gitlab-ci tests in your local machine #

``` bash
$ sudo apt install docker.io gitlab-ci-multi-runner
$ docker login registry.gitlab.com # with a valid token
$ gitlab-ci-multi-runner exec docker <test-to-run>
```
