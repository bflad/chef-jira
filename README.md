# template-cookbook

## Description

A cool description – preferably wrapped at 80 characters.

## Requirements

### Platforms

* RedHat 6.3 (Santiago)
* Ubuntu 11.10 (Oneiric)
* Ubuntu 12.04 (Precise)

### Cookbooks

* apache2
* logrotate

## Attributes

* `node["template_cookbook"]["version"]` - Version of template-cookbook to
  install.
* `node["template_cookbook"]["user"]` - User for template-cookbook.
* `node["template_cookbook"]["group"]` - Group for template-cookbook.

## Recipes

* `recipe[template-cookbook]` will install template-cookbook.
* `recipe[template-cookbook::alternate]` will install alternate
  template-cookbook.

## Usage

A short write-up of any usage specific instructions.  For example, default
passwords, examples of attributes that alter recipe behavior, and
auto-discovery of dependant services.
