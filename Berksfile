source 'https://supermarket.chef.io'

metadata

cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector'

group :integration do
  cookbook 'apt'
  cookbook 'java'
  cookbook 'tomcat'
  cookbook 'minitest-handler'
  cookbook 'jira_test', :path => 'test/cookbooks/jira_test'
end
