# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider :lxc do |lxc|
    lxc.customize 'cgroup.memory.limit_in_bytes', '256M'
  end

  config.vm.provider :libvirt do |libvirt|
    libvirt.nested = true
    libvirt.cpu_mode = "host-model"
    libvirt.memory = 2048
  end

  config.vm.network :private_network, :libvirt__network_name => 'default'

  hostnames = ['router','workstation', 'server', 'offlinepc','desktop', 'laptop', 'nas', 'htpc']
  config.vm.synced_folder ".", "/vagrant", type: "sshfs"

  hostnames.each do |name|
  config.vm.define "#{name}" do |system|
    system.vm.box = "debian/stretch64"
    system.vm.host_name = "#{name}"
    system.ssh.insert_key = false # use insecure_private_key, don't expose VMs outside

    system.vm.provision "ansible" do |ansible|
        ansible.playbook = "#{name}.yml"
        ansible.inventory_path = "inventories/vagrant"
        ansible.limit = "all" # run ansible in parallel for all machines
        ansible.verbose = "v"
        ansible.extra_vars = {
          ansible_ssh_user: 'vagrant',
          ansible_ssh_private_key_file: "~/.vagrant.d/insecure_private_key"
        }
      end
    end
  end

  config.vm.define :desktop do |desktop|
    desktop.vm.host_name = "desktop"
    desktop.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
    end
    desktop.vm.network :private_network,
      :libvirt__network_name => 'lan',
      :ip => "10.30.0.0"
  end

  config.vm.define :nas do |nas|
    nas.vm.host_name = "nas"
    nas.vm.network :private_network,
      :libvirt__network_name => 'lan',
      :ip => "10.30.0.0"
  end

  config.vm.define :router do |router|
    router.vm.host_name = "router"
    router.vm.provider :libvirt do |domain|
      domain.memory = 2048
      domain.cpus = 1
    end
    router.vm.network :private_network,
                      :libvirt__network_name => 'street',
                      :ip => "10.20.0.0"
    router.vm.network :private_network,
      :libvirt__network_name => 'lan',
      :ip => "10.30.0.0"
    router.vm.network :private_network,
      :libvirt__network_name => 'wifi',
      :ip => "10.40.0.0"
    router.vm.network :private_network,
      :libvirt__network_name => 'wifi-guest',
      :ip => "10.41.0.0"
  end

  config.vm.define :laptop do |laptop|
    laptop.vm.host_name = "laptop"
    laptop.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
    end
    laptop.vm.network :private_network,
      :libvirt__network_name => 'wifi',
      :ip => "10.30.0.0"
  end
end
