# chef-jira [![Build Status](https://secure.travis-ci.org/bflad/chef-jira.png?branch=master)](http://travis-ci.org/bflad/chef-jira)

## Description

Installs/Configures Atlassian JIRA. Please see [COMPATIBILITY.md](COMPATIBILITY.md) for more information about JIRA releases that are tested and supported by this cookbook and its versions.

## Requirements

### Platforms

* CentOS 6
* RedHat 6
* Ubuntu 12.04

### Databases

* Microsoft SQL Server
* MySQL
* Postgres

### Cookbooks

Required [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2) (if using apache2 recipe)
* [database](https://github.com/opscode-cookbooks/database) (if using database recipe)
* [mysql](https://github.com/opscode-cookbooks/mysql) (if using database recipe with MySQL)
* [postgresql](https://github.com/opscode-cookbooks/postgresql) (if using database recipe with Postgres)

Required Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)

Suggested [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [java](https://github.com/opscode-cookbooks/java)

### JDK/JRE

The Atlassian JIRA Linux installer will automatically configure a bundled JRE. If you wish to use your own JDK/JRE, with say the `java` cookbook, then as of this writing it must be Oracle and version 1.6 ([Supported Platforms](https://confluence.atlassian.com/display/JIRA/Supported+Platforms))

Necessary configuration with `java` cookbook:
* `node['java']['install_flavor'] = "oracle"`
* `node['java']['oracle']['accept_oracle_download_terms'] = true`
* `recipe[java]`

A /ht to [@seekely](https://github.com/seekely) for the [documentation nudge](https://github.com/bflad/chef-jira/issues/2).

## Attributes

These attributes are under the `node['jira']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
arch | architecture for JIRA installer - "x64" or "x32" | String | auto-detected (see attributes/default.rb)
backup_home | backup home directory during upgrade | Boolean | true
backup_install | backup install directory during upgrade | Boolean | true
checksum | SHA256 checksum for JIRA install | String | auto-detected (see attributes/default.rb)
home_backup | home backup location | String | /tmp/atlassian-jira-home-backup.tgz
home_path | home directory for JIRA | String | /var/atlassian/application-data/jira
install_backup | install backup location | String | /tmp/atlassian-jira-backup.tgz
install_path | location to install JIRA | String | /opt/atlassian/jira
install_type | JIRA install type - "installer", "standalone", "war" | String | installer
url_base | URL base for JIRA install | String | http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira
url | URL for JIRA install | String | auto-detected (see attributes/default.rb)
user | user running JIRA | String | jira
version | Confluence version to install | String | 6.1

### JIRA Database Attributes

All of these `node['jira']['database']` attributes are overridden by `jira/jira` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
host | FQDN or "localhost" (localhost automatically installs `['database']['type']` server in default recipe) | String | localhost
name | JIRA database name | String | jira
password | JIRA database user password | String | changeit
port | JIRA database port | Fixnum | 3306
type | JIRA database type - "mssql", "mysql", or "postgresql" | String | mysql
user | JIRA database user | String | jira

### JIRA JVM Attributes

These attributes are under the `node['jira']['jvm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 768m
maximum_permgen | JVM maximum PermGen memory | String | 256m
java_opts | additional JAVA_OPTS to be passed to JIRA JVM during startup | String | ""
support_args | additional JAVA_OPTS recommended by Atlassian support for JIRA JVM during startup | String | ""

### JIRA Tomcat Attributes

These attributes are under the `node['jira']['tomcat']` namespace.

Any `node['confluence']['tomcat']['key*']` attributes are overridden by `confluence/confluence` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
keyAlias | Tomcat SSL keystore alias | String | tomcat
keystoreFile | Tomcat SSL keystore file - will automatically generate self-signed keystore file if left as default | String | `#{node['jira']['home_path']}/.keystore`
keystorePass | Tomcat SSL keystore passphrase | String | changeit
port | Tomcat HTTP port | Fixnum | 8080
ssl_port | Tomcat HTTPS port | Fixnum | 8443

## Recipes

* `recipe[jira]` Installs/configures Atlassian JIRA
* `recipe[jira::apache2]` Installs/configures Apache 2 as proxy (ports 80/443)
* `recipe[jira::database]` Installs/configures MySQL/Postgres server, database, and user for JIRA
* `recipe[jira::linux_installer]` Installs/configures JIRA via Linux installer"
* `recipe[jira::linux_standalone]` Installs/configures JIRA via Linux standalone archive"
* `recipe[jira::linux_war]` Deploys JIRA WAR on Linux"
* `recipe[jira::tomcat_configuration]` Configures JIRA's built-in Tomcat
* `recipe[jira::upgrade]` Upgrades Atlassian JIRA
* `recipe[jira::windows_installer]` Installs/configures JIRA via Windows installer"
* `recipe[jira::windows_standalone]` Installs/configures JIRA via Windows standalone archive"
* `recipe[jira::windows_war]` Deploys JIRA WAR on Windows"

## Usage

### JIRA Server Data Bag

For securely overriding attributes on Hosted Chef, create a `jira/jira` encrypted data bag with the model below. Chef Solo can override the same attributes with a `jira/jira` unencrypted data bag of the same information.

_required:_
* `['database']['type']` - "mssql", "mysql", or "postgresql"
* `['database']['host']` - FQDN or "localhost" (localhost automatically installs `['database']['type']` server)
* `['database']['name']` - Name of JIRA database
* `['database']['user']` - JIRA database username
* `['database']['password']` - JIRA database username password

_optional:_
* `['database']['port']` - Database port, defaults to standard database port for `['database']['type']`
* `['tomcat']['keyAlias']` - Tomcat HTTPS Java Keystore keyAlias, defaults to self-signed certifcate
* `['tomcat']['keystoreFile']` - Tomcat HTTPS Java Keystore keystoreFile,
  defaults to self-signed certificate
* `['tomcat']['keystorePass']` - Tomcat HTTPS Java Keystore keystorePass, defaults to self-signed certificate

Repeat for other Chef environments as necessary. Example:

    {
      "id": "jira",
      "development": {
        "database": {
          "type": "postgresql",
          "host": "localhost",
          "name": "jira",
          "user": "jira",
          "password": "jira_db_password",
        },
        "tomcat": {
          "keyAlias": "not_tomcat",
          "keystoreFile": "/etc/pki/java/wildcard_cert.jks",
          "keystorePass": "not_changeit"
        }
      }
    }

### JIRA Installation

The simplest method is via the default recipe, which uses `node['jira']['install_type']` to determine best method.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add `recipe[jira]` to your node's run list.

### Custom JIRA Configurations

Using individual recipes, you can use this cookbook to configure JIRA to fit your environment.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add individual recipes to your node's run list.

### JIRA Upgrades

* Update `node['jira']['version']` and `node['jira']['checksum']` attributes
* Add `recipe[jira::upgrade]` to your run_list, such as:
  `knife node run_list add NODE_NAME "recipe[jira::upgrade]"`
  It will automatically remove itself from the run_list after completion.

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    gem install bundler --no-ri --no-rdoc
    git clone git://github.com/bflad/chef-jira.git
    cd chef-jira
    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-omnibus
    vagrant up BOX # BOX being centos6 or ubuntu1204

You may need to add the following hosts entries:

* 192.168.50.10 jira-centos-6
* 192.168.50.11 jira-ubuntu-1204

The running JIRA server is accessible from the host machine:

CentOS 6 Box:
* Web UI: https://192.168.50.10/

Ubuntu 12.04 Box:
* Web UI: https://192.168.50.11/

You can then SSH into the running VM using the `vagrant ssh` command.
The VM can easily be stopped and deleted with the `vagrant destroy`
command. Please see the official [Vagrant documentation](http://vagrantup.com/v1/docs/commands.html)
for a more in depth explanation of available commands.

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## License and Author

Author:: Brian Flad (<bflad417@gmail.com>)

Copyright:: 2012-2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
