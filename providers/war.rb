def load_current_resource
  @current_resource = Chef::Resource::JiraWar.new(new_resource)
  @current_resource.built(::File.exists?(new_resource.file))
  @current_resource.downloaded(::File.directory?("#{new_resource.path}-#{new_resource.version}"))
  @current_resource
end

action :build do
  download
  unless built?
    build
    new_resource.updated_by_last_action(true)
  end
end

action :download do
  unless downloaded?
    download
    new_resource.updated_by_last_action(true)
  end
end

def build
  new_resource.exclude_jars.each do |jar|
    exclude_jar(jar, ::File.join(new_resource.path, 'webapp', 'WEB-INF', 'lib'))
  end

  execute "Building JIRA #{new_resource.version} in #{new_resource.path}" do
    cwd     new_resource.path
    command "./build.sh #{new_resource.targets}"
    creates new_resource.file
    only_if { node['jira']['build']['enable'] }
  end
end

def built?
  @current_resource.built
end

def download
  ark_path = ::File.basename(new_resource.path)
  prefix_path = ::File.dirname(new_resource.path)

  directory prefix_path do
    action :create
    recursive true
  end

  ark ark_path do
    checksum    new_resource.checksum
    prefix_home prefix_path
    prefix_root prefix_path
    url         new_resource.url
    version     new_resource.version
  end
end

def downloaded?
  @current_resource.downloaded
end

def exclude_jar(jar, path)
  excluded_jar = jar_exists?(jar, path)

  file excluded_jar do
    action :delete
    only_if { excluded_jar }
  end
end

def jar_exists?(jar, path)
  ::Dir.foreach(path) do |file|
    next unless file.end_with?('.jar')
    return ::File.join(path, file) if file =~ Regexp.new(jar + '-\d+\.\d+(\..*)?\.jar').freeze
  end
end
