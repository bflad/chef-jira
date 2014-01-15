actions :build, :download

default_action :download

attribute :path, :name_attribute => true

attribute :checksum, :kind_of => [String], :default => node['jira']['checksum']
attribute :exclude_jars, :kind_of => [Array], :default => node['jira']['build']['exclude_jars']
attribute :file, :kind_of => [String], :default => node['jira']['build']['file']
attribute :targets, :kind_of => [String], :default => node['jira']['build']['targets']
attribute :url, :kind_of => [String], :default => node['jira']['url']
attribute :version, :kind_of => [String], :default => node['jira']['version']

# Internal attributes
attribute :built, :kind_of => [TrueClass, FalseClass], :default => false
attribute :downloaded, :kind_of => [TrueClass, FalseClass], :default => false
