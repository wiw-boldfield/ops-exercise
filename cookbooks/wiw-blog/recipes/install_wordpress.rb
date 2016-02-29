#
# Cookbook Name:: wiw-blog
# Recipe:: install_anchorcms
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'wiw-hhvm::default'

filename = "wordpress-#{node.wiw_blog.wordpress_version}.tar.gz"
source_url = "#{node.wiw_blog.wordpress_source_base}/#{filename}"
local_file = "#{Chef::Config['file_cache_path']}/#{filename}"

remote_file local_file do
  source source_url
  owner 'root'
  group 'root'
  mode '0755'
  checksum node.wiw_blog.wordpress_version_sha256
  action :create
end

directory node.wiw_blog.wordpress_root do
  user node.wiw_blog.user
  group node.wiw_blog.group
  recursive true
end

package 'php5-gd'
package 'libssh2-php'

# No, this isn't the best way to support upgrading applications,
# but in the interest of time...
# Would need to revisit this
sentinal = "#{node.wiw_blog.wordpress_root}/wordpress-#{node.wiw_blog.wordpress_version}"
bash 'extract wordpress' do
  cwd ::File.dirname(local_file)
  code <<-EOF
    mkdir -p #{node.wiw_blog.wordpress_root}
    tar xzf #{filename} -C #{node.wiw_blog.wordpress_root}
    chown -R #{node.wiw_blog.user}:#{node.wiw_blog.group} #{node.wiw_blog.wordpress_root}
    [ -d #{node.wiw_blog.wordpress_root}/wordpress ] && mv #{node.wiw_blog.wordpress_root}/wordpress #{sentinal}
    ln -f -s #{sentinal} #{node.wiw_blog.wordpress_root}/current
  EOF
  not_if { ::File.exist?(sentinal) }
  # Generally not preferable to do a restart, but the service as configured doens't
  # support a reload, would need circle back on this.
  notifies :restart, 'service[hhvm]'
  notifies :create, "template[#{node.wiw_blog.wordpress_root}/current/wp-config.php]", :immediately
end

user_passwd = unless (node.wiw_mysql.password_vault.nil? || node.wiw_mysql.username.nil?)
                passwds = chef_vault_item(node.wiw_mysql.password_vault,
                                          node.wiw_mysql.service_name)
                passwds[node.wiw_mysql.username]
              end
unless user_passwd.nil?
  template "#{node.wiw_blog.wordpress_root}/current/wp-config.php" do
    owner node.wiw_blog.user
    group node.wiw_blog.user
    mode 0400
    variables(
      database: node.wiw_mysql.username,
      db_user: node.wiw_mysql.username,
      db_passwd: user_passwd,
      db_sock:"#{node.wiw_mysql.sock_path}-#{node.wiw_mysql.service_name}/mysqld.sock" ,
    )
  end
end
