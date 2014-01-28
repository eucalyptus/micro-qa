# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 2,
  :memory => 3000,
}
CENTOS = {
  box: "centos",
  url: "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
}
OS = CENTOS
Vagrant.configure("2") do |config|
    config.vm.network "public_network"
    config.vm.box = OS[:box]
    config.vm.box_url = OS[:url]
    config.vm.hostname = "micro-qa"
    config.vm.provider :aws do |aws,override|
	aws.access_key_id = "YOURACCESSKEY"
        aws.secret_access_key = "YOURSECRETKEY"
        aws.instance_type = "m1.xlarge"
        aws.ami = "emi-IMAGEID"
        aws.security_groups = ["micro-qa"]
        aws.region = "eucalyptus"
        aws.instance_ready_timeout = 600
        aws.endpoint = "http://my-clc-ip:8773/services/Eucalyptus"
        aws.keypair_name = "my-keypair"
        override.ssh.username ="root"
        override.ssh.private_key_path ="/path/to/my/ssh/private/key"
        aws.tags = {
                Name: "Micro QA",
        }
    end
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.provider :virtualbox do |v| 
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end 
    config.vm.provision :shell, :path => "deploy.sh"
end
