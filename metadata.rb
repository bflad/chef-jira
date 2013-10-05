name              "jira"
maintainer        "Brian Flad"
maintainer_email  "bflad417@gmail.com"
license           "Apache 2.0"
description       "Installs/Configures Atlassian JIRA."
version           "1.7.0"
recipe            "jira", "Installs/configures Atlassian JIRA"
recipe            "jira::apache2", "Installs/configures Apache 2 as proxy (ports 80/443)"
recipe            "jira::database", "Installs/configures MySQL/Postgres server, database, and user for JIRA"
recipe            "jira::linux_installer", "Installs/configures JIRA via Linux installer"
recipe            "jira::linux_standalone", "Installs/configures JIRA via Linux standalone archive"
recipe            "jira::linux_war", "Deploys JIRA WAR on Linux"
recipe            "jira::tomcat_configuration", "Configures JIRA's built-in Tomcat"
recipe            "jira::upgrade", "Upgrades Atlassian JIRA"
recipe            "jira::windows_installer", "Installs/configures JIRA via Windows installer"
recipe            "jira::windows_standalone", "Installs/configures JIRA via Windows standalone archive"
recipe            "jira::windows_war", "Deploys JIRA WAR on Windows"

%w{ apache2 database java mysql mysql_connector postgresql }.each do |cb|
  depends cb
end

%w{ centos redhat ubuntu }.each do |os|
  supports os
end
