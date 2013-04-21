#
# Cookbook Name:: jira
# Recipe:: configuration
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

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source "dbconfig.xml.erb"
  owner  node['jira']['user']
  mode   "0644"
  variables :database => settings['database']
  notifies :restart, "service[jira]", :delayed
end

#template "#{node['jira']['home_path']}/jira-config.properties" do
#  source "jira-config.properties.erb"
#  owner  node['jira']['user']
#  mode   "0644"
#  notifies :restart, "service[stash]", :delayed
#end
