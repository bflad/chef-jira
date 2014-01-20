## 2.0.1

* Bugfix: #8: Remove include_attribute from default attributes to prevent hard dependency on tomcat cookbook

## 2.0.0

If you were using the default recipe, there are no changes you need to make for your environment to upgrade this cookbook.

Major features are full support for standalone deployments and war building/deployments. Using ark where possible (its worked well for those using my Stash cookbook).

I've removed the upgrade recipe in favor of using ark. If you'd like to keep old JIRA installations around (in case of upgrade issues, etc.), I would recommend switching to the standalone install_type since ark will automatically create versioned symlinks and you can easily revert `node['jira']['version']`. To convert install_type if install_path is the default (X.Y.Z being currently installed `node['jira']['version']`):
* `service jira stop`
* `mv /opt/atlassian/jira /opt/atlassian/jira-X.Y.Z`
* `ln -s /opt/atlassian/jira-X.Y.Z /opt/atlassian/jira`
* Set `node['jira']['install_type']` to standalone
* Run Chef Client

Other than that, migrated some recipes/templates and split out some recipes from the old linux_installer recipe, so ensure that if you're using a custom run list or template override for any nodes, that they include the new recipes/template location as necessary.

Full details:
* REMOVED: upgrade recipe and associated backup_* and *_backup attributes
* MIGRATED: linux_installer -> installer recipe
* MIGRATED: tomcat_configuration -> container_server_configuration recipe
* MIGRATED: Tomcat templates into tomcat folder:
  * permgen.sh.erb -> tomcat/permgen.sh.erb
  * server.xml.erb -> tomcat/server.xml.erb
  * setenv.sh.erb -> tomcat/setenv.sh.erb
  * web.xml.erb -> tomcat/web.xml.erb
* SPLIT: SysV init service configuration into sysv recipe and add init_type attribute
* SPLIT: database jar deployment (mysql_connector_j, etc.) into container_server_jars recipe which also installs JIRA jars for war install_type
* Bugfix: Use :create action instead of :create_if_missing for installer remote_file
* Enhancement: Add standalone and war recipes and quite a few attributes for supporting those install_type's
* Enhancement: Add build_war recipe
* Enhancement: LWRPs for handling multiple instances of install, etc.
* Enhancement: Bump default JIRA version to 6.1.5

## 1.7.0

* Bump default JIRA version to 6.1

## 1.6.0

* Bump default JIRA version to 6.0.7

## 1.5.0

* Bump default JIRA version to 6.0.6

## 1.4.0

* Initial Microsoft SQL Server support

## 1.3.0

* Bump default JIRA version to 6.0.5

## 1.2.0

* Bump default JIRA version to 6.0.2

## 1.1.0

* Bump default JIRA version to 6.0.1

## 1.0.0

* Split default recipe into individual recipes
* apache2 recipe does not include default recipe
* Load database/tomcat settings via Jira.settings library (bonus: help support Chef Solo)
* Moved apache2 attributes into default attributes
* Bump default JIRA version to 5.2.11
* Added url_base attribute
* Auto-detect checksum attribute for some versions
* Added Vagrantfile and Test Kitchen for testing
* minitest fixes
* Added COMPATIBILITY.md
* Refactored README documentation

## 0.1.3

* Chef 11 fixes in apache2 recipe

## v0.1.2

* Hopefully removed hard dependency on java_ark from java cookbook

## v0.1.1

* Added permgen.sh template for custom JAVA_HOME, otherwise always defaults to
  JIRA installed JRE

## v0.1.0

* Initial release
