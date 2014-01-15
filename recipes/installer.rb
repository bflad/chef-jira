template "#{Chef::Config[:file_cache_path]}/atlassian-jira-response.varfile" do
  source 'response.varfile.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin" do
  source    node['jira']['url']
  checksum  node['jira']['checksum']
  mode      '0755'
  action    :create
end

execute "Installing Jira #{node['jira']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command "./atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin -q -varfile atlassian-jira-response.varfile"
  creates node['jira']['install_path']
end

execute 'Generating Self-Signed Java Keystore' do
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
