#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe "nodejs"

apt_update "update_sources" do
  action :update
end

nodejs_npm "pm2" do
  action :install
end

package "nginx" do
  action :install
end

template "/etc/nginx/sites-available/proxy.conf" do
  source "proxy.conf.erb"
  notifies(:restart, "service[nginx]")
end

link "/etc/nginx/sites-enabled/proxy.conf" do
  to "/etc/nginx/sites-available/proxy.conf"
  notifies(:restart, "service[nginx]")
end

link "/etc/nginx/sites-enabled/default" do
  action :delete
  notifies(:restart, "service[nginx]")
end

service "nginx" do
  action [:enable, :start]
end
