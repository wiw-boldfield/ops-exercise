#
# Cookbook Name:: wiw-blog
# Recipe:: default
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wiw-nginx::default'
include_recipe 'wiw-mysql::default'
include_recipe 'wiw-blog::install_wordpress'
include_recipe 'wiw-blog::setup_nginx'
