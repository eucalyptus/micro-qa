# -*- mode: ruby -*-
# vi: set ft=ruby :
options = {
  :cores => 1,
  :memory => 1536,
}
CENTOS = {
  box: "centos",
  url: "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"
}
OS = CENTOS
$deploy = <<DEPLOY
#!/bin/bash

yum install -y python-devel python-setuptools gcc make python-virtualenv java-1.6.0-openjdk.x86_64 git ntp wget unzip

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
chkconfig jenkins on

chkconfig ntpd on
service ntpd start
ntpdate -u pool.ntp.org

iptables -F
iptables -F -t nat
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables-save > /etc/sysconfig/iptables
rsync -va /vagrant/jenkins/ /var/lib/jenkins/
chown -R jenkins:jenkins /var/lib/jenkins
service jenkins start
SYNC_COMMAND=/usr/bin/jenkins-sync
cat > $SYNC_COMMAND <<EOF
#!/bin/bash
rsync -va /var/lib/jenkins/ /vagrant/jenkins/ --exclude workspace --exclude builds --exclude nextBuildNumber --exclude lastStable --exclude lastSuccessful --exclude .git
EOF
chmod +x $SYNC_COMMAND
DEPLOY

Vagrant.configure("2") do |config|
    config.vm.box = OS[:box]
    config.vm.box_url = OS[:url]
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.provider :virtualbox do |v| 
        v.customize [ "modifyvm", :id, "--memory", options[:memory].to_i, "--cpus", options[:cores].to_i]
    end 
    config.vm.hostname = "micro-qa"
    config.vm.provision :shell, :inline => $deploy
end
