# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 2,
  :memory => 3000,
}
Vagrant.configure("2") do |config|
    config.vm.box = "chef/centos-6.6"
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
        aws.user_data = File.read("user_data.txt")
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
        else
          override.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04.2-server-amd64-vmware-fusion.box"
        end
        v.vmx["memsize"] = options[:memory].to_i
        v.vmx["numvcpus"] = options[:cores].to_i
        v.vmx["vhv.enable"] = "true"
    end
    config.vm.provider :virtualbox do |v, override|
        override.vm.network "public_network"
        if config.vm.box == "chef/centos-6.6"
          override.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/centos-6.6"
        end
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end
    config.omnibus.chef_version = :latest
    config.berkshelf.enabled = true
    config.vm.provision :chef_solo do |chef|
      chef.add_recipe "micro-qa::jenkins"
      chef.add_recipe "micro-qa::eutester"
      chef.add_recipe "micro-qa::console-tests"
      chef.add_recipe "micro-qa::deploy"
      chef.json = {}
    end
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
    end
end
