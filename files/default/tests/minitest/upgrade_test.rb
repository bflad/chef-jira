require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'jira::upgrade' do
  include Helpers::Jira

  it 'starts Jira' do
    service('jira').must_be_running
  end

  it 'enables Jira' do
    service('jira').must_be_enabled
  end

end
