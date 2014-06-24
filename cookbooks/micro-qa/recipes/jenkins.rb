#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: jenkins
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

include_recipe "micro-qa"
include_recipe "apt"

if platform?('redhat', 'centos', 'fedora')
  # code for only redhat family systems.
  yum_repository 'jenkins' do
    description 'Jenkins'
    baseurl 'http://pkg.jenkins-ci.org/redhat'
    gpgkey 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'
    action :create
  end
  package 'java-1.7.0-openjdk-devel'
  jenkins_config = "/etc/sysconfig/jenkins"
elsif platform?('ubuntu', 'debian') 
  # code for debian
  apt_repository 'jenkins' do
    uri 'http://pkg.jenkins-ci.org/debian'
    components ['binary/']
    key 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key'
  end
  package 'openjdk-7-jdk'
  jenkins_config = "/etc/default/jenkins"
end

package 'jenkins'

execute "rm -rf /var/lib/jenkins"
execute "ln -s /vagrant/jenkins /var/lib/jenkins"
execute "sed -i 's/^JENKINS_USER=.*/JENKINS_USER=root/g' #{jenkins_config}"
execute "sed -i 's/^JENKINS_GROUP=.*/JENKINS_GROUP=root/g' #{jenkins_config}"

service 'jenkins' do
  action [:restart, :enable]
end
