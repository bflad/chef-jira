settings = Jira.settings(node)

directory node['jira']['lib_path'] do
  action :create
end

mysql_connector_j node['jira']['lib_path'] if settings['database']['type'] == 'mysql'

jira_jars node['jira']['jars']['install_path'] do
  action :deploy
  only_if { node['jira']['install_type'] == 'war' && node['jira']['container_server']['name'] == 'tomcat' }
end
