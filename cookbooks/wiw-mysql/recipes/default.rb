#
# Cookbook Name:: wiw-mysql
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
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

logrotate_app 'mysql' do
  cookbook 'logrotate'
  path ::File.join(node.nginx.log_dir, '*.log')
  create "0750 mysql adm"
  frequency 'daily'
  rotate 7 # Assume we are shipping logs somewhere and we don't need to keep much locally
  prerotate <<-EOL
    if [ -d /etc/logrotate.d/httpd-prerotate ]; then
            run-parts /etc/logrotate.d/httpd-prerotate;
    fi
  EOL
  postrotate '[ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`'
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  password: rt_passwd
}

unless node.wiw_mysql.username.nil?
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
end
