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
  # code for only redhat family systems.
elsif platform?("ubuntu", "debian") 
  # code for debian
end
