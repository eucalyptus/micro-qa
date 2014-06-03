#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: default
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#

if platform?("redhat", "centos", "fedora")
  # code for only redhat family systems.
elsif platform?("ubuntu", "debian") 
  # code for debian
end
