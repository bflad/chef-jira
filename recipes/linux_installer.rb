#
# Cookbook Name:: jira
# Recipe:: linux_installer
#
# Copyright 2013, Brian Flad
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

settings = Jira.settings(node)

template "#{Chef::Config[:file_cache_path]}/atlassian-jira-response.varfile" do
  source "response.varfile.erb"
  owner "root"
  group "root"
  mode "0644"
end

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin" do
  source    node['jira']['url']
  checksum  node['jira']['checksum']
  mode      "0755"
  action    :create_if_missing
end

execute "Installing Jira #{node['jira']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command "./atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin -q -varfile atlassian-jira-response.varfile"
  creates node['jira']['install_path']
end

execute "Generating Self-Signed Java Keystore" do
  command <<-COMMAND
    #{node['java']['java_home']}/bin/keytool -genkey \
      -alias tomcat \
      -keyalg RSA \
      -dname 'CN=#{node['fqdn']}, OU=Example, O=Example, L=Example, ST=Example, C=US' \
      -keypass changeit \
      -storepass changeit \
      -keystore #{node['jira']['home_path']}/.keystore
    chown #{node['jira']['user']}:#{node['jira']['user']} #{node['jira']['home_path']}/.keystore
  COMMAND
  creates "#{node['jira']['home_path']}/.keystore"
end

mysql_connector_j "#{node['jira']['install_path']}/lib" if settings['database']['type'] == "mysql"

template "/etc/init.d/jira" do
  source "jira.init.erb"
  mode   "0755"
  notifies :restart, "service[jira]", :delayed
end

service "jira" do
  supports :status => :true, :restart => :true
  action :enable
  subscribes :restart, "java_ark[jdk]"
end
