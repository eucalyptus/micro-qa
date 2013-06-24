micro-qa
========

Self Contained Automated Test Environment

## Installation

Run a CentOS 6 image with the following user data https://gist.github.com/viglesiasce/5847752 or with an existing CentOS 6 installation follow the steps below.

### Install dependencies
```
yum install python-devel python-setuptools gcc make python-virtualenv java-1.6.0-openjdk.x86_64 git ntp
```

### Install Jenkins
```
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins
chkconfig jenkins on
```

### Sync NTP
```
chkconfig ntpd on
service ntpd start
ntpdate -u pool.ntp.org
```

### Set Redirect for port 8080->80
```
iptables -F
iptables -F -t nat
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables-save > /etc/sysconfig/iptables
```

### Unbundle /var/lib/jenkins tarball
```
pushd /var/lib
wget https://github.com/eucalyptus/micro-qa/archive/master.zip
unzip master.zip
mv micro-qa jenkins
popd
service jenkins start
```
