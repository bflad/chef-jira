settings = Jira.settings(node)

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner  node['jira']['user']
  mode   '0644'
  variables :database => settings['database']
  notifies :restart, 'service[jira]', :delayed
end

# template "#{node['jira']['home_path']}/jira-config.properties" do
#  source "jira-config.properties.erb"
#  owner  node['jira']['user']
#  mode   "0644"
#  notifies :restart, "service[stash]", :delayed
# end
