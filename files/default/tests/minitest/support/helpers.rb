module Helpers
  module TemplateCookbook
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def ran_recipe?(recipe)
      node.run_state[:seen_recipes].keys.include?(recipe)
    end
  end
end
