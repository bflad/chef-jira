execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

template '/etc/systemd/system/jira.service' do
  source 'jira.systemd.erb'
  mode '0755'
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[jira]', :delayed
end

service 'jira' do
  supports :status => :true, :restart => :true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end
