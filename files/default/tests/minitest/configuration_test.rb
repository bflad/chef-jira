require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'jira::configuration' do
  include Helpers::Jira

  it 'creates Jira database configuration file' do
    file("#{node['jira']['home_path']}/dbconfig.xml").must_exist
  end

  # it 'creates Jira properties file' do
  #  file("#{node['jira']['install_path']}/jira-config.properties").must_exist
  # end

end
