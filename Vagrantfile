# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
    libvirt.random :model => 'random' # Passthrough /dev/random
    # Set up for nested kvm:
    libvirt.machine_virtual_size = 15
    libvirt.nested = true # there's no danger in enabling nested libvirt already
    libvirt.cpu_mode = "host-passthrough" # recommended for nested kvm
    if ENV['VAGRANTNESTED']
      # setup for nested vagrant:
      libvirt.management_network_name = 'vagrant-libvirt-nesting' # use different network interface
      libvirt.management_network_address = '192.168.124.0/24'
    end
  end

  config.vm.box = "debian/stretch64"
  config.vm.box_download_checksum = "3625435cbc6ace0a033f64e9495de65286d92d6560dfefe9239a3f9ab02f98a0"
  config.vm.box_download_checksum_type = "sha256"
  config.vm.synced_folder ".", "/vagrant", type: "sshfs"
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  hostnames = ['router','dotfiles','offlinepc','desktop','laptop','nas','htpc']
  hostnames.each do |name|
  config.vm.define "#{name}" do |system|
    system.vm.host_name = "#{name}"
    system.vm.provision "ansible" do |ansible|
        ansible.playbook = "all.yml"
        ansible.inventory_path = "inventories/vagrant/hosts"
        ansible.limit = "#{name}"
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
    router.vm.network :private_network,
                      :auto_config => false,
                      :libvirt__forward_mode => 'veryisolated',
                      :libvirt__dhcp_enabled => false,
                      :libvirt__network_name => 'switch_wifi'
    router.vm.provider :libvirt do |domain|
      domain.memory = 2048
      domain.cpus = 1
    end
  end

  config.vm.define :dotfiles do |dotfiles|
    dotfiles.vm.network :private_network,
                       :libvirt__network_name => 'ansible_mgmt',
                       :libvirt__dhcp_enabled => false,
                       :ip => "192.168.111.2"
    dotfiles.vm.provider :libvirt do |domain|
      domain.memory = 6144
      domain.cpus = 2
      domain.machine_virtual_size = 20
    end
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
      domain.machine_virtual_size = 30
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
      domain.machine_virtual_size = 30
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
    nas.vm.provider :libvirt do |domain|
      domain.memory = 512
      # 4 disks for raid 10 setup:
      domain.storage :file, :device => 'sdb', :size => '1G', :type => 'raw', :bus => 'sata'
      domain.storage :file, :device => 'sdc', :size => '1G', :type => 'raw', :bus => 'sata'
      domain.storage :file, :device => 'sdd', :size => '1G', :type => 'raw', :bus => 'sata'
      domain.storage :file, :device => 'sde', :size => '1G', :type => 'raw', :bus => 'sata'
    end
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

  config.vm.define :offlinepc do |offlinepc|
    offlinepc.vm.network :private_network,
                    :libvirt__network_name => 'ansible_mgmt',
                    :libvirt__dhcp_enabled => false,
                    :ip => "192.168.111.7"
  end
end
