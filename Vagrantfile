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
    config.vm.provider :aws do |aws,override|
        aws.access_key_id = "XNKO4SHYC0XH1OKWDKEVC"
        aws.secret_access_key = "CwiaSozGTiLELjnm96iTgOMKLuiht4mcPwkGDWV3"
        aws.instance_type = "m1.medium"
        aws.ami = "emi-1873419A"
        aws.security_groups = ["default"]
        aws.region = "eucalyptus"
        aws.endpoint = "http://10.0.1.91:8773/services/Eucalyptus"
        aws.keypair_name = "vic"
        #aws.user_data = $user_data
        override.ssh.username ="root"
        override.ssh.private_key_path ="/Users/viglesias/.ssh/id_rsa"
        # Optional
        #aws.availability_zone = "one"
        aws.tags = {
                Name: "Micro QA",
        }
    end
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.provider :virtualbox do |v| 
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end 
    config.vm.hostname = "micro-qa"
    config.vm.provision :shell, :path => "deploy.sh"
end
