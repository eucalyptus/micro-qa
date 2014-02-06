dd EPEL repo
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
rsync -va /vagrant/jenkins/ /var/lib/jenkins/
chown -R jenkins:jenkins /var/lib/jenkins

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
sed -i s/localhost/$ipaddress/g /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml /var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml
echo "$ipaddress $hostname" >> /etc/hosts
### Start jenkins
service jenkins start

### Setup Jenkins sync script
SYNC_COMMAND=/usr/bin/jenkins-sync
cat > $SYNC_COMMAND <<EOF
#!/bin/bash
rsync -va /var/lib/jenkins/ /vagrant/jenkins/ --exclude workspace --exclude builds --exclude nextBuildNumber --exclude lastStable --exclude lastSuccessful --exclude .git --exclude share
EOF
chmod +x $SYNC_COMMAND

### Setup eutester-base virtualenv
pushd /var/lib/jenkins/
mkdir share
pushd share
virtualenv eutester-base
source eutester-base/bin/activate
./eutester-base/bin/easy_install 'paramiko>=1.7' 'boto==2.5.2' 'jinja2>=2.7' argparse futures python-dateutil mock
chown -R jenkins:jenkins eutester-base
popd
popd

### Install Selenium Dependencies
easy_install selenium
yum -y install make rubygems ruby-devel xorg-x11-font* wget xorg-x11-server-Xvfb firefox
cd /
wget -q https://selenium.googlecode.com/files/selenium-server-2.39.0.zip
unzip selenium-server-2.39.0.zip
dbus-uuidgen > /var/lib/dbus/machine-id
Xvfb :0 -ac 2> /dev/null &
export DISPLAY=":0" 


### Create rc.local
cat > /etc/rc.local <<EOF
#!/bin/bash
Xvfb :0 -ac &
export DISPLAY=":0" 
EOF
chmod +x /etc/rc.local

### Show the user the ip address that their MicroQA received
ifconfig eth1
