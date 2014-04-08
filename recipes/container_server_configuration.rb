settings = Jira.settings(node)

case node['jira']['container_server']['name']
when 'tomcat'
  if node['jira']['install_type'] == 'war'
    # Only should configure context pointing to war file

    template "#{node['jira']['context_path']}/#{node['jira']['context']}.xml" do
      source 'tomcat/context.xml.erb'
      notifies :restart, 'service[tomcat]', :delayed
      only_if "test -f #{node['jira']['war']['file']}"
    end
  else
    # Installer and standalone installs bundle a Tomcat instance
    # This section customizes said Tomcat instance

    template "#{node['jira']['install_path']}/bin/permgen.sh" do
      source 'tomcat/permgen.sh.erb'
      owner node['jira']['user']
      mode '0755'
      notifies :restart, 'service[jira]', :delayed
    end

    template "#{node['jira']['install_path']}/bin/setenv.sh" do
      source 'tomcat/setenv.sh.erb'
      owner node['jira']['user']
      mode '0755'
      notifies :restart, 'service[jira]', :delayed
    end

    template "#{node['jira']['install_path']}/conf/server.xml" do
      source 'tomcat/server.xml.erb'
      owner node['jira']['user']
      mode '0640'
      variables :tomcat => settings['tomcat']
      notifies :restart, 'service[jira]', :delayed
    end

    template "#{node['jira']['install_path']}/conf/web.xml" do
      source 'tomcat/web.xml.erb'
      owner node['jira']['user']
      mode '0644'
      notifies :restart, 'service[jira]', :delayed
    end
  end
end
