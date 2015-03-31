#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: eutester
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe "micro-qa"

pip_options = ""
if platform?("redhat", "centos", "fedora")
  # code for only redhat family systems.
  %w{python-devel python-setuptools gcc git unzip wget}.each do |package_name|
    package package_name
  end
  pip_options = "--pre"
  chef_dk_url = 'https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.4.0-1.x86_64.rpm'
  chef_dk_rpm = '/root/chef-dk.rpm'
  remote_file chef_dk_rpm do
    source chef_dk_url
  end
  yum_package "chef-dk" do
    action :install
    source chef_dk_rpm
  end
elsif platform?("ubuntu", "debian")
  # code for debian
  %w{python-setuptools gcc python-dev git git wget}.each do |package_name|
    package package_name
  end
  chef_dk_url = 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb'
  chef_dk_deb = '/root/chef-dk.deb'
  remote_file chef_dk_deb do
    source chef_dk_url
  end
  dpkg_package "chef-dk" do
    action :install
    source chef_dk_deb
  end
end

python_pip "fabric"
python_pip "PyYAML"
