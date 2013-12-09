require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'jira::default' do
  include Helpers::Jira

  it 'has jira user' do
    user(node['jira']['user']).must_exist
  end

  it 'creates Java KeyStore' do
    file("#{node['jira']['home_path']}/.keystore").must_exist.with(:owner, node['jira']['user'])
  end

  it 'starts Jira' do
    service('jira').must_be_running
  end

  it 'enables Jira' do
    service('jira').must_be_enabled
  end

end
