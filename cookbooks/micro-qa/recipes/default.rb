#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: default
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

package 'git'
git "/vagrant" do
  repository "https://github.com/eucalyptus/micro-qa.git"
  not_if "ls /vagrant"
end

if platform?("redhat", "centos", "fedora")
  remote_file "/tmp/epel-release.rpm" do
    source "http://downloads.eucalyptus.com/software/eucalyptus/3.4/centos/6/x86_64/epel-release-6.noarch.rpm"
    not_if "rpm -qa | grep 'epel-release'"
  end
  execute 'yum install -y *epel*.rpm' do
    cwd '/tmp'
    not_if "ls /etc/yum.repos.d/epel*"
  end
  execute "generate ssh keys" do
    command "ssh-keygen -t rsa -q -f /root/.ssh/id_rsa -P \"\""
    creates "/root/.ssh/id_rsa.pub"
  end
elsif platform?("ubuntu", "debian")
  # code for debian
end
