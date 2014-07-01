#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: deploy
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe "micro-qa"

directory "/root/.chef"

template "/root/.chef/knife.rb" do
  source "knife.erb"
end

package "git"

execute "Upload cookbooks to chef server" do
  command <<-EOH
      mkdir -p /root/cookbooks
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
  not_if "ls /root/cookbooks/eucalyptus"
end

execute "Reupload eucalyptus cookbook" do
  command <<-EOH
    chef-server-ctl reconfigure
    git pull
    knife cookbook upload eucalyptus
  EOH
  cwd '/root/cookbooks/eucalyptus'
  only_if "ls /root/cookbooks/eucalyptus"
  retries 5
end

if platform?("redhat", "centos", "fedora")
    package "libxml2-devel"
    package "libxslt-devel"
  elsif platform?("ubuntu", "debian")
    package "libxml2-dev"
    package "libxslt1-dev"
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

mb_ruby_version = "2.0.0-p481"

rbenv_ruby mb_ruby_version do
  global true
end

rbenv_execute "gem update --system" do
  ruby_version mb_ruby_version
end

rbenv_execute "gem install motherbrain" do
  ruby_version mb_ruby_version
  not_if "ls /opt/rbenv/versions/#{mb_ruby_version}/bin/mb"
end

directory "/root/.mb"

template "/root/.mb/config.json" do
  source "motherbrain.erb"
end
