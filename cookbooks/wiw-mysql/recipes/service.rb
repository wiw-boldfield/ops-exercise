#
# Cookbook Name:: wiw-mysql
# Recipe:: service
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-vault'
require 'chef-vault'
rt_passwd = unless node.wiw_mysql.password_vault.nil?
              passwds = chef_vault_item(node.wiw_mysql.password_vault,
                                        node.wiw_mysql.service_name)
              passwds['root']
            end

data_dir = "#{node.wiw_mysql.data_dir_base}-#{node.wiw_mysql.version}"

mysql_service node.wiw_mysql.service_name do
  version node.wiw_mysql.version
  socket "#{node.wiw_mysql.sock_path}-#{node.wiw_mysql.service_name}/mysqld.sock"
  port node.wiw_mysql.port
  bind_address node.wiw_mysql.bind_address
  error_log node.wiw_mysql.error_log
  initial_root_password rt_passwd
  data_dir data_dir
  action [:create, :start]
end
