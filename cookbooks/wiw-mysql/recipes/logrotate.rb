#
# Cookbook Name:: wiw-mysql
# Recipe:: logrotate
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'logrotate::default'

logrotate_app 'mysql' do
  cookbook 'logrotate'
  path "#{node.wiw_mysql.error_log}/*.log"
  create '0750 mysql adm'
  frequency 'daily'
  rotate 7 # Assume we are shipping logs somewhere and we don't need to keep much locally
  prerotate <<-EOL
    if [ -d /etc/logrotate.d/httpd-prerotate ]; then
            run-parts /etc/logrotate.d/httpd-prerotate;
    fi
  EOL
  postrotate '[ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`'
end
