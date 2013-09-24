#!/bin/bash -x

### Add EPEL repo
yum install -y http://mirror.ancl.hawaii.edu/linux/epel/6/i386/epel-release-6-8.noarch.rpm

### Install deps
yum install -y python-devel python-setuptools gcc make python-virtualenv java-1.7.0-openjdk-devel git ntp wget unzip ant

### Install jenkins
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
chkconfig jenkins on

### Install ansible deps
yum install -y PyYAML python-jinja2 python-paramiko
git clone https://github.com/ansible/ansible.git /opt/ansible

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
wget -q https://selenium.googlecode.com/files/selenium-server-2.35.0.zip
unzip selenium-server-2.35.0.zip
dbus-uuidgen > /var/lib/dbus/machine-id
Xvfb :0 -ac 2> /dev/null &
export DISPLAY=":0" && nohup java -jar selenium-2.35.0/selenium-server-standalone-2.35.0.jar -trustAllSSLCertificates &

### Create rc.local
cat > /etc/rc.local <<EOF
#!/bin/bash
Xvfb :0 -ac &
export DISPLAY=":0" && nohup java -jar /selenium-2.35.0/selenium-server-standalone-2.35.0.jar -trustAllSSLCertificates &
exit 0
EOF
chmod +x /etc/rc.local
