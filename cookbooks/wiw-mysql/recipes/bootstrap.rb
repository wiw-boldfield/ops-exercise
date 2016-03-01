#
# Cookbook Name:: wiw-mysql
# Recipe:: bootstrap
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

mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  password: rt_passwd
}

mysql2_chef_gem 'default' do
  action :install
end

# Only create the table if a user to own it was specified.
unless node.wiw_mysql.tablename.nil?
  mysql_database node.wiw_mysql.tablename do
    connection mysql_connection_info
    action :create
  end
end

# Let this fail. If you specified a user, but didn't supply a password you should
# feel pain. Also, this should be handled a little more gracefully... time...
user_passwd = passwds[node.wiw_mysql.username]

mysql_database_user node.wiw_mysql.username do
  connection mysql_connection_info
  password user_passwd
  action :create
end

mysql_database_user node.wiw_mysql.username do
  connection mysql_connection_info
  database_name node.wiw_mysql.username
  privileges [:all]
  action :grant
end
