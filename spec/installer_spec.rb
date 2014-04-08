require 'spec_helper'

describe 'jira::installer' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
