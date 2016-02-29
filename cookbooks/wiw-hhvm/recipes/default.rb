#
# Cookbook Name:: wiw-hhvm
# Recipe:: default
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'hhvm::default'
include_recipe 'wiw-hhvm::logrotate'

unless node.etc.passwd.include?(node.wiw_hhvm.user)
  group node.wiw_hhvm.group do
    system true
  end

  user node.wiw_hhvm.user do
    gid node.wiw_hhvm.group
    comment 'HHVM user'
    system true
  end
end

# Fix file perms
bash 'fix hhvm file perms' do
  code <<-EOF
    chown -R #{node.wiw_hhvm.user}:#{node.wiw_hhvm.group} #{node.wiw_hhvm.conf_dir}
  EOF
end

# Configure socket if required
include_recipe 'wiw-hhvm::socket' if node.wiw_hhvm.listen_socket

# Install fastcgi if required
include_recipe 'wiw-hhvm::fastcgi' if node.wiw_hhvm.install_fastcgi

include_recipe 'wiw-hhvm::service'
