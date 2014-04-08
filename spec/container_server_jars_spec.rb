require 'spec_helper'

describe 'jira::container_server_jars' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
