#
# Cookbook Name:: wiw-hhvm
# Recipe:: socket
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

template ::File.join(node.wiw_hhvm.conf_dir, node.wiw_hhvm.server_conf) do
  user node.wiw_hhvm.user
  group node.wiw_hhvm.group
end
