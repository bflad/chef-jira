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
