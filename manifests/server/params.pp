class al_bareos::server::params {

  #
  # Common Stuff
  #
  $service_sd  = 'bareos-sd'
  $service_dir = 'bareos-dir'
  $package     = [ 'bareos-director', 'bareos-storage', 'bareos-tools', 'bareos-database-mysql', 'bareos-webui', 'mod_ssl', 'php-mysql' ]

  case ($::operatingsystem) {
    'Debian': {
      $send_nsca_config  = '/etc/send_nsca.cfg'
    }

    'Fedora': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg'
    }

   'CloudLinux': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg'
    }

    'RedHat': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg'
    }

    'CentOS': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg'
    }

    'XenServer': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg'
    }

    default: {
      fail("Unknown operatingsystem ${::operatingsystem} in icinga::client::params.")
    }
  }

}
