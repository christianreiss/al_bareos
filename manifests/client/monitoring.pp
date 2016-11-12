class al_bareos::client::monitoring {

  if ($::icinga::client::enable) {
    if ($::al_bareos::client::enable) {

      #
      # Defaults.
      #
      Nagios_service {
        ensure                => present,
        check_period          => '24x7',
        contact_groups        => $::icinga::client::contactgroup,
        host_name             => $::fqdn,
        max_check_attempts    => '5',
        notification_interval => '0',
        notification_options  => 'c,r',
        notification_period   => '24x7',
        notifications_enabled => $::icinga::client::checks::notifications,
        process_perf_data     => '0',
        register              => '1',
      }

      #
      # Client bareos Monitoring
      #
      @@nagios_service { "${::fqdn}-bareos":
        active_checks_enabled  => '0',
        check_command          => 'bareos-fail',
        check_freshness        => '1',
        check_interval         => '1',
        display_name           => 'bareos: backup',
        flap_detection_enabled => true,
        freshness_threshold    => '9000',
        initial_state          => 'o',
        max_check_attempts     => '1',
        notifications_enabled  => '0',
        notification_options   => 'w,c',
        retry_interval         => '1',
        service_description    => 'bareos: backup',
      }

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
}
