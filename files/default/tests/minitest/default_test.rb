require File.expand_path('../support/helpers', __FILE__)

describe_recipe "jira::default" do
  include Helpers::Jira

  it 'has jira user' do
    user(node['jira']['user']).must_exist.with(:home, node['jira']['home_path'])
  end

  it 'creates Java KeyStore' do
    file("#{node['jira']['home_path']}/.keystore").must_exist.with(:owner, node['jira']['user'])
  end

  it 'creates Jira properties file' do
    file("#{node['jira']['install_path']}/jira-config.properties").must_exist
  end

  it 'starts Jira' do
    service("jira").must_be_running
  end

  it 'enables Jira' do
    service("jira").must_be_enabled
  end
  
end
