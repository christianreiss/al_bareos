class al_bareos::server::params {

  #
  # Common Stuff
  #
  $service_sd  = 'bareos-sd'
  $service_dir = 'bareos-dir'
  $package     = [ 'bareos-director', 'bareos-storage', 'bareos-tools', 'bareos-database-mysql', 'bareos-webui', 'mod_ssl' ]

}
