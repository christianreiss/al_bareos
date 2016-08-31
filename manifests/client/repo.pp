class al_bareos::client::repo(){

#
# Repository
#
  if ( $::al_bareos::client::enable ) {
    case ( $::operatingsystem ) {

      /(CentOS|XenServer|CloudLinux)/: {
        file { '/etc/yum.repos.d/bareos.repo':
          source => "puppet:///modules/al_bareos/repos/bareos-${::operatingsystem}-${::operatingsystemmajrelease}.repo",
          owner  => 'root',
          mode   => '0444',
        }

        exec { 'yum-bareos-update':
          command     => '/usr/bin/yum update',
          refreshonly => true,
          subscribe   => File['/etc/yum.repos.d/bareos.repo'],
        }
      }

      'Debian': {
        file { '/etc/apt/sources.list.d/bareos.list':
          source => "puppet:///modules/al_bareos/repos/bareos-${::operatingsystem}-${::operatingsystemmajrelease}.repo",
          owner  => 'root',
          mode   => '0444',
        }

        exec { 'apt-bareos-update':
          command     => '/usr/bin/apt-get update',
          refreshonly => true,
          subscribe   => File['/etc/apt/sources.list.d/bareos.list'],
        }
      }

      default: {
        fail ('Unknown Operatingsystem in al_bareos::client::repo.')
      }

    }
  }


}
