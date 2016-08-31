class al_bareos::client::service (){

  #
  # Ensure Bareos is running.
  #
  if ( $::al_bareos::client::enable ) {
    service { 'bareos-fd':
      ensure  => running,
      enable  => true,
      require => Class['al_bareos::client::config'],
    }
  } else {
    service { 'bareos-fd':
      ensure  => stopped,
      enable  => false,
      require => Class['al_bareos::client::config'],
    }
  }

}
