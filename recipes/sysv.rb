template '/etc/init.d/jira' do
  source 'jira.init.erb'
  mode '0755'
  notifies :restart, 'service[jira]', :delayed
end

service 'jira' do
  supports :status => :true, :restart => :true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end
