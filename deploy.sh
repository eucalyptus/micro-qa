#!/bin/bash -xe

### If installing on baremetal, grab jenkins source
if [ ! -d /vagrant ];then 
  yum install -y git
  git clone https://github.com/eucalyptus/micro-qa /vagrant
fi

### Add EPEL repo
if [ ! -e /etc/yum.repos.d/epel.repo ];then 
  yum install -y http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
fi


### Install deps
yum install -y python-devel python-setuptools gcc make python-virtualenv java-1.7.0-openjdk-devel git ntp wget unzip ant

### Install jenkins
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
chkconfig jenkins on

### Configure NTP
chkconfig ntpd on
service ntpd start
ntpdate -u pool.ntp.org

### Setup IPtables
iptables -F
iptables -F -t nat
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables-save > /etc/sysconfig/iptables

### Initialize Jenkins Home
sed -i s#JENKINS_HOME=.*#JENKINS_HOME=\"/vagrant/jenkins\"# /etc/sysconfig/jenkins
sed -i s#JENKINS_USER=.*#JENKINS_USER=\"root\"# /etc/sysconfig/jenkins

### Get IP address
if curl http://169.254.169.254/latest/meta-data;then 
  ### This is an instance
  ipaddress=`curl http://169.254.169.254/latest/meta-data/public-ipv4/`
  hostname=`curl http://169.254.169.254/latest/meta-data/public-hostname/`
else
  ### This is a virtualbox vm
  ipaddress=`ifconfig eth1 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
  hostname=`hostname`
fi
sed -i s/localhost/$ipaddress/g /vagrant/jenkins/jenkins.model.JenkinsLocationConfiguration.xml /vagrant/jenkins/org.codefirst.SimpleThemeDecorator.xml
echo "$ipaddress $hostname" >> /etc/hosts
### Start jenkins
service jenkins start

### Setup eutester-base virtualenv
pushd /vagrant/jenkins/
mkdir -p share
pushd share
virtualenv eutester-base
source eutester-base/bin/activate
./eutester-base/bin/easy_install 'paramiko>=1.7' 'boto==2.5.2' 'jinja2>=2.7' argparse futures python-dateutil mock
chown -R root:root eutester-base
popd
popd

### Install Selenium Dependencies
easy_install selenium
yum -y install make rubygems ruby-devel xorg-x11-font* wget xorg-x11-server-Xvfb firefox
cd /
wget -q https://selenium.googlecode.com/files/selenium-server-2.39.0.zip
unzip selenium-server-2.39.0.zip
#dbus-uuidgen > /var/lib/dbus/machine-id
Xvfb :0 -ac 2> /dev/null &

### Install chef dependencies
curl -L https://www.opscode.com/chef/install.sh | bash
yum -y install https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.0.10-1.el6.x86_64.rpm
chef-server-ctl reconfigure
mkdir ~/.chef
cp /etc/chef-server/admin.pem ~/.chef
cp /etc/chef-server/chef-validator.pem ~/.chef
cat > ~/.chef/knife.rb <<EOF
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/vagrant/jenkins/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/vagrant/jenkins/.chef/chef-validator.pem'
chef_server_url          'https://localhost:443'
syntax_check_cache_path  '/vagrant/jenkins/.chef/syntax_check_cache'
cookbook_path [
  "/root/cookbooks",
]
EOF

echo 'erchef['s3_url_ttl'] = 3600' >> /etc/chef-server/chef-server.rb
echo "bookshelf['vip'] = '$ipaddress'"  >> /etc/chef-server/chef-server.rb
echo "bookshelf['url'] = 'https://$ipaddress'"  >> /etc/chef-server/chef-server.rb
chef-server-ctl reconfigure

sed -i s/localhost/$ipaddress/g ~/.chef/knife.rb

cp -a /root/.chef/ /vagrant/jenkins/
chown -R jenkins:jenkins /vagrant/jenkins/.chef/

## Download cookbooks
mkdir /root/cookbooks
pushd /root/cookbooks
git init
echo "Chef Repo" >> README
git add .
git commit -a -m "Initial commit"
knife cookbook site install ntp
knife cookbook upload ntp
knife cookbook site install partial_search
knife cookbook upload partial_search
knife cookbook site install ssh_known_hosts
knife cookbook upload ssh_known_hosts
knife cookbook site install selinux
knife cookbook upload selinux
knife cookbook site install yum
knife cookbook upload yum
knife cookbook site install iptables
knife cookbook upload iptables

git clone https://github.com/eucalyptus/eucalyptus-cookbook eucalyptus
knife cookbook upload eucalyptus

## Upload roles
knife role from file eucalyptus/roles/*
popd

### Create rc.local
cat > /etc/rc.local <<EOF
#!/bin/bash
Xvfb :0 -ac &
export DISPLAY=":0" && nohup java -jar /selenium-2.35.0/selenium-server-standalone-2.35.0.jar -trustAllSSLCertificates &
exit 0
EOF
chmod +x /etc/rc.local

### Show the user the ip address that their MicroQA received
ifconfig eth1
