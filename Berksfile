site :opscode

metadata

cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector'

group :integration do
  cookbook "java"
  cookbook "tomcat"
  cookbook "minitest-handler"
  cookbook "jira_test", :path => "test/cookbooks/jira_test"
end

