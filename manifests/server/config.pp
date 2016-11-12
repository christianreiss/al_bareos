class al_bareos::server::config (){

# Email
  $contact = hiera('contact', 'unset')

# bareos-Director.
  file { '/etc/bareos/bareos-dir.conf':
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0440',
    content => template ('al_bareos/server/bareos-dir.conf.erb'),
    require => Class['al_bareos::server::install'],
  }


#
# Placeholder for consoles.
#
  file { '/etc/bareos/consoles.d/EMPTY.conf':
    ensure  => file,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0440',
    require => [Class['al_bareos::server::install'],File['/etc/bareos/consoles.d']],
  }

# Bin-Dir (bareos)
  file { '/etc/bareos/bin':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    purge   => true,
    force   => true,
    recurse => true,
    require => [Class['al_bareos::server::install'],File['/etc/bareos']],
  }

# Cron for Bootstrap Cleanup
  cron { 'cleanup-bootstrap':
    ensure   => 'present',
    command  => "/bin/find ${::al_bareos::server::bootpath}/ -name \'*.bsr\' -ctime +90 -delete",
    user     => 'root',
    hour     => '20',
    minute   => '0',
    monthday => '14',
  }

# ZFS Dataset creat0r
  file { '/etc/bareos/bin/createDatasets.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template ('al_bareos/server/createDatasets.sh.erb'),
    require => Class['al_bareos::server::install'],
  }

# Monitoring-Shell-Skript
  file { '/etc/bareos/bin/notifyMonitoring.sh':
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    content => template ('al_bareos/server/notifyMonitoring.sh.erb'),
    require => Class['al_bareos::server::install'],
  }

# bareos-SD
  file { '/etc/bareos/bareos-sd.conf':
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0440',
    content => template ('al_bareos/server/bareos-sd.conf.erb'),
    require => Class['al_bareos::server::install'],
    notify  => Class['al_bareos::server::service'],
  }

# Storage Dir.
  file { $::al_bareos::server::storagepath:
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    require => Class['al_bareos::server::install'],
  }

# Bootstrap Dir.
  file { $::al_bareos::server::bootpath:
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    require => [Class['al_bareos::server::install'],File[$::al_bareos::server::storagepath]],
  }

# Client director Dir.
  file { '/etc/bareos/consoles.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Client config Dir.
  file { '/etc/bareos/clients.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
    notify  => Class['al_bareos::server::service'],
  }

# Messages Definitions
  file { '/etc/bareos/messages.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Log Directory
  file { $::al_bareos::server::logdir:
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    require => Class['al_bareos::server::install'],
  }

# Pool Definitions
  file { '/etc/bareos/pools.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Job Definitions
  file { '/etc/bareos/jobs.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Device Definitions
  file { '/etc/bareos/devices.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Storage Definitions
  file { '/etc/bareos/storage.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# Client schedules
  file { '/etc/bareos/schedules.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

# FileSet Definitions
  file { '/etc/bareos/filesets.d':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Class['al_bareos::server::install'],
  }

#
# Rinux.net compatability
#
  file { '/etc/bareos/rinux.net':
    ensure  => directory,
    owner   => 'bareos',
    group   => 'bareos',
    purge   => true,
    force   => true,
    recurse => true,
    source  => 'puppet:///modules/al_bareos/rinux.net',
    require => [Class['al_bareos::server::install'],File['/etc/bareos']],
  }

#
# Create ZFS datasets
#
  exec { 'bareos-zfs':
    command     => '/etc/bareos/bin/createDatasets.sh',
    refreshonly => true,
    subscribe   => File['/etc/bareos/jobs.d/'],
    require     => File['/etc/bareos/bin/createDatasets.sh'],
  }


#
# Web-UI
#

# Web-UI Console Access
  file { "/etc/bareos/consoles.d/webui-${::fqdn}.conf":
    owner   => 'bareos',
    group   => 'bareos',
    content => template ('al_bareos/client/bconsole-webui.conf.erb'),
    mode    => '0440',
    require => Class['al_bareos::server::install'],
    notify  => Class['al_bareos::server::service'],
  }

  file { '/etc/httpd/conf.d/bareos-webui.conf':
    ensure => absent,
  }

  file { "/etc/httpd/conf.d/webui-${::al_bareos::server::webui_vhost}.conf":
    owner   => 'root',
    group   => 'root',
    content => template ('al_bareos/server/apache-webui.conf.erb'),
    mode    => '0444',
    require => Class['al_bareos::server::install'],
  }

  file { '/etc/bareos-webui/directors.ini':
    owner   => 'root',
    group   => 'root',
    content => template ('al_bareos/server/directors.ini.erb'),
    mode    => '0444',
    require => Class['al_bareos::server::install'],
  }

#
# Export all the dynamic ressources.
# This is where the magic happens.
#
  File <<| tag == 'bareos-schedule' |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-jobs'     |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-clients'  |>> { notify  => [Exec['bareos-zfs'],Class['al_bareos::server::service']] }
  File <<| tag == 'bareos-storages' |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-pools'    |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-devices'  |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-filesets' |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-consoles' |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-messages' |>> { notify  => Class['al_bareos::server::service'] }
  File <<| tag == 'bareos-fd-copy'  |>> { notify  => Class['al_bareos::server::service'] }


}
