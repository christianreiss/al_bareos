class al_bareos::client::monitoring {

  if ($::icinga::client::enable) {
    if ($::al_bareos::client::enable) {
      if ($::al_bareos::client::monitoring) {

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
        # Client bareos last Backup Monitoring
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

        #
        # Restore-Directory Monitoring.
        #
        @@nagios_service { "${::fqdn}-bareos-restore-dir":
          check_command          => 'bareos-fail',
          display_name           => 'bareos: restore-dir',
          service_description    => 'bareos: restore-dir',
          initial_state          => 'o',
          max_check_attempts     => '1',
          check_interval         => '1',
          retry_interval         => '1',
          active_checks_enabled  => '0',
          check_freshness        => '1',
          freshness_threshold    => '112320',
          flap_detection_enabled => '0',
        }


        #
        # Full Backup monitoring
        #
        @@nagios_service { "${::fqdn}-bareos-full":
          check_command          => 'bareos-fail',
          display_name           => 'bareos: full backup',
          service_description    => 'bareos: full backup',
          initial_state          => 'o',
          max_check_attempts     => '1',
          check_interval         => '1',
          retry_interval         => '1',
          active_checks_enabled  => '0',
          check_freshness        => '1',
          freshness_threshold    => '112320',
          flap_detection_enabled => '0',
        }


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
}
