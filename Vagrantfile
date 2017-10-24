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

  hostnames = ['aworkstation', 'aserver', 'anofflinepc','arouter', 'adesktop', 'alaptop', 'anas', 'ahtpc']

  hostnames.each do |name|
  config.vm.define "#{name}" do |system|
    system.vm.box = "debian/stretch64"
    system.vm.host_name = "#{name}"
    system.ssh.insert_key = false # use insecure_private_key, don't expose VMs outside
    end
  end

  config.vm.define :adesktop do |desktop|
    desktop.vm.host_name = "adesktop"
    desktop.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
    end
  end

  config.vm.define :arouter do |router|
    router.vm.host_name = "arouter"
    router.vm.provider :libvirt do |domain|
      domain.memory = 2048
      domain.cpus = 1
    end
  end

  # Run Ansible provisioner once for all VMs at the end
  # config.vm.provision "ansible" do |ansible|
  #   ansible.playbook = "all.yml"
  #   ansible.inventory_path = "inventories/vagrant"
  #   ansible.limit = "all" # run ansible in parallel for all machines
  #   ansible.verbose = "v"
  #   ansible.extra_vars = {
  #     ansible_ssh_user: 'vagrant',
  #     ansible_ssh_private_key_file: "~/.vagrant.d/insecure_private_key"
  #   }
  # end

end
