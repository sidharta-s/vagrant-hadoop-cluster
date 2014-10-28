# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.6.2"

# The number of slaves to provision
# NUM_SLAVES=0 provisions creates a single node setup 
$num_slave = (ENV['NUM_SLAVES'] || 2).to_i

# ip configuration
$master_ip = "10.245.100.2"
$slave_ip_base = "10.245.100."
$slave_ips = $num_slave.times.collect { |n| $slave_ip_base + "#{n+3}" }
$slave_ips_str = $slave_ips.join(",")

$box_url = "chef/centos-6.5"
$box_name = "chef/centos-6.5"

host = RbConfig::CONFIG['host_os']
if host =~ /darwin/
  $vm_cpus = `sysctl -n hw.ncpu`.to_i
elsif host =~ /linux/
  $vm_cpus = `nproc`.to_i
else 
  $vm_cpus = 2
end

# Give VM 512MB of RAM
$vm_mem = 1024 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  def customize_vm(config)
    config.vm.box = $box_name 
    config.vm.box_url = $box_url

    config.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", $vm_mem]
      v.customize ["modifyvm", :id, "--cpus", $vm_cpus]

      v.customize ["modifyvm", :id, "--nictype1", "virtio"]
      v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end
  end

  config.vm.define "master" do |config|
    customize_vm config

    config.vm.provision "shell", inline: "/vagrant/provision/provision-master.sh #{$master_ip} #{$num_slave} #{$slave_ips_str}"
    config.vm.network "private_network", ip: "#{$master_ip}"
    config.vm.hostname = "hadoop-master"
  end

  $num_slave.times do |n|
    config.vm.define "slave-#{n+1}" do |slave|
      customize_vm slave

      slave_index = n+1
      slave_ip = $slave_ips[n]
      slave.vm.provision "shell", inline: "/vagrant/provision/provision-slave.sh #{$master_ip} #{$num_slave} #{$slave_ips_str} #{slave_ip} #{slave_index}"
      slave.vm.network "private_network", ip: "#{slave_ip}"
      slave.vm.hostname = "hadoop-slave-#{slave_index}"
    end
  end

end
