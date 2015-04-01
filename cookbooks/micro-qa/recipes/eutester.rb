#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: eutester
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe "micro-qa"
include_recipe "ntp"

pip_options = ""
if platform?("redhat", "centos", "fedora")
  # code for only redhat family systems.
  %w{python-devel python-setuptools gcc openssl openssl-devel make git unzip ant ipython
     python-virtualenv python-pip}.each do |package_name|
    package package_name
  end
  pip_options = "--pre"
elsif platform?("ubuntu", "debian") 
  # code for debian
  %w{python-setuptools gcc python-dev git python-virtualenv ipython
     git unzip ant}.each do |package_name|
    package package_name
  end
end

share_directory = "/vagrant/jenkins/share"
directory share_directory do
  only_if "ls /vagrant"
end

eutester_venv_dir = "#{share_directory}/eutester-base"
# Remove old venv
python_virtualenv eutester_venv_dir do
  action :delete
end
python_virtualenv eutester_venv_dir do
  owner "root"
  group "root"
  action :create
  only_if "ls /vagrant"
end

python_pip "eutester" do
  virtualenv eutester_venv_dir
  only_if "ls /vagrant"
  options pip_options
end

