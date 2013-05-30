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

default['jira']['backup_home']    = true
default['jira']['backup_install'] = true
default['jira']['home_backup']    = "/tmp/atlassian-jira-home-backup.tgz"
default['jira']['home_path']      = "/var/atlassian/application-data/jira"
default['jira']['install_backup'] = "/tmp/atlassian-jira-backup.tgz"
default['jira']['install_path']   = "/opt/atlassian/jira"
default['jira']['install_type']   = "installer"
default['jira']['url_base']       = "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira"
default['jira']['user']           = "jira"
default['jira']['version']        = "6.0.1"

if node['kernel']['machine'] == "x86_64"
  default['jira']['arch'] = "x64"
else
  default['jira']['arch'] = "x32"
end

case node['platform_family']
when "windows"
  case node['jira']['install_type']
  when "installer"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}-#{node['jira']['arch']}.exe"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; node['jira']['arch'] == "x64" ? "55161ba22f51b168fc33e751851de099911b5f648b02c43d77b37ed4f3d88586" : "9d57ecb6d487754b965a0ffed8b644122fef500af0c068ddb755a4685df21ca4"
    when "5.2.11"; node['jira']['arch'] == "x64" ? "a3ac923ff8563d178853222f4ebf246f78af6d1e1f4ea503b3b6443ecbdc9258" : "336297395d6cb0f0b80503bb88e545f441608a31d9af492b27fa4e4045e04c0f"
    when "6.0"; node['jira']['arch'] == "x64" ? "971f0d6242eb8aa02e47b086428d1f1fe46ea6c7a0859412303be2cc909487c7" : "0d7e6dc83e4fbca5b5ec5a62d40ac18c6b81d9dda470251e954a0035bee328e6"
    when "6.0.1"; node['jira']['arch'] == "x64" ? "47f0e16cdce30900135e425e978359db13fb5b913d8c8aadcfa7e6b4870c30c2" : "651b5bac996575c153e0dd2310a390b403aa28bd0c3a0d197dcdf5772155df65"
    end
  when "standalone"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}.zip"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; "a8ef62077f87d9f22d60c3e558436b11cf5e8664d4a417f622a33257d46ba3f1"
    when "5.2.11"; "7ea1a106e9d70f6d9a53a4c7d49a975cdfeadbae75f6452542e192c897f1faf0"
    when "6.0"; "bdd47d3e30827e445288faf211992d7e96170ebae11e2451cc0362afe8de6ab1"
    when "6.0.1"; "367dcb92f2e006cda86997b363f0835d3bfd75d4492404c1a496aad1251bdf9b"
    end
  when "war"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}-war.zip"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; "e3ef2c555accfa40399b287a46c7ffd75b3d87d9a691b33e2b9cd359f7a3d433"
    when "5.2.11"; "b372a1c1e7f7983a3413adcaa0f027b03c6f986cc5c7d833f52488350dc65c93"
    when "6.0"; "6a46035d2fd9b9425df631d2fdeca13ab2e36814de30a3a50b88a234eabd3f66"
    when "6.0.1"; "d6b63f05d5ce2530592e5e174411a9a5104007e92a84a3f032f73526efabb10f"
    end
  end
else
  case node['jira']['install_type']
  when "installer"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}-#{node['jira']['arch']}.bin"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; node['jira']['arch'] == "x64" ? "95841d1b222db63c5653b81583837a5d90e315a2ff2661534b310113afcff33f" : "05335145554cc446adfb90e318139f9408b41cacb57d90d0e11b788718ed8734"
    when "5.2.11"; node['jira']['arch'] == "x64" ? "ad4a851e7dedd6caf3ab587c34155c3ea68f8e6b878b75a3624662422966dff4" : "7088a7d123e263c96ff731d61512c62aef4702fe92ad91432dc060bab5097cb7"
    when "6.0"; node['jira']['arch'] == "x64" ? "915b773c9870ebacbee4712e26d1c9539b48210b6055cb1b2d81e662deae2e60" : "3967f8f663c24ff51bf30300ae0f2fb27320c9b356ed4dbf78fce7cc1238eccb"
    when "6.0.1"; node['jira']['arch'] == "x64" ? "4e56ef7980b8f3b5b434a7a440d663b9d08e5588d635214e4434eabc3a8d9623" : "e383961667e6ef6b5bc387123fa76620a5bdf71413283de5b79cd0ae71248922"
    end
  when "standalone"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}.tar.gz"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; "80e05e65778ce2e3d91422da9d30a547e174fe2b9ba920b7dcdff78e29f353da"
    when "5.2.11"; "8d18b1da9487c1502efafacc441ad9a9dc55219a2838a1f02800b8a9a9b3d194"
    when "6.0"; "791a8a4a65e40cd00c1ee2a3207935fbcc2c103416e739ad4e3ed29e39372383"
    when "6.0.1"; "492e46119310f378d7944dea0a92c470f0d0b794219d6647a92ea08f8e99f80e"
    end
  when "war"
    default['jira']['url']      = "#{node['jira']['url_base']}-#{node['jira']['version']}-war.tar.gz"
    default['jira']['checksum'] = case node['jira']['version']
    when "5.2"; "521f0f60500b8f9e1700af3024e5d51a378e3a63a3c6173a66ae298ddadb3d4b"
    when "5.2.11"; "11e34312389362260af26b95aa83a4d3c43705e56610f0f691ceaf46e908df6a"
    when "6.0"; "53583c56e6697201813eca07ca87c0d2010359f68d29f6b20b09d1ecad8c185b"
    when "6.0.1"; "525f62eee680e3a0f6e602dbb8c9ed83b7e17c730009530dd1a88f175e2bed85"
    end
  end
end

default['jira']['apache2']['access_log']         = ""
default['jira']['apache2']['error_log']          = ""
default['jira']['apache2']['port']               = 80
default['jira']['apache2']['virtual_host_alias'] = node['fqdn']
default['jira']['apache2']['virtual_host_name']  = node['hostname']

default['jira']['apache2']['ssl']['access_log']       = ""
default['jira']['apache2']['ssl']['chain_file']       = ""
default['jira']['apache2']['ssl']['error_log']        = ""
default['jira']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['jira']['apache2']['ssl']['certificate_file'] = "/etc/pki/tls/certs/localhost.crt"
  default['jira']['apache2']['ssl']['key_file']         = "/etc/pki/tls/private/localhost.key"
else
  default['jira']['apache2']['ssl']['certificate_file'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
  default['jira']['apache2']['ssl']['key_file']         = "/etc/ssl/private/ssl-cert-snakeoil.key"
end

default['jira']['database']['host']     = "localhost"
default['jira']['database']['name']     = "jira"
default['jira']['database']['password'] = "changeit"
default['jira']['database']['port']     = 3306
default['jira']['database']['type']     = "mysql"
default['jira']['database']['user']     = "jira"

default['jira']['jvm']['minimum_memory']  = "256m"
default['jira']['jvm']['maximum_memory']  = "768m"
default['jira']['jvm']['maximum_permgen'] = "256m"
default['jira']['jvm']['java_opts']       = ""
default['jira']['jvm']['support_args']    = ""

default['jira']['tomcat']['keyAlias']     = "tomcat"
default['jira']['tomcat']['keystoreFile'] = "#{node['jira']['home_path']}/.keystore"
default['jira']['tomcat']['keystorePass'] = "changeit"
default['jira']['tomcat']['port']     = "8080"
default['jira']['tomcat']['ssl_port'] = "8443"
