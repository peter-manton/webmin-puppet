# @summary
#   This class handles the webmin package.
#
# @api private
#
class webmin::install {

  if $webmin::install {
    include 'yum'    

    package { $webmin::webmin_package_name:
      ensure => present,
    }

    #service { $webmin::webmin_package_name:
    #ensure    => running,
    #enable    => true,
    #subscribe => Package[$webmin::webmin_package_name],
    #}

  }

}
