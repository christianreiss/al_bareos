class al_bareos::server::params {

 #
 # Common Stuff
 #
 $service_sd  = 'bareos-sd'
 $service_dir = 'bareos-dir'
 $package     = [ 'bareos-director', 'bareos-storage', 'bareos-tools', 'bareos-database-mysql', 'bareos-webui', 'mod_ssl' ]

 case ($::operatingsystem) {
   'Debian': {
     $send_nsca_config  = '/etc/send_nsca.cfg'
   }

   'Fedora': {
      $send_nsca_config  = '/etc/nagios/send_nsca.cfg' #N
   }

   'CloudLinux': {
     $send_nsca_config  = '/etc/nagios/send_nsca.cfg' #N
   }

   'CentOS': {
     $send_nsca_config  = '/etc/nagios/send_nsca.cfg' #N
   }

   'XenServer': {
     fail ('Holy Smokes! Are you really trying to install a Backup Server inside a XenServer HOST?!')
   }

   default: {
     fail("Unknown operatingsystem ${::operatingsystem} in icinga::client::params.")
   }
 }
}
