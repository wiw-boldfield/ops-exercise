#
# Cookbook Name:: wiw-blog
# Recipe:: install_anchorcms
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wiw-hhvm::default'

github_filename = "#{node.wiw_blog.anchorcms_version}.tar.gz"
local_filename = "anchorcms-#{node.wiw_blog.anchorcms_version}.tar.gz"
source_url = "#{node.wiw_blog.anchorcms_source_base}/#{github_filename}"
local_file = "#{Chef::Config['file_cache_path']}/#{local_filename}"

remote_file local_file do
  source source_url
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node.wiw_blog.anchorcms_root do
  user node.wiw_blog.user
  group node.wiw_blog.group
  recursive true
end

# No, this isn't the best way to support upgrading applications,
# but in the interest of time...
# Would need to revisit this
sentinal = "#{node.wiw_blog.anchorcms_root}/anchor-cms-#{node.wiw_blog.anchorcms_version}"
bash 'extract anchorcms' do
  cwd ::File.dirname(local_file)
  code <<-EOF
    mkdir -p #{node.wiw_blog.anchorcms_root}
    tar xzf #{local_filename} -C #{node.wiw_blog.anchorcms_root}
    chown -R #{node.wiw_blog.user}:#{node.wiw_blog.group} #{node.wiw_blog.anchorcms_root}
    ln -f -s #{sentinal} #{node.wiw_blog.anchorcms_root}/current
  EOF
  not_if { ::File.exist?(sentinal) }
  # Generally not preferable to do a restart, but the service as configured doens't
  # support a reload, would need circle back on this.
  notifies :restart, 'service[hhvm]'
end
