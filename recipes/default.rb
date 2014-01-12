platform = 'windows' if node['platform_family'] == 'windows'
platform ||= 'linux'
settings = Jira.settings(node)

include_recipe 'jira::database' if settings['database']['host'] == 'localhost'
include_recipe "jira::#{platform}_#{node['jira']['install_type']}"

unless node['jira']['install_type'].match('war')
  include_recipe 'jira::tomcat_configuration'
  include_recipe 'jira::apache2'
end

include_recipe 'jira::configuration'
