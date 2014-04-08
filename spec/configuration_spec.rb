require 'spec_helper'

describe 'jira::configuration' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
