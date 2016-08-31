class al_bareos::server::install (){

  #
  # Install main package.
  #
  if ( $::operatingsystem == 'Debian') {
    package { $::al_bareos::server::package:
      ensure          => installed,
      require         => Class['al_bareos::client::repo'],
      install_options => '--force-yes',
    }
  } else {
    package { $::al_bareos::server::package:
      ensure  => installed,
      require => Class['al_bareos::client::repo'],
    }
  }

}
