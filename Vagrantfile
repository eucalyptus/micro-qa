# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 2,
  :memory => 1536,
}
CENTOS = {
  box: "centos",
  url: "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
}
OS = CENTOS
Vagrant.configure("2") do |config|
    config.vm.box = OS[:box]
    config.vm.box_url = OS[:url]
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.provider :virtualbox do |v| 
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end 
    config.vm.hostname = "micro-qa"
    config.vm.provision :shell, :path => "deploy.sh"
end
