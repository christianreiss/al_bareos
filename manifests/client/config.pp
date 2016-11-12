class al_bareos::client::config (){

  if ( $::al_bareos::client::enable ) {

    # Email
    $contact = hiera('contact', 'unset')

    #
    # Local Configuration (created on client.)
    #
    file { '/etc/bareos':
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
      mode    => '0750',
      require => Class['al_bareos::client::install'],
    }

    if ($::al_bareos::client::monitoring) {
      file { '/etc/bareos/check_bareosRestoreDir.sh':
        ensure  => file,
        mode    => '0750',
        owner   => 'root',
        group   => 'root',
        require => Class['al_bareos::client::install'],
        content => template('al_bareos/client/check_bareosRestoreDir.sh.erb'),
      }

      cron { 'bareos-restore-dir-check':
        command => '/etc/bareos/check_bareosRestoreDir.sh >/dev/null',
        user    => 'root',
        hour    => '*/3',
        minute  => fqdn_rand(60,'bareos-restore-dir-check'),
        require => File['/etc/bareos/check_bareosRestoreDir.sh'],
      }
    } else {
      file { '/etc/bareos/check_bareosRestoreDir.sh':
        ensure  => absent,
      }

      cron { 'bareos-restore-dir-check':
        ensure => absent,
      }
    }

    # bareos filedaemon
    file { '/etc/bareos/bareos-fd.conf':
      ensure  => file,
      content => template ('al_bareos/client/bareos-fd.conf.erb'),
      owner   => 'root',
      mode    => '0440',
      require => Class['al_bareos::client::install'],
      notify  => Class['al_bareos::client::service'],
    }

    # Console Definition
    if ($::fqdn == $::al_bareos::client::director){
      # Full root console
      file { '/etc/bareos/bconsole.conf':
        ensure  => file,
        owner   => bareos,
        group   => bareos,
        mode    => '0440',
        content => template ('al_bareos/client/bconsole-full.conf.erb'),
      }
    } else {
      # Limited Console
      file { '/etc/bareos/bconsole.conf':
        ensure  => file,
        owner   => bareos,
        group   => bareos,
        mode    => '0440',
        content => template ('al_bareos/client/bconsole-limited.conf.erb'),
      }
    }
  } else {
    file { '/etc/bareos':
      ensure  => absent,
      purge   => true,
      recurse => true,
      force   => true,
    }

  }

  #
  # Logic
  #

  # Schedule
  # This is an array with all days of a month.
  $days     = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31']
  $hours    = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23']

  # We select a random day (1-26) for the full, and strike that day from the incremental list.
  $incrdays = delete_at($days,  ($::al_bareos::client::sched_day  - 1))
  $inchours = delete_at($hours, ($::al_bareos::client::sched_hour - 1))


  # Includes and Excludes
  $exclude = $al_bareos::client::exclude
  $include = $al_bareos::client::include

  # Minute Padding
  if ( $::al_bareos::client::sched_min < 10 ) {
    $sched_min_pad ="0${::al_bareos::client::sched_min}"
  } else {
    $sched_min_pad = $::al_bareos::client::sched_min
  }


  #
  # Remove Configuration (exported to server.)
  #

  if ( $::al_bareos::client::enable ) {
    # Schedule
    @@file { "/etc/bareos/schedules.d/${::fqdn}.conf":
      ensure  => file,
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-schedule',
      content => template ('al_bareos/client/schedule.conf.erb'),
    }

    # Device Definition
    @@file { "/etc/bareos/devices.d/${::fqdn}.conf":
      ensure  => file,
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-devices',
      content => template ('al_bareos/client/device.conf.erb'),
    }

    # Console definition
    @@file { "/etc/bareos/consoles.d/${::fqdn}.conf":
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-consoles',
      content => template ('al_bareos/client/bconsole-exported.conf.erb'),
    }

    # FileSet Definiton
    @@file { "/etc/bareos/filesets.d/${::fqdn}.conf":
      ensure  => file,
      mode    => '0440',
      owner   => bareos,
      group   => bareos,
      tag     => 'bareos-filesets',
      content => template ('al_bareos/client/fileset.conf.erb'),
      require => Class['al_bareos::client::install'],
      notify  => Class['al_bareos::client::service'],
    }

    # Job Definition
    @@file { "/etc/bareos/jobs.d/${::fqdn}.conf":
      ensure  => file,
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-jobs',
      content => template ('al_bareos/client/job.conf.erb'),
    }

    # Storage Definition
    @@file { "/etc/bareos/storage.d/${::fqdn}.conf":
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-storages',
      content => template ('al_bareos/client/storage.conf.erb'),
    }

    # Pool Definition
    @@file { "/etc/bareos/pools.d/${::fqdn}.conf":
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-pools',
      content => template ('al_bareos/client/pool.conf.erb'),
    }

    # Client Definition
    @@file { "/etc/bareos/clients.d/${::fqdn}.conf":
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-clients',
      content => template ('al_bareos/client/client.conf.erb'),
    }

    # Messages Definition
    @@file { "/etc/bareos/messages.d/${::fqdn}.conf":
      owner   => bareos,
      group   => bareos,
      mode    => '0440',
      tag     => 'bareos-messages',
      content => template ('al_bareos/client/messages.conf.erb'),
    }
  }

}
