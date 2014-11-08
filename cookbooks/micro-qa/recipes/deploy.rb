#
# Cookbook Name:: cookbooks/micro-qa
# Recipe:: deploy
#
# Copyright 2014, Eucalyptus Systems
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'micro-qa'
include_recipe 'python'
python_pip 'fabric'
package "git"
