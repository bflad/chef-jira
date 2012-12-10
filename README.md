# chef-jira [![Build Status](https://secure.travis-ci.org/bflad/chef-jira.png?branch=master)](http://travis-ci.org/bflad/chef-jira)

## Description

Installs/Configures Atlassian Jira.

## Requirements

### Platforms

* RedHat 6.3

### Databases

* MySQL
* Postgres

### Cookbooks

Opscode Cookbooks (http://github.com/opscode-cookbooks/)

* apache2 (if using Apache 2 as proxy)
* database
* java
* mysql (if using MySQL database)
* postgresql (if using Postgres database)

Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)

### JDK/JRE

The Atlassian JIRA Linux installer will automatically configure a bundled JRE. If you wish to use your own JDK/JRE, with say the `java` cookbook, then as of this writing it must be Oracle and version 1.6 ([Supported Platforms](https://confluence.atlassian.com/display/JIRA/Supported+Platforms))

Necessary configuration with `java` cookbook:
* `node['java']['install_flavor'] = "oracle"`
* `node['java']['oracle']['accept_oracle_download_terms'] = true`
* `recipe[java]`

A /ht to @seekely for the [documentation nudge](https://github.com/bflad/chef-jira/issues/2).

## Attributes

* `node['jira']['version']` - Jira version to install (use
  `recipe[jira::upgrade]` to upgrade to version defined)
* `node['jira']['url']` - URL for Jira installer .bin
* `node['jira']['checksum']` - SHA256 checksum for Jira installer .tar.gz
* `node['jira']['backup_home']` - backup home directory during upgrade,
  defaults to true
* `node['jira']['backup_install']` - backup install directory during upgrade,
  defaults to true
* `node['jira']['install_backup']` - location of install directory backup
  during upgrade
* `node['jira']['install_path']` - location to install Jira, defaults to
  `/opt/atlassian/jira`
* `node['jira']['home_backup']` - location of home directory backup during
  upgrade
* `node['jira']['home_path']` - home directory for Jira data, defaults to
  `/var/atlassian/application-data/jira`

### Jira JVM Attributes

* `node['jira']['jvm']['minimum_memory']` - defaults to "256m"
* `node['jira']['jvm']['maximum_memory']` - defaults to "768m"
* `node['jira']['jvm']['maximum_permgen']` - defaults to "256m"
* `node['jira']['jvm']['java_opts']` - additional JAVA_OPTS to be passed to
  Jira JVM during startup
* `node['jira']['jvm']['support_args']` - additional JAVA_OPTS recommended by
  Atlassian support for Jira JVM during startup

### Jira Tomcat Attributes

* `node['jira']['tomcat']['port']` - port to run Tomcat HTTP, defaults to
  8080
* `node['jira']['tomcat']['ssl_port']` - port to run Tomcat HTTPS, defaults
  to 8443

## Recipes

* `recipe[jira]` Installs Atlassian Jira with built-in Tomcat
* `recipe[jira::apache2]` Installs above with Apache 2 proxy (ports 80/443)
* `recipe[jira::upgrade]` Upgrades Atlassian Jira

## Usage

### Required Stash Data Bag

Create a jira/jira encrypted data bag with the following information per
Chef environment (_default if you're not using environments):

_required:_
* `['database']['type']` - "mysql" or "postgresql"
* `['database']['host']` - FQDN or "localhost" (localhost automatically
  installs `['database']['type']` server)
* `['database']['name']` - Name of Jira database
* `['database']['user']` - Jira database username
* `['database']['password']` - Jira database username password

_optional:_
* `['database']['port']` - Database port, defaults to standard database port for
  `['database']['type']`
* `['tomcat']['keyAlias']` - Tomcat HTTPS Java Keystore keyAlias, defaults to
  self-signed certifcate
* `['tomcat']['keystoreFile']` - Tomcat HTTPS Java Keystore keystoreFile,
  defaults to self-signed certificate
* `['tomcat']['keystorePass']` - Tomcat HTTPS Java Keystore keystorePass,
  defaults to self-signed certificate

Repeat for other Chef environments as necessary. Example:

    {
      "id": "jira"
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

### Jira Installation

* Create required encrypted data bag
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add `recipe[jira]` to your node's run list.

### Jira Installation with Apache 2 Frontend

* Create required encrypted data bag
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add `recipe[jira::apache]` to your node's run list.

### Jira Upgrades

* Update `node['jira']['version']` and `node['jira']['checksum']` attributes
* Add `recipe[jira::upgrade]` to your run_list, such as:
  `knife node run_list add NODE_NAME "recipe[jira::upgrade]"`
  It will automatically remove itself from the run_list after completion.

## Contributing

Please use standard Github issues/pull requests.

## License and Author
      
Author:: Brian Flad (<bflad@wharton.upenn.edu>)

Copyright:: 2012

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
