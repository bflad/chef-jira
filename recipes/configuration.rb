settings = Jira.settings(node)

directory node['jira']['home_path'] do
  owner node['jira']['user']
  action :create
  recursive true
end

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner node['jira']['user']
  mode '0644'
  variables :database => settings['database']
  notifies :restart, 'service[jira]', :delayed unless node['jira']['install_type'] == 'war'
end

template "#{node['jira']['install_path']}/edit-webapp/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  mode '0644'
  only_if { node['jira']['install_type'] == 'war' }
end
