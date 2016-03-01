#
# Cookbook Name:: wiw-nginx
# Recipe:: logrotate
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'logrotate::default'

# Doing blanket log-rotate here isn't necessarily the best way to go, each
# application that is flexing nginx probably should take care of it's
# own rotation when a site is defined.  For the purposes of this exercise
# I'm just going to # do blanket rotation tho.
logrotate_app 'nginx' do
  cookbook 'logrotate'
  path ::File.join(node.nginx.log_dir, '*.log')
  create "#{node.nginx.log_dir_perm} #{node.nginx.user} adm"
  frequency 'daily'
  rotate 7 # Assume we are shipping logs somewhere and we don't need to keep much locally
  prerotate <<-EOL
    if [ -d /etc/logrotate.d/httpd-prerotate ]; then
            run-parts /etc/logrotate.d/httpd-prerotate;
    fi
  EOL
  postrotate '[ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`'
end
