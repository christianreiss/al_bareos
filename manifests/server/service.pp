class al_bareos::server::service (){

  #
  # Ensure Bareos is running.
  #
  service { $::al_bareos::server::service_sd:
    ensure  => running,
    enable  => true,
    require => Class['al_bareos::server::config'],
  }

  service { $::al_bareos::server::service_dir:
    ensure  => running,
    enable  => true,
    require => Class['al_bareos::server::config'],
  }

}
