# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 2,
  :memory => 3000,
}
Vagrant.configure("2") do |config|
    config.vm.network "public_network"
    config.vm.box = "centos"
    config.vm.hostname = "micro-qa"
    config.vm.provider :aws do |aws, override|
        override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
        override.ssh.pty = true
	aws.access_key_id = "XNKO4SHYC0XH1OKWDKEVC"
        aws.secret_access_key = "CwiaSozGTiLELjnm96iTgOMKLuiht4mcPwkGDWV3"
        aws.instance_type = "m1.xlarge"
        aws.ami = "emi-A6EA57D5"
        aws.security_groups = ["default"]
        aws.region = "eucalyptus"
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
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.provider :vmware_fusion do |v, override|
        override.vm.box_url = "https://dl.dropbox.com/u/5721940/vagrant-boxes/vagrant-centos-6.4-x86_64-vmware_fusion.box"
        v.vmx["memsize"] = options[:memory].to_i
        v.vmx["numvcpus"] = options[:cores].to_i
        v.vmx["vhv.enable"] = "true"
    end
    config.vm.provider :virtualbox do |v, override| 
        override.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end
    config.vm.provision :shell, :path => "deploy.sh"
end
