#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: console-tests
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

include_recipe "micro-qa"

easy_install_package "selenium"

if platform?("redhat", "centos", "fedora")
  # code for only redhat family systems.
  %w{make rubygems ruby-devel xorg-x11-font* wget xorg-x11-server-Xvfb firefox}.each do |package_name|
    package package_name
  end
elsif platform?("ubuntu", "debian") 
  # code for debian
  %w{xvfb firefox}.each do |package_name|
    package package_name
  end
end

remote_file "/selenium-server.zip" do
  source "https://selenium.googlecode.com/files/selenium-server-2.39.0.zip"
end

execute "unzip -o selenium-server.zip" do
  cwd "/"
  not_if "ls /selenium-server-2.39.0"
end

execute "Xvfb :0 -ac &"
