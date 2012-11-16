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

default['jira']['version']        = "5.2"
default['jira']['arch']           = "x64"
default['jira']['url']            = "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin"
default['jira']['checksum']       = "95841d1b222db63c5653b81583837a5d90e315a2ff2661534b310113afcff33f"
default['jira']['backup_home']    = true
default['jira']['backup_install'] = true
default['jira']['install_backup'] = "/tmp/atlassian-jira-backup.tgz"
default['jira']['install_path']   = "/opt/atlassian/jira"
default['jira']['home_backup']    = "/tmp/atlassian-jira-home-backup.tgz"
default['jira']['home_path']      = "/var/atlassian/application-data/jira"
default['jira']['user']           = "jira"
default['jira']['jvm']['minimum_memory']  = "256m"
default['jira']['jvm']['maximum_memory']  = "768m"
default['jira']['jvm']['maximum_permgen'] = "256m"
default['jira']['jvm']['java_opts']       = ""
default['jira']['jvm']['support_args']    = ""
default['jira']['tomcat']['port']     = "8080"
default['jira']['tomcat']['ssl_port'] = "8443"
