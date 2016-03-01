#
# Cookbook Name:: wiw-nginx
# Recipe:: default
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx::default'
include_recipe 'wiw-nginx::logrotate'
