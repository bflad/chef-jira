# chef-jira [![Build Status](https://secure.travis-ci.org/bflad/chef-jira.png?branch=master)](http://travis-ci.org/bflad/chef-jira)

## Description

Installs/Configures Atlassian JIRA. Please see [COMPATIBILITY.md](COMPATIBILITY.md) for more information about JIRA releases that are tested and supported by this cookbook and its versions.

## Requirements

### Chef

* Chef 11+ for version 2.0.0+ of this cookbook

### Platforms

* CentOS 6
* RHEL 6
* Ubuntu 12.04

### Databases

* Microsoft SQL Server
* MySQL
* Postgres

### Cookbooks

Required [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2) (if using apache2 recipe)
* [ark](https://github.com/opscode-cookbooks/ark)
* [database](https://github.com/opscode-cookbooks/database) (if using database recipe)
* [mysql](https://github.com/opscode-cookbooks/mysql) (if using database recipe with MySQL)
* [postgresql](https://github.com/opscode-cookbooks/postgresql) (if using database recipe with Postgres)

Required Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)

Suggested [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [java](https://github.com/opscode-cookbooks/java)
* [tomcat](https://github.com/opscode-cookbooks/tomcat)

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
checksum | SHA256 checksum for JIRA install | String | auto-detected (see attributes/default.rb)
context | URI context of installation (mainly for WAR installation) | String | auto-detected (see attributes/default.rb)
context_path | Location of container server context configurations (for WAR installation) | String | auto-detected (see attributes/default.rb)
home_path | home directory for JIRA | String | /var/atlassian/application-data/jira
install_path | location to install JIRA | String | /opt/atlassian/jira
install_type | JIRA install type - "installer", "standalone", "war" | String | installer
init_type | JIRA init service type - "sysv" | String | sysv
lib_path | location of container server libraries | String | auto-detected (see attributes/default.rb)
url_base | URL base for JIRA install | String | http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira
url | URL for JIRA install | String | auto-detected (see attributes/default.rb)
user | user running JIRA (jira for installer/standalone, container server user for WAR installation) | String | auto-detected (see attributes/default.rb)
version | JIRA version to install | String | 6.1.5

### JIRA Build Attributes

These attributes are under the `node['jira']['build']` namespace and used to control the JIRA WAR build process.

Attribute | Description | Type | Default
----------|-------------|------|--------
targets | Ant targets for build process | String | war
enable | Set to false to disable builds | Boolean | true
exclude_jars | JARs to exclude from WAR | Array of Strings | `%w{jcl-over-slf4j jul-to-slf4j log4j slf4j-api slf4j-log4j12}`
file | Output file from build | String | `#{node['jira']['install_path']}/dist-#{node['jira']['container_server']['name']}/atlassian-jira-#{node['jira']['version']}.war`

### JIRA Container Server Attributes

These attributes are under the `node['jira']['container_server']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
name | Container server running JIRA to configure | String | tomcat
version | Version of container server | String | 6

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

### JIRA JARs Attributes

These attributes are under the `node['jira']['jars']` namespace and are for downloading/deploying JIRA JARs in WAR installations.

Attribute | Description | Type | Default
----------|-------------|------|--------
deploy_jars | Which JIRA JARs to deploy to container server | Array of Strings | `%w{carol carol-properties hsqldb jcl-over-slf4j jonas_timer jotm jotm-iiops_stubs jotm-jmrp_stubs jta jul-to-slf4j log4j objectweb-datasource ots-jts slf4j-api slf4j-log4j12 xapool}`
install_path | Location to install JIRA JARs | String | `node['jira']['install_path'] + '-jars'`
url_base | Base URL to download JIRA JARs | String | http://www.atlassian.com/software/jira/downloads/binary/jira-jars
url | URL to download JIRA JARs | String | `#{node['jira']['jars']['url_base']}-#{node['jira']['container_server']['name']}-distribution-#{node['jira']['jars']['version']}-#{node['jira']['container_server']['name']}-#{node['jira']['container_server']['version']}x.zip`
version | Version of JIRA JARs to download/deploy | String | `node['jira']['version'].split('.')[0..1].join('.')`

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

Any `node['jira']['tomcat']['key*']` attributes are overridden by `jira/jira` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
keyAlias | Tomcat SSL keystore alias | String | tomcat
keystoreFile | Tomcat SSL keystore file - will automatically generate self-signed keystore file if left as default | String | `#{node['jira']['home_path']}/.keystore`
keystorePass | Tomcat SSL keystore passphrase | String | changeit
port | Tomcat HTTP port | Fixnum | 8080
ssl_port | Tomcat HTTPS port | Fixnum | 8443

### JIRA WAR Attributes

These attributes are under the `node['jira']['war']` namespace and used to control the JIRA WAR deploy process.

Attribute | Description | Type | Default
----------|-------------|------|--------
file | Location of JIRA WAR file for deployment | String | `node['jira']['build']['file']`

## LWRPs

* jira_jars: JIRA JARs download/deploy
* jira_war: JIRA WAR download/build

### Getting Started

Here's a quick example of downloading and building JIRA WAR:

```ruby
# Download and build JIRA WAR
jira_war node['jira']['install_path'] do
  action :build
end
```

See full documentation for each LWRP and action below for more information.

### jira_jars

Below are the available actions for the LWRP, default being `download`.

#### deploy

These attributes are associated with this LWRP action.

Attribute | Description | Type | Default
----------|-------------|------|--------
deploy_jars | Which JARs to deploy | Array | `node['jira']['jars']['deploy_jars']`
lib_path | Location of container server libraries | String | `node['jira']['lib_path']`

Deploy custom list of JIRA JARs to custom location:

```ruby
jira_jars '/opt/atlassian/jira-jars' do
  deploy_jars %w{carol carol-properties hsqldb jonas_timer jotm jotm-iiops_stubs jotm-jmrp_stubs jta objectweb-datasource ots-jts xapool}
  lib_path '/usr/local/my-special-snowflake-tomcat/lib/'
  action :deploy
end
```

#### download

These attributes are associated with this LWRP action.

Attribute | Description | Type | Default
----------|-------------|------|--------
url | URL to download JIRA JARs | String | `node['jira']['jars']['url']`
version | Version of JIRA JARS to download | String | `node['jira']['jars']['version']`

Download custom version of JIRA JARs:

```ruby
jira_jars '/opt/atlassian/jira-jars' do
  version '6.0'
end
```

### jira_war

Below are the available actions for the LWRP, default being `download`.

#### build

These attributes are associated with this LWRP action.

Attribute | Description | Type | Default
----------|-------------|------|--------
exclude_jars | JARs to exclude from built WAR | Array | `node['jira']['build']['exclude_jars']`
file | Location of build output file | String | `node['jira']['build']['file']`
targets | Ant targets for build | String | `node['jira']['build']['targets']`

Run custom ant targets for JIRA WAR build:

```ruby
jira_war '/opt/atlassian/jira' do
  targets 'generic'
  action :build
end
```

#### download

These attributes are associated with this LWRP action.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | Checksum of JIRA WAR download | String | `node['jira']['checksum']`
url | URL to download JIRA WAR | String | `node['jira']['url']`
version | Version of JIRA WAR to download | String | `node['jira']['version']`

Download custom version of JIRA WAR:

```ruby
jira_war '/opt/atlassian/jira' do
  version '6.1.4'
end
```

## Recipes

* `recipe['jira']` 'Installs/configures Atlassian JIRA'
* `recipe['jira::apache2']` 'Installs/configures Apache 2 as proxy (ports 80/443)'
* `recipe['jira::build_war']` 'Builds JIRA WAR'
* `recipe['jira::container_server_configuration']` 'Configures container server for JIRA deployment'
* `recipe['jira::container_server_jars']` 'Deploys database/JIRA jars to container server'
* `recipe['jira::database']` 'Installs/configures MySQL/Postgres server, database, and user for JIRA'
* `recipe['jira::installer']` 'Installs/configures JIRA via installer'
* `recipe['jira::standalone']` 'Installs/configures JIRA via standalone archive'
* `recipe['jira::sysv']` 'Installs/configures JIRA SysV init service'
* `recipe['jira::war']` 'Installs JIRA WAR'

## Usage

### JIRA Server Data Bag

Optionally for securely overriding attributes on Hosted Chef, create a `jira/jira` encrypted data bag with the model below. Chef Solo can override the same attributes with a `jira/jira` unencrypted data bag of the same information.

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

### Default JIRA Installation

The simplest method is via the default recipe, which uses `node['jira']['install_type']` (defaults to installer).

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add `recipe[jira]` to your node's run list.

### Standalone JIRA Installation

Operates similarly to installer installation, however has added benefits of using `ark` to create version symlinks of each install. Easily can rollback upgrades by changing `node['jira']['version']`.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Set `node['jira']['install_type']` to standalone 
* Add `recipe[jira]` to your node's run list.

### JIRA WAR Support

There are three phases of JIRA WAR support:
* Downloading JIRA WAR archive
* Building JIRA WAR
* Deploying JIRA WAR with necessary JAR dependencies and container server configuration

Each of the phases can be handled separately as outlined below if you need to customize the WAR or deploy it to different nodes than where its being built. By default, cookbook will handle all three phases with `node['jira']['install_type']` set to war.

#### Downloading JIRA WAR

Handled by war recipe using `ark` so it'll save versioned symlinks. Location customizable by `node['jira']['install_path']`. From here, the WAR is ready to be customized and built.

#### Building JIRA WAR

Handled by build_war recipe and can be disabled by setting `node['jira']['build']['enabled']` to false. Customize build targets via `node['jira']['build']['targets']`. Expects build output to write file to `node['jira']['build']['file']` otherwise will build every convergence. Note `node['jira']['build']['exclude_jars']` will by default delete JARs that are recommended to be installed in container server lib directory (`node['jira']['lib_dir']`) from separate JIRA JARs download.

While cookbook defaults to handling Tomcat build, you may be able to try and deploy the "generic" WAR. Set `node['jira']['container_server']['name']` to generic.

#### Deploying JIRA WAR

There are a couple pieces necessary for successful JIRA WAR deployment:
* WAR file built and ready (`node['jira']['war']['file']`, which defaults to `node['jira']['build']['file']`)
* Download and installation of JIRA JARs
* Download and installation of database JARs (such as MySQL Connector/J, etc.)
* Configuration of container server (such as Tomcat)

Atlassian supports deploying WAR only on Tomcat 6/7 and the cookbook handles this case (recommended usage with Opscode Tomcat cookbook), however if you're feeling adventurous, this process may be workable for other container servers with some slight configuration and a wrapper cookbook.

Cookbook handles the above steps with:
* WAR file: built via build_war recipe (using jira_war LWRP) or location up to you with a wrapper cookbook and `node['jira']['war']['file']` set appropriately
* JIRA JARs: container_server_jars recipe (using jira_jars LWRP) with configuration in `node['jira']['jars']` attributes and `node['jira']['install_type']` set to war
* Database JARs: container_server_jars recipe and appropriate database type needing additional JARs
* Configuration of container server: container_server_configuration recipe, which installs context to Tomcat if `node['jira']['container_server']['name']` is tomcat.

### Custom JIRA Configurations

Using individual recipes, you can use this cookbook to configure JIRA to fit your environment.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create jira`
  * `knife data bag edit jira jira --secret-file=path/to/secret`
* Add individual recipes to your node's run list.

## Testing and Development

* Quickly testing with Vagrant: [VAGRANT.md](VAGRANT.md)
* Full development and testing workflow with Test Kitchen and friends: [TESTING.md](TESTING.md)

For Vagrant, you may need to add the following hosts entries:

* 192.168.50.10 jira-centos-6
* 192.168.50.10 jira-ubuntu-1204
* (etc.)

The running JIRA server is then accessible from the host machine:

CentOS 6 Box:
* Web UI (installer/standalone): https://jira-centos-6/
* Web UI (Tomcat deployed war): http://jira-centos-6:8080/jira/

Ubuntu 12.04 Box:
* Web UI (installer/standalone): https://jira-ubuntu-1204/
* Web UI (Tomcat deployed war): http://jira-ubuntu-1204:8080/jira/

## Contributing

Please see contributing information in: [CONTRIBUTING.md](CONTRIBUTING.md)

## Maintainers

* Brian Flad (<bflad417@gmail.com>)

## License

Please see licensing information in: [LICENSE](LICENSE)
