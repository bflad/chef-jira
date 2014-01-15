actions :deploy, :download

default_action :download

attribute :download_path, :name_attribute => true

attribute :deploy_jars, :kind_of => [Array], :default => node['jira']['jars']['deploy_jars']
attribute :lib_path, :kind_of => [String], :default => node['jira']['lib_path']
attribute :url, :kind_of => [String], :default => node['jira']['jars']['url']
attribute :version, :kind_of => [String], :default => node['jira']['jars']['version']

# Internal attributes
attribute :downloaded, :kind_of => [TrueClass, FalseClass], :default => false
