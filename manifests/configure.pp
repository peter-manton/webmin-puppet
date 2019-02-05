# @summary
#   This class handles webmin configuration.
#
# @api private
#
class webmin::configure {

    # Define webmin service
    service { 'webmin':
    ensure  => 'running',
    enable  => true,
    require => Package['webmin'],
    }    

    ### Group Configuration ###
    if $webmin::managed_config {
        # Create webmin group database
        if $webmin::webmin_groups {
            file { "${webmin::group_config_path}":
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0660',
            content  => '# Warning: This file is managed by Puppet - do not manually edit this file!',
            }

            # Iterate through groups
            $webmin::webmin_groups.each |String $wgroup| {
                $group = split($wgroup, ':')[0]
                $roles = split($wgroup, ':')[1]

                # Create webmin user group
                file_line { "Adding group ${wgroup} to ${webmin::group_config_path}":
                path => "${webmin::group_config_path}",
                line => "$group::$roles:$group:",
                } 
            }
        }

    }
    else {
            if $webmin::webmin_groups {
                # Iterate through groups
                $webmin::webmin_groups.each |String $wgroup| {
                    $group = split($wgroup, ':')[0]
                    $roles = split($wgroup, ':')[1]

                    # Create webmin user group
                    file_line { "Append line ${wgroup} to ${webmin::group_config_path}":
                    path => "${webmin::group_config_path}",
                    line => "$group::$roles:$group:",
                    match   => "^$group.*$",
                    }
                }
            }        
    }

    ### User Configuration ###
    if $webmin::managed_config {
        if $webmin::webmin_users {

            # Create blank users database
            file { "${webmin::user_config_path}":
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0660',
            content  => '# Warning: This file is managed by Puppet - do not manually edit this file!',
            }

            # Create blank acl database
            file { "${webmin::acl_config_path}":
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0660',
            content  => '# Warning: This file is managed by Puppet - do not manually edit this file!',
            }

            # Iterate through users
            $webmin::webmin_users.each |String $wusers| {
                $user = split($wusers, ':')[0]
                $group = split($wusers, ':')[1]
                $roles = split(join(grep($webmin::webmin_groups, $group), ':'), ':')[1]

                # Create webmin user
                file_line { "Adding user ${wusers} to ${webmin::user_config_path}":
                path => "${webmin::user_config_path}",
                line => "${user}:x::::::::::::",
                }

                # Add webmin user to appropriate group
                exec { "Adding user ${wusers} to ${webmin::group_config_path}" :
                command => "/usr/bin/sed -i -e 's/\\(^$group:\\)/\\1$user /' $webmin::group_config_path",
                unless  => "/usr/bin/grep '$group' $webmin::group_config_path | grep -c '$user'",
                }

                # Configure ACL for user
                file_line { "Adding user acl for ${wusers} to ${webmin::acl_config_path}":
                path => "${webmin::acl_config_path}",
                line => "${user}: ${roles}",
                match   => "^$user.*$",
                notify => Service['webmin'],
                }

            }
        }

    }
    else {
            if $webmin::webmin_users {
                # Iterate through users 
                $webmin::webmin_users.each |String $wusers| {
                    $user = split($wusers, ':')[0]
                    $group = split($wusers, ':')[1]
                    $roles = split(join(grep($webmin::webmin_groups, $group), ':'), ':')[1]

                    # Create webmin user 
                    file_line { "Adding user ${wusers} to ${webmin::user_config_path}":
                    path => "${webmin::user_config_path}",
                    line => "${user}:x::::::::::::",
                    match   => "^$user.*$",
                    }

                    # Add webmin user to appropriate group
                    exec { "Adding user ${wusers} to ${webmin::group_config_path}" :
                    command => "/usr/bin/sed -i -e 's/\\(^$group:\\)/\\1$user /' $webmin::group_config_path",
                    unless  => "/usr/bin/grep '$group' $webmin::group_config_path | grep -c '$user'",
                    }

                    # Configure ACL for user
                    file_line { "Adding user acl for ${wusers} to ${webmin::acl_config_path}":
                    path => "${webmin::acl_config_path}",
                    line => "${user}: ${roles}",
                    match   => "^$user.*$",
                    notify => Service['webmin'],
                    }
                }
            }
    }

    if $webmin::certificate {
        # TLS Certificate Configuration
        file { "$webmin::certificate_path":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0660',
        source  => "$webmin::certificate",
        notify => Service['webmin'],
        }
    }

    if $webmin::portnum {
        # Configure port number
        file_line { "Assigning port ${webmin::portnum} to ${webmin::user_config_path}":
        path => "${webmin::main_config_path}",
        line => "port=$webmin::portnum",
        match   => "^port=",
        notify => Service['webmin'],
        }

        # Configure listen number
        file_line { "Assigning listen ${webmin::portnum} to ${webmin::user_config_path}":
        path => "${webmin::main_config_path}",
        line => "listen=$webmin::portnum",
        match   => "^listen=",
        notify => Service['webmin'],
        }
    }
}
