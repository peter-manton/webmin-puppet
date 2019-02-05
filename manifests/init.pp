# Class: webmin
# ===========================
#
# This class provides basic configuration of webmin.
#
# Parameters
# ----------
#
# * `install`
# Determines whether or not webmin will be installed by this package or not.
# * `webmin_package_name`
# Defines the package name which is requested from the package manager.
# * `main_config_path`
# Defines the file path of the main webmin configuration file.
# * `acl_config_path`
# Defines the file path of the webmin group configuration file.
# * `user_config_path`
# Defines the file path of the webmin ACL configuration file.
# * `group_config_path`
# Defines the file path of the webmin user configuration file.
# * `portnum`
# Defines the bind port for webmin.
# * `managed_config`
# Determines whether webmin will soley manage the configuration (recommended = true.)
# * `certificate_path`
# Defines the file path of the webmin certificate.
# * `certificate`
# Defines where the certificate for Puppet is stored (this should point at a Puppet mount point.)
# * `webmin_groups`
# Defines the groups and thier assigned roles e.g. <group_name>: <role1> <role2> <role3> ...
# * `webmin_users`
# Defines the users and their assigned group. (Note: Currently only OS level users are supported.)
#
# Variables
# ----------
#
# As above. 
#
# Examples
# --------
#
# @example
#    class { 'webmin':
#      install => true,
#      portnum => 80,
#      certificate => 'puppet:///certs/certificate.pem',
#      webmin_groups =>  [ 'group1:ppp-client pptp-client pptp-server stunnel', 'group2:exim fetchmail jabber', ],
#      webmin_users => [ 'user1:group1', 'user2:group2' ],
#    }
#
# Authors
# -------
#
# Peter Manton <peter@manton.im>
#
# Copyright
# ---------
#
# Copyright 2019 Peter Manton, unless otherwise noted.
#
class webmin (
  Boolean $install,
  String $webmin_package_name,
  Optional[Stdlib::Absolutepath] $main_config_path,
  Optional[Stdlib::Absolutepath] $acl_config_path,
  Optional[Stdlib::Absolutepath] $user_config_path,
  Optional[Stdlib::Absolutepath] $group_config_path,
  Optional[Boolean] $managed_config,
  Optional[Integer[0, 65535]] $portnum,
  Optional[Stdlib::Absolutepath] $certificate_path,
  Optional[String] $certificate,
  Optional[Array[String]] $webmin_groups,
  Optional[Array[String]] $webmin_users,
  )
  {
  notify { 'Applying Webmin configuration...': }
  
  contain webmin::install
  contain webmin::configure

  Class['::webmin::install']
  -> Class['::webmin::configure']
}
