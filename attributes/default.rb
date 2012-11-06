#
# Cookbook Name:: jira
# Attributes:: default
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

default['jira']['version']        = "5.1.8"
default['jira']['url']            = "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-#{node['jira']['version']}-x64.bin"
default['jira']['checksum']       = "7bca0fb89f48765da03dfb52b1b897c08b1d85354bfe6f2e0dd67f2b3603bbcc"
default['jira']['backup_home']    = true
default['jira']['backup_install'] = true
default['jira']['install_backup'] = "/tmp/atlassian-jira-backup.tgz"
default['jira']['install_path']   = "/opt/atlassian-jira"
default['jira']['user']           = "jira"
default['jira']['home_backup']    = "/tmp/atlassian-jira-home-backup.tgz"
default['jira']['home_path']      = "/home/#{node['jira']['user']}"
default['jira']['jvm']['minimum_memory']  = "256m"
default['jira']['jvm']['maximum_memory']  = "768m"
default['jira']['jvm']['maximum_permgen'] = "256m"
default['jira']['jvm']['java_opts']       = ""
default['jira']['jvm']['support_args']    = ""
default['jira']['tomcat']['port']     = "7990"
default['jira']['tomcat']['ssl_port'] = "8443"
