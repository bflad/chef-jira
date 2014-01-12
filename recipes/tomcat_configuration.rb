settings = Jira.settings(node)

template "#{node['jira']['install_path']}/bin/permgen.sh" do
  source 'permgen.sh.erb'
  owner  node['jira']['user']
  mode   '0755'
  notifies :restart, 'service[jira]', :delayed
end

template "#{node['jira']['install_path']}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner  node['jira']['user']
  mode   '0755'
  notifies :restart, 'service[jira]', :delayed
end

template "#{node['jira']['install_path']}/conf/server.xml" do
  source 'server.xml.erb'
  owner  node['jira']['user']
  mode   '0640'
  variables :tomcat => settings['tomcat']
  notifies :restart, 'service[jira]', :delayed
end

template "#{node['jira']['install_path']}/conf/web.xml" do
  source 'web.xml.erb'
  owner  node['jira']['user']
  mode   '0644'
  notifies :restart, 'service[jira]', :delayed
end
