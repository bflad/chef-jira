name              "jira"
maintainer        "Brian Flad"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/Configures Atlassian Jira."
version           "0.1.0"
recipe            "jira", "Installs/Configures Atlassian Jira."
recipe            "jira::apache2", "Installs/Configures Atlassian Jira behind Apache2"
recipe            "jira::upgrade", "Upgrades Atlassian Jira"

%w{ apache2 database java mysql mysql_connector postgresql }.each do |cb|
  depends cb
end

%w{ redhat }.each do |os|
  supports os
end
