#
# Cookbook Name:: wiw-mysql
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wiw-mysql::service'
include_recipe 'wiw-mysql::logrotate'
include_recipe 'wiw-mysql::bootstrap' unless node.wiw_mysql.username.nil?
