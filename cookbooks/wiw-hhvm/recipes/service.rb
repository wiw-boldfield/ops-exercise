#
# Cookbook Name:: wiw-hhvm
# Recipe:: service
#
# Copyright (C) 2016 Brian Oldfield
#
# All rights reserved - Do Not Redistribute
#

service 'hhvm' do
  supports status: true, restart: true, reload: true
  action   :enable
end
