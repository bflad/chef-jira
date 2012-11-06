#
# Cookbook Name:: jira
# Recipe:: upgrade
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

#
# Jira Upgrade Guide:
# https://confluence.atlassian.com/display/JIRA/Upgrading+JIRA
#

service "jira" do
  action :stop
end

execute "Backing up Jira Home Directory" do
  command "tar -zcf #{node['jira']['home_backup']} #{node['jira']['home_path']}"
  only_if { node['jira']['backup_home'] }
end

execute "Backing up Jira Install Directory" do
  command "tar -zcf #{node['jira']['install_backup']} #{node['jira']['install_path']}"
  only_if { node['jira']['backup_install'] }
end

directory node['jira']['install_path'] do
  recursive true
  action :delete
end

include_recipe "jira"

ruby_block "remove_recipe_jira_upgrade" do
  block { node.run_list.remove("recipe[jira::upgrade]") }
end
