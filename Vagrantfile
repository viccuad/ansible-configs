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

  config.vm.box = "debian/stretch64"

  config.vm.synced_folder ".", "/vagrant", type: "sshfs"

  hostnames = ['router','dotfiles','server','offlinepc','desktop','laptop','nas','htpc']
  hostnames.each do |name|
  config.vm.define "#{name}" do |system|
    system.vm.host_name = "#{name}"
    system.vm.provision "ansible" do |ansible|
        ansible.playbook = "#{name}.yml"
        ansible.inventory_path = "inventories/vagrant"
        ansible.limit = "all" # run ansible in parallel for all machines
        ansible.verbose = "vv"
      end
    end
  end

  config.vm.define :router do |router|
    router.vm.network :private_network,
                      :libvirt__network_name => 'ansible_mgmt',
                      :libvirt__dhcp_enabled => false,
                      :ip => "192.168.111.10"
    router.vm.network :private_network,
                    :auto_config => false,
                    :libvirt__forward_mode => 'veryisolated',
                    :libvirt__dhcp_enabled => false,
                    :libvirt__network_name => 'switch_lan'
    end
  end

  config.vm.define :dotfiles do |dotfiles|
    dotfiles.vm.network :private_network,
                       :libvirt__network_name => 'ansible_mgmt',
                       :libvirt__dhcp_enabled => false,
                       :ip => "192.168.111.2"
  end

  config.vm.define :desktop do |desktop|
    desktop.vm.network :private_network,
                       :libvirt__network_name => 'ansible_mgmt',
                       :libvirt__dhcp_enabled => false,
                       :ip => "192.168.111.3"
    desktop.vm.network :private_network,
                       :auto_config => false,
                       :libvirt__forward_mode => 'veryisolated',
                       :libvirt__dhcp_enabled => false,
                       :libvirt__network_name => 'switch_lan'
    desktop.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
    end
  end

  config.vm.define :laptop do |laptop|
    laptop.vm.network :private_network,
                      :libvirt__network_name => 'ansible_mgmt',
                      :libvirt__dhcp_enabled => false,
                      :ip => "192.168.111.4"
    laptop.vm.network :private_network,
                      :auto_config => false,
                      :libvirt__forward_mode => 'veryisolated',
                      :libvirt__dhcp_enabled => false,
                      :libvirt__network_name => 'switch_wifi'
    laptop.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
    end
  end

  config.vm.define :nas do |nas|
    nas.vm.network :private_network,
                   :libvirt__network_name => 'ansible_mgmt',
                   :libvirt__dhcp_enabled => false,
                   :ip => "192.168.111.5"
    nas.vm.network :private_network,
                      :auto_config => false,
                      :libvirt__forward_mode => 'veryisolated',
                      :libvirt__dhcp_enabled => false,
                      :libvirt__network_name => 'switch_lan'
  end

  config.vm.define :htpc do |htpc|
    htpc.vm.network :private_network,
                    :libvirt__network_name => 'ansible_mgmt',
                    :libvirt__dhcp_enabled => false,
                    :ip => "192.168.111.6"
    htpc.vm.network :private_network,
                   :auto_config => false,
                   :libvirt__forward_mode => 'veryisolated',
                   :libvirt__dhcp_enabled => false,
                   :libvirt__network_name => 'switch_lan'
  end
end
