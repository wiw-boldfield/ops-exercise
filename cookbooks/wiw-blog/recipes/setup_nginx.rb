#
# Cookbook Name:: wiw-blog
# Recipe:: setup_nginx
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

return if node.wiw_blog.domain.nil? # Perhaps this should complain loudly
ssl_key_file = nil
ssl_cert_file = nil
unless node.wiw_blog.ssl_vault.nil?
  directory '/etc/nginx/ssl' do
    owner node.nginx.user
    group node.nginx.user
  end

  # a vault probably isn't the best place for a pub key, but, expedience
  cert = chef_vault_item(node.wiw_blog.ssl_vault, 'cert')

  ssl_key = cert['privkey']
  ssl_key_file = "/etc/nginx/ssl/#{node.wiw_blog.domain}.key"
  file ssl_key_file do
    owner node.nginx.user
    group node.nginx.user
    mode 0400
    content ssl_key
    sensitive true
  end

  ssl_cert = cert['cert']
  ssl_cert_file = "/etc/nginx/ssl/#{node.wiw_blog.domain}.crt"
  file ssl_cert_file do
    owner node.nginx.user
    group node.nginx.user
    content ssl_cert
  end
end

vars = {
  domain: node.wiw_blog.domain,
  ssl_key: ssl_key_file,
  ssl_cert: ssl_cert_file,
  ip: node.wiw_blog.ip
}

nginx_site 'wiw-blog' do
  template 'wiw-blog.conf.erb'
  enable true
  variables vars
  notifies :reload, 'service[nginx]', :delayed
end
