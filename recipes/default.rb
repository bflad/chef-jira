settings = Jira.settings(node)

include_recipe 'jira::database' if settings['database']['host'] == 'localhost'
include_recipe "jira::#{node['jira']['install_type']}"
include_recipe 'jira::configuration'
include_recipe 'jira::build_war' if node['jira']['install_type'] == 'war'
include_recipe 'jira::container_server_jars'
include_recipe 'jira::container_server_configuration'
unless node['jira']['install_type'] == 'war'
  include_recipe "jira::#{node['jira']['init_type']}"
  include_recipe 'jira::apache2'
end
