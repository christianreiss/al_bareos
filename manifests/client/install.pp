class al_bareos::client::install (){

  #
  # Install main package.
  #
  if ( $::al_bareos::client::enable ) {

    if ( $::operatingsystem == 'Debian') {
      package { $::al_bareos::client::package:
        ensure          => installed,
        require         => Class['al_bareos::client::repo'],
        install_options => '--force-yes',
      }
    } else {
      package { $::al_bareos::client::package:
        ensure  => installed,
        require => Class['al_bareos::client::repo'],
      }
    }
  }

}
