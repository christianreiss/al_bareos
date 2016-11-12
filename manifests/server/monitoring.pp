class al_bareos::server::monitoring {

  if ($::icinga::client::enable) {

    #
    # Defaults.
    #
    Nagios_service {
      ensure                => present,
      register              => '1',
      host_name             => $::fqdn,
      max_check_attempts    => '5',
      check_period          => '24x7',
      contact_groups        => $::icinga::client::contactgroup,
      notification_interval => '0',
      notification_options  => 'c,r',
      notification_period   => '24x7',
      notifications_enabled => $::icinga::client::checks::notifications,
    }

    #
    # Server side monitoring
    #
    @@nagios_service { "${::fqdn}-proc-bareos-sd":
      check_command       => 'check_nrpe!check_proc_bareossd',
      display_name        => 'bareos: storage daemon',
      service_description => 'bareos: storage daemon',
    }

    @@nagios_service { "${::fqdn}-proc-bareos-dir":
      check_command       => 'check_nrpe!check_proc_bareosdir',
      display_name        => 'bareos: director',
      service_description => 'bareos: director',
    }
  }
}
