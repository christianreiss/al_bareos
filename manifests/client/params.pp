class al_bareos::client::params {

  #
  # Common Stuff
  #
  $service_fd = 'bareos-fd'

  case ($::operatingsystem) {

    'Debian': {
      $package    = [ 'bareos-filedaemon', 'bareos-bconsole' ]
    }

    'Fedora': {
      $package    = [ 'bareos-fd', 'bareos-bconsole' ]
    }

    'CloudLinux': {
      $package    = [ 'bareos-fd', 'bareos-bconsole' ]
    }

    'CentOS': {
      $package    = [ 'bareos-fd', 'bareos-bconsole' ]
    }

    'XenServer': {
      $package    = [ 'bareos-fd', 'bareos-bconsole' ]
    }

    default: {
      fail ("Operatingsystem ${::operatingsystem} not known to al_bareos::client::params.")
    }

  }

}
