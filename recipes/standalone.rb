ark_prefix_path = ::File.dirname(node['jira']['install_path']) if ::File.basename(node['jira']['install_path']) == 'jira'
ark_prefix_path ||= node['jira']['install_path']
settings = Jira.settings(node)

directory File.dirname(node['jira']['home_path']) do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true
end

user node['jira']['user'] do
  comment 'JIRA Service Account'
  home node['jira']['home_path']
  shell '/bin/bash'
  supports :manage_home => true
  system true
  action :create
end

execute 'Generating Self-Signed Java Keystore' do
  command <<-COMMAND
    #{node['java']['java_home']}/bin/keytool -genkey \
      -alias #{settings['tomcat']['keyAlias']} \
      -keyalg RSA \
      -dname 'CN=#{node['fqdn']}, OU=Example, O=Example, L=Example, ST=Example, C=US' \
      -keypass #{settings['tomcat']['keystorePass']} \
      -storepass #{settings['tomcat']['keystorePass']} \
      -keystore #{settings['tomcat']['keystoreFile']}
    chown #{node['jira']['user']}:#{node['jira']['user']} #{settings['tomcat']['keystoreFile']}
  COMMAND
  creates settings['tomcat']['keystoreFile']
  only_if { settings['tomcat']['keystoreFile'] == "#{node['jira']['home_path']}/.keystore" }
end

directory ark_prefix_path do
  action :create
  recursive true
end

ark 'jira' do
  url node['jira']['url']
  prefix_root ark_prefix_path
  prefix_home ark_prefix_path
  checksum node['jira']['checksum']
  version node['jira']['version']
  owner node['jira']['user']
  group node['jira']['user']
end
