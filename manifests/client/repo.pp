class al_bareos::client::repo(){

#
# Repository
#
  if ( $::al_bareos::client::enable ) {
    case ( $::operatingsystem ) {

      'Fedora': {

        case ( $::os['release']['major'] ) {
          25: {
            yumrepo { 'bareos':
              ensure   => present,
              name     => 'bareos',
              baseurl  => "http://download.bareos.org/bareos/release/16.2/Fedora_24/",
              enabled  => true,
              gpgcheck => true,
              gpgkey   => "http://download.bareos.org/bareos/release/16.2/Fedora_24/repodata/repomd.xml.key",
            }
          }

          24: {
            yumrepo { 'bareos':
              ensure   => present,
              name     => 'bareos',
              baseurl  => "http://download.bareos.org/bareos/release/16.2/Fedora_24/",
              enabled  => true,
              gpgcheck => true,
              gpgkey   => "http://download.bareos.org/bareos/release/16.2/Fedora_24/repodata/repomd.xml.key",
            }
          }
        }
      }

      /(CentOS|CloudLinux|RedHat)/: {


        yumrepo { 'bareos':
          ensure   => present,
          name     => 'bareos',
          baseurl  => "http://download.bareos.org/bareos/release/16.2/CentOS_${::os['release']['major']}/",
          enabled  => true,
          gpgcheck => true,
          gpgkey   => "http://download.bareos.org/bareos/release/16.2/CentOS_${::os['release']['major']}/repodata/repomd.xml.key",
        }
      }

      /(XenServer)/: {


        case ( $::os['release']['major'] ) {
          /(5|6)/: {
            yumrepo { 'bareos':
              ensure   => present,
              name     => 'bareos',
              baseurl  => 'http://download.bareos.org/bareos/release/16.2/CentOS_5/',
              enabled  => true,
              gpgcheck => true,
              gpgkey   => 'http://download.bareos.org/bareos/release/16.2/CentOS_5/repodata/repomd.xml.key',
            }
          }

          /(7)/: {
            yumrepo { 'bareos':
              ensure   => present,
              name     => 'bareos',
              baseurl  => 'http://download.bareos.org/bareos/release/16.2/CentOS_7/',
              enabled  => true,
              gpgcheck => true,
              gpgkey   => 'http://download.bareos.org/bareos/release/16.2/CentOS_7/repodata/repomd.xml.key',
            }
          }

          default: {
            fail ("Unknown XenServer Version ${::os['release']['major']} for bareos.")
          }
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
