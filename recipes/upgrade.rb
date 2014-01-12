#
# Jira Upgrade Guide:
# https://confluence.atlassian.com/display/JIRA/Upgrading+JIRA
#

service 'jira' do
  action :stop
end

execute 'Backing up Jira Home Directory' do
  command "tar -zcf #{node['jira']['home_backup']} #{node['jira']['home_path']}"
  only_if { node['jira']['backup_home'] }
end

execute 'Backing up Jira Install Directory' do
  command "tar -zcf #{node['jira']['install_backup']} #{node['jira']['install_path']}"
  only_if { node['jira']['backup_install'] }
end

directory node['jira']['install_path'] do
  recursive true
  action :delete
end

include_recipe 'jira'

ruby_block 'remove_recipe_jira_upgrade' do
  block { node.run_list.remove('recipe[jira::upgrade]') }
end
