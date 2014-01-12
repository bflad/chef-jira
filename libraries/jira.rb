# Chef::Recipe::Jira class
class Chef::Recipe::Jira
  def self.settings(node)
    begin
      if Chef::Config[:solo]
        begin
          settings = Chef::DataBagItem.load('jira', 'jira')['local']
        rescue
          Chef::Log.info('No jira data bag found')
        end
      else
        begin
          settings = Chef::EncryptedDataBagItem.load('jira', 'jira')[node.chef_environment]
        rescue
          Chef::Log.info('No jira encrypted data bag found')
        end
      end
    ensure
      settings ||= node['jira']

      case settings['database']['type']
      when 'mysql'
        settings['database']['port'] ||= 3306
      when 'postgresql'
        settings['database']['port'] ||= 5432
      else
        Chef::Log.warn('Unsupported database type.')
      end
    end

    settings
  end
end
