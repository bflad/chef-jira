require "minitest/autorun"

describe_recipe "template-cookbook::alternate" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
end
