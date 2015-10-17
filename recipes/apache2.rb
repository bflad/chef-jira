node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['jira']['apache2']['port']] unless node['apache']['listen_ports'].include?(node['jira']['apache2']['port'])
node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['jira']['apache2']['ssl']['port']] unless node['apache']['listen_ports'].include?(node['jira']['apache2']['ssl']['port'])

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_ssl'

web_app node['jira']['apache2']['virtual_host_alias']
