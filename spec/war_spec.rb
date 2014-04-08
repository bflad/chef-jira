require 'spec_helper'

describe 'jira::war' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
