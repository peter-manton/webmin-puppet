# webmin

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Reference](#reference)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This module allows you to install and configure Webmin. Works / tested on Puppet 5 and above.

## Setup

Simply declare the class - see below for customizing the behaviour.

## Usage

The following example installs webmin and performs basic configuration:

```
class { 'webmin':
  install => true,
  portnum => 80,
  certificate => 'puppet:///certs/certificate.pem',
  webmin_groups =>  [ 'group1:ppp-client pptp-client pptp-server stunnel', 'group2:exim fetchmail jabber', ],
  webmin_users => [ 'user1:group1', 'user2:group2' ],
}
```

or in Hiera:

```
webmin::install: true
webmin::portnum: 8080
webmin::managed_config: true
webmin::certificate: puppet:///certs/certificate.pem
webmin::webmin_groups:
    - 'group1:shell custom filemin tunnel file phpini cpan'
    - 'group2:dovecot exim fetchmail jabber ldap-server mysql openslp postfix postgresql'
webmin::webmin_users:
    - 'user1:group1'
    - 'user2:group1'
    - 'user3:group2'
```

## Reference

#### Classes
```
::webmin:install This class handles the installation of Puppet via the appropriate package manager.
::webmin:configure This class handles the configuration of Webmin.
```

#### Variables
```
webmin::install Determines whether or not webmin will be installed by this package or not.
webmin::webmin_package_name Defines the package name which is requested from the package manager.
webmin::main_config_path Defines the file path of the main webmin configuration file.
webmin::acl_config_path Defines the file path of the webmin group configuration file.
webmin::user_config_path Defines the file path of the webmin ACL configuration file.
webmin::group_config_path Defines the file path of the webmin user configuration file.
webmin::portnum Defines the bind port for webmin.
webmin::managed_config Determines whether webmin will soley manage the configuration (recommended = true.)
webmin::certificate_path Defines the file path of the webmin certificate.
webmin::certificate Defines where the certificate for Puppet is stored (this should point at a Puppet mount point.)
webmin::webmin_groups Defines the groups and thier assigned roles e.g. <group_name>: <role1> <role2> <role3> ...
webmin::webmin_users Defines the users and their assigned group. (Note: Currently only OS level users are supported.)
```

## Limitations

Compatible with RHEL7/Centos 7 and Debian 9.7 (stretch) and most derivatives (including Ubunutu.)

## Development

Planned future support for OpenSUSE and ArchLinux.
