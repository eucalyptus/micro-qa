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
  %w{python-devel python-setuptools gcc make git unzip ant}.each do |package_name|
    package package_name
  end
  pip_options = "--pre"
elsif platform?("ubuntu", "debian") 
  # code for debian
  %w{python-setuptools gcc python-dev git python-virtualenv
     git unzip ant}.each do |package_name|
    package package_name
  end
end

directory "/vagrant/jenkins/share" do
  only_if "ls /vagrant"
end

execute "easy_install pip"
python_pip "virtualenv"

python_virtualenv "/vagrant/jenkins/share/eutester-base" do
  owner "root"
  group "root"
  action :create
  only_if "ls /vagrant"
end

python_pip "eutester" do
  virtualenv "/vagrant/jenkins/share/eutester-base"
  only_if "ls /vagrant"
  options pip_options
end

python_pip "ipython"
