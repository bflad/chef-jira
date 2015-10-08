default['jira']['home_path']    = '/var/atlassian/application-data/jira'
default['jira']['init_type']    = 'sysv'
default['jira']['install_path'] = '/opt/atlassian/jira'
default['jira']['install_type'] = 'installer'
default['jira']['version']      = '6.1.5'

# Defaults are automatically selected from version via helper functions
default['jira']['url']      = nil
default['jira']['checksum'] = nil

default['jira']['apache2']['access_log']         = ''
default['jira']['apache2']['error_log']          = ''
default['jira']['apache2']['port']               = 80
default['jira']['apache2']['virtual_host_alias'] = node['fqdn']
default['jira']['apache2']['virtual_host_name']  = node['hostname']

default['jira']['apache2']['ssl']['access_log']       = ''
default['jira']['apache2']['ssl']['chain_file']       = ''
default['jira']['apache2']['ssl']['error_log']        = ''
default['jira']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['jira']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['jira']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['jira']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['jira']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['jira']['container_server']['name'] = 'tomcat'
default['jira']['container_server']['version'] = '6'

default['jira']['build']['targets'] = 'war'
default['jira']['build']['enable'] = true
default['jira']['build']['exclude_jars'] = %w(jcl-over-slf4j jul-to-slf4j log4j slf4j-api slf4j-log4j12)
default['jira']['build']['file'] = "#{node['jira']['install_path']}/dist-#{node['jira']['container_server']['name']}/atlassian-jira-#{node['jira']['version']}.war"

default['jira']['database']['host']     = 'localhost'
default['jira']['database']['name']     = 'jira'
default['jira']['database']['password'] = 'changeit'
default['jira']['database']['type']     = 'mysql'
default['jira']['database']['user']     = 'jira'

# Default is automatically selected from database type via helper function
default['jira']['database']['port'] = nil

default['jira']['jars']['deploy_jars'] = %w(carol carol-properties hsqldb jcl-over-slf4j jonas_timer jotm jotm-iiops_stubs jotm-jmrp_stubs jta jul-to-slf4j log4j objectweb-datasource ots-jts slf4j-api slf4j-log4j12 xapool)
default['jira']['jars']['install_path'] = node['jira']['install_path'] + '-jars'
default['jira']['jars']['url_base'] = 'http://www.atlassian.com/software/jira/downloads/binary/jira-jars'
default['jira']['jars']['version'] = node['jira']['version'].split('.')[0..1].join('.')
default['jira']['jars']['url'] = "#{node['jira']['jars']['url_base']}-#{node['jira']['container_server']['name']}-distribution-#{node['jira']['jars']['version']}-#{node['jira']['container_server']['name']}-#{node['jira']['container_server']['version']}x.zip"

default['jira']['jvm']['minimum_memory']  = '256m'
default['jira']['jvm']['maximum_memory']  = '768m'
default['jira']['jvm']['maximum_permgen'] = '256m'
default['jira']['jvm']['java_opts']       = ''
default['jira']['jvm']['support_args']    = ''

default['jira']['tomcat']['keyAlias']     = 'tomcat'
default['jira']['tomcat']['keystoreFile'] = "#{node['jira']['home_path']}/.keystore"
default['jira']['tomcat']['keystorePass'] = 'changeit'
default['jira']['tomcat']['port']     = '8080'
default['jira']['tomcat']['ssl_port'] = '8443'

default['jira']['war']['file'] = node['jira']['build']['file']

case node['jira']['container_server']['name']
when 'tomcat'
  if node['jira']['install_type'] == 'war'
    default['jira']['context'] = 'jira'
    begin
      default['jira']['context_path'] = node['tomcat']['context_dir']
      default['jira']['lib_path'] = node['tomcat']['lib_dir']
      default['jira']['user'] = node['tomcat']['user']
    rescue
      default['jira']['context_path'] = "/usr/share/tomcat#{node['jira']['container_server']['version']}/conf/Catalina/localhost"
      default['jira']['lib_path'] = "/usr/share/tomcat#{node['jira']['container_server']['version']}/lib"
      default['jira']['user'] = 'tomcat'
    end
  else
    default['jira']['context'] = ''
    default['jira']['context_path'] = "#{node['jira']['install_path']}/conf/Catalina/localhost"
    default['jira']['lib_path'] = "#{node['jira']['install_path']}/lib"
    default['jira']['user'] = 'jira'
  end
end
