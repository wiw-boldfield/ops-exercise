#
# Cookbook Name:: wiw-hhvm
# Recipe:: logrotate
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'logrotate::default'

logrotate_app 'hhvm' do
  cookbook 'logrotate'
  path '/var/log/hhvm/*.log'
  create "0644 #{node.wiw_hhvm.user} adm"
  frequency 'daily'
  rotate 7 # Assume we are shipping logs somewhere and we don't need to keep much locally
  copytruncate true
end
