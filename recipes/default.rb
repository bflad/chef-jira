#
# Cookbook Name:: jira
# Recipe:: default
#
# Copyright 2012
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

include_recipe "database"

jira_data_bag = Chef::EncryptedDataBagItem.load("jira","jira")
jira_configuration_info = jira_data_bag[node.chef_environment]['configuration']
jira_database_info = jira_data_bag[node.chef_environment]['database']
jira_tomcat_info = jira_data_bag[node.chef_environment]['tomcat']

case jira_database_info['type']
when "mysql"
  jira_database_info['port'] ||= 3306
  jira_database_info['provider'] = Chef::Provider::Database::Mysql
  jira_database_info['provider_user'] = Chef::Provider::Database::MysqlUser
when "postgresql"
  jira_database_info['port'] ||= 5432
  jira_database_info['provider'] = Chef::Provider::Database::Postgresql
  jira_database_info['provider_user'] = Chef::Provider::Database::PostgresqlUser
else
  Chef::Log.warn("Unsupported database type.")
end

if jira_database_info['host'] == "localhost"
  database_connection = {
    :host => jira_database_info['host'],
    :port => jira_database_info['port']
  }

  case jira_database_info['type']
  when "mysql"
    include_recipe "mysql::server"
    include_recipe "database::mysql"
    database_connection.merge!({ :username => 'root', :password => node['mysql']['server_root_password'] })
  when "postgresql"
    include_recipe "postgresql::server"
    include_recipe "database::postgresql"
    database_connection.merge!({ :username => 'postgres', :password => node['postgresql']['password']['postgres'] })
  end
  
  database jira_database_info['name'] do
    connection database_connection
    provider jira_database_info['provider']
    case jira_database_info['type']
    when "mysql"
      collation "utf8_bin"
    when "postgresql"
      connection_limit "-1"
    end
    encoding "utf8"
    action :create
  end

  database_user jira_database_info['user'] do
    connection database_connection
    provider jira_database_info['provider_user']
    host "%" if jira_database_info['type'] == "mysql"
    password jira_database_info['password']
    database_name jira_database_info['name']
    action [:create, :grant]
  end
end

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

if jira_database_info['type'] == "mysql"
  include_recipe "mysql_connector"
  mysql_connector_j "#{node['jira']['install_path']}/lib"
end

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source "dbconfig.xml.erb"
  owner  node['jira']['user']
  mode   "0644"
  variables :database => jira_database_info
  notifies :restart, "service[jira]", :delayed
end

#template "#{node['jira']['home_path']}/jira-config.properties" do
#  source "jira-config.properties.erb"
#  owner  node['jira']['user']
#  mode   "0644"
#  notifies :restart, "service[stash]", :delayed
#end

template "#{node['jira']['install_path']}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner  node['jira']['user']
  mode   "0755"
  notifies :restart, "service[jira]", :delayed
end

template "#{node['jira']['install_path']}/conf/server.xml" do
  source "server.xml.erb"
  owner  node['jira']['user']
  mode   "0640"
  variables :tomcat => jira_tomcat_info
  notifies :restart, "service[jira]", :delayed
end

template "#{node['jira']['install_path']}/conf/web.xml" do
  source "web.xml.erb"
  owner  node['jira']['user']
  mode   "0644"
  notifies :restart, "service[jira]", :delayed
end

service "jira" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources("java_ark[jdk]")
end
