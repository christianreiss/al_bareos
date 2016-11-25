class al_bareos::client::repo(){

#
# Repository
#
  if ( $::al_bareos::client::enable ) {
    case ( $::operatingsystem ) {
      /(CentOS|XenServer|CloudLinux|RedHat)/: {
        yumrepo { 'bareos':
          ensure   => present,
          name     => 'bareos',
          baseurl  => "http://download.bareos.org/bareos/release/16.2/CentOS_${::os['release']['major']}/",
          enabled  => true,
          gpgcheck => true,
          gpgkey   => "http://download.bareos.org/bareos/release/16.2/CentOS_${::os['release']['major']}/repodata/repomd.xml.key",
        }
      }

#      'Debian': {
#        file { '/etc/apt/sources.list.d/bareos.list':
#          source => "puppet:///modules/al_bareos/repos/bareos-${::operatingsystem}-${::operatingsystemmajrelease}.repo",
#          owner  => 'root',
#          mode   => '0444',
#        }
#
#        exec { 'apt-bareos-update':
#          command     => '/usr/bin/apt-get update',
#          refreshonly => true,
#          subscribe   => File['/etc/apt/sources.list.d/bareos.list'],
#        }

      default: {
        fail ('Unknown Operatingsystem in al_bareos::client::repo.')
      }
    }
  }
}
