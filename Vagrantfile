# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 2,
  :memory => 3000,
}
Vagrant.configure("2") do |config|
    config.vm.box = "micro-qa"
    config.vm.hostname = "micro-qa"
    config.vm.synced_folder ".", "/vagrant", owner: "root", group: "root"
    config.vm.provider :aws do |aws, override|
        override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
        override.ssh.pty = true
        override.ssh.private_key_path = "~/.ssh/id_rsa"
        aws.access_key_id = "DWDWTCOBHXXXXXXXXXXXXX"
        aws.secret_access_key = "D1eKhnWw2wUfeOvKNMVQYYYYYYYYYYYYYY"
        aws.instance_type = "m1.xlarge"
        aws.ami = "emi-A6EA57D5"
        aws.security_groups = ["default"]
        aws.instance_ready_timeout = 600
        aws.endpoint = "http://my-clc-ip:8773/services/Eucalyptus"
        aws.keypair_name = "my-keypair"
        override.ssh.username ="root"
        aws.block_device_mapping = [
        {
            :DeviceName => "/dev/sda", 
            "Ebs.VolumeSize" => 10
        }]
        aws.tags = {
                Name: "Micro QA",
        }
    end
    config.vm.network :forwarded_port, guest: 8080, host: 8080
    config.vm.provider :vmware_fusion do |v, override|
        override.vm.network "public_network"
        if config.vm.box == "centos"
          override.vm.box_url = "https://dl.dropbox.com/u/5721940/vagrant-boxes/vagrant-centos-6.4-x86_64-vmware_fusion.box"
        elsif config.vm.box == "micro-qa"
          override.vm.box_url = "https://vagrantcloud.com/viglesiasce/micro-qa/version/1/provider/vmware.box"
        else
          override.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04.2-server-amd64-vmware-fusion.box"
        end
        v.vmx["memsize"] = options[:memory].to_i
        v.vmx["numvcpus"] = options[:cores].to_i
        v.vmx["vhv.enable"] = "true"
    end
    config.vm.provider :virtualbox do |v, override|
        override.vm.network "public_network"
        if config.vm.box == "centos"
          override.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
        elsif config.vm.box == "micro-qa"
          override.vm.box_url = "https://vagrantcloud.com/viglesiasce/micro-qa/version/1/provider/virtualbox.box"
        else
          override.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"
        end
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end
    config.omnibus.chef_version = :latest
    config.berkshelf.enabled = true
    config.vm.provision :chef_solo do |chef|
      chef.add_recipe "chef-server::default"
      chef.add_recipe "micro-qa::deploy"
      chef.add_recipe "micro-qa::jenkins"
      chef.add_recipe "micro-qa::eutester"
      chef.add_recipe "micro-qa::console-tests"
      chef.json = {}
    end
end
