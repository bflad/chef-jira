def load_current_resource
  @current_resource = Chef::Resource::JiraJars.new(new_resource)
  @current_resource.downloaded(::File.directory?("#{new_resource.download_path}-#{new_resource.version}"))
  @current_resource
end

action :deploy do
  download
  deploy
  new_resource.updated_by_last_action(true)
end

action :download do
  unless downloaded?
    download
    new_resource.updated_by_last_action(true)
  end
end

def deploy
  # Use ruby_block to prevent jar_exists? logic execution during compilation
  ruby_block 'deploy_jira_jars' do
    block do
      new_resource.deploy_jars.each do |jar|
        deployable_jar = jar_exists?(jar, new_resource.download_path)
        deploy_jar(deployable_jar, new_resource.lib_path) if deployable_jar
      end
    end
  end
end

def deploy_jar(jar_path, install_path)
  jar = ::File.basename(jar_path)
  installed_jar = jar_exists?(jar, install_path)

  if installed_jar
    if ::File.identical?(jar, installed_jar)
      return
    else
      file installed_jar do
        action :delete
      end
    end
  end
  link ::File.join(install_path, jar) do
    to jar_path
  end
  new_resource.updated_by_last_action(true)
end

def download
  ark_path = ::File.basename(new_resource.download_path)
  prefix_path = ::File.dirname(new_resource.download_path)

  directory prefix_path do
    action :create
    recursive true
  end

  package 'unzip'

  ark ark_path do
    prefix_home       prefix_path
    prefix_root       prefix_path
    strip_leading_dir false
    url               new_resource.url
    version           new_resource.version
  end
end

def downloaded?
  @current_resource.downloaded
end

def jar_exists?(jar, path)
  ::Dir.foreach(path) do |file|
    next unless file.end_with?('.jar')
    return ::File.join(path, file) if file =~ Regexp.new(jar + '-\d+\.\d+(\..*)?\.jar').freeze
  end
end
