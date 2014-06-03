#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: deploy
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

directory "/root/.chef"

template "/root/.chef/knife.rb" do
  source "knife.erb"
end

execute "Upload cookbooks to chef server" do
    command <<-EOH
      mkdir /root/cookbooks
      cd /root/cookbooks
      git init
      echo "Chef Repo" >> README
      git add .
      git commit -a -m "Initial commit"
      knife cookbook site install ntp
      knife cookbook upload ntp
      knife cookbook site install selinux
      knife cookbook upload selinux
      knife cookbook site install yum
      knife cookbook upload yum
      git clone https://github.com/eucalyptus/eucalyptus-cookbook eucalyptus
      knife cookbook upload eucalyptus
    EOH
    not_if "knife cookbook list | grep eucalyptus"
end

execute "Install Ruby 2.0.0" do
  command "curl -sSL https://get.rvm.io | bash -s stable --ruby=2.0.0"
  not_if "rvm current | grep ruby-2.0.0"
end

if platform?("redhat", "centos", "fedora")
    package "libxml-devel"
    package "libxslt-devel"
  elsif platform?("ubuntu", "debian")
    package "libxml2-dev"
    package "libxslt1-dev"
end

bash "Install motherbrain" do
  code <<-EOH
    source /usr/local/rvm/scripts/rvm
    rvm --default use 2.0.0
    gem install motherbrain
  EOH
  user "root"
  not_if "which mb"
end

directory "/root/.mb"

template "/root/.mb/config.json" do
  source "motherbrain.erb"
end
