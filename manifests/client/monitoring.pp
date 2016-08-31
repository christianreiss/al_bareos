class al_bareos::client::monitoring {

  if (($::al_bareos::client::monitoring) and (al_bareos::client::enable)) {

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
      process_perf_data     => '0',
      notifications_enabled => $::icinga::client::checks::notifications,
    }

    #
    # Client bareos Monitoring
    #
    @@nagios_service { "${::fqdn}-bareos":
      check_command          => 'bareos-fail',
      display_name           => 'bareos: backup',
      service_description    => 'bareos: backup',
      initial_state          => 'o',
      max_check_attempts     => '1',
      check_interval         => '1',
      retry_interval         => '1',
      active_checks_enabled  => '0',
      notification_options   => 'w,c',
      check_freshness        => '1',
      freshness_threshold    => '9000',
      flap_detection_enabled => true,
    }

    #
    # Port Monitoring
    #
    #@@nagios_service { "${::fqdn}-bareos-connect-dir":
    #   check_command       => 'check_nrpe!check_tcp!',
    #   display_name        => 'bareos: file daemon',
    #   service_description => 'bareos: file daemon',
    #}

    #
    # Client bareos-fd monitoring
    #
    @@nagios_service { "${::fqdn}-proc-bareos-fd":
      check_command       => 'check_nrpe!check_proc_bareosfd',
      display_name        => 'bareos: file daemon',
      service_description => 'bareos: file daemon',
    }
  }
}
