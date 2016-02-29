#
# Cookbook Name:: wiw-hhvm
# Recipe:: fastcgi
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

# Pattern stolen from hhvm3 cookbook
hhvm_fastcgi_installed = "#{Chef::Config[:file_cache_path]}/hhvm_fastcgi_installed"

execute 'install fastcgi' do
  command '/usr/share/hhvm/install_fastcgi.sh'
  not_if do
    ::File.exist?(hhvm_fastcgi_installed)
  end
end

file hhvm_fastcgi_installed do
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

template '/etc/nginx/hhvm.conf' do
  source 'nginx-hhvm.conf.erb'
  user node.wiw_hhvm.user
  group node.wiw_hhvm.group
end

template '/etc/apache2/mods-available/hhvm_proxy_fcgi.conf' do
  source 'apache-hhvm_proxy_fcgi.conf.erb'
  user node.wiw_hhvm.user
  group node.wiw_hhvm.group
end
