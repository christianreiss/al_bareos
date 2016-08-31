# Class: al_bareos::client
# ===========================
#
# This class manages the client side of the bareos System.
# It installs the repository, installs the daemon, configures the client
# and exports needed data to the director.
#
# Parameters & Variables
# ----------
#
# Override these variables via hiera.
#
# Compulsory settings:
# $director    = Name of the director, as defined in the server-class.
# $sd_ip       = The (reachable from the client) ip for the bareos-sd
# $pw_director = false,
# $pw_storage  = false,
#
# Optional settings:
# $enable      = Completly enables or disabled the client.
# $ip          = The ip of the client (where bareos-fd will listen on).
# $pw_client   = Client password. Random if not defined.
# $pw_console  = Client console password. Random if not defined.
# $storagepath = Full path on where to dump the data, server side.
# $logdir      = Where to write the logs, client side.
# $bootstrap   = Directoy(!) where to store bootstrap files on the server.
# $accurate    = If the fileset should be accurate, defaults to true.
# $onefs       = Should we stay on one filesystem, defaults to true.
# $include     = hiera array of things to include (defaults to /).
# $exclude     = hiera array of things to exclude (defaults to none).
# $monitoring  = enables or disables monitoring.
#
# Examples
# --------
#
# @example
#    include al_bareos::client
#
# Hiera component:
#    ---
#    al_bareos::client::exclude:
#      - /var/cache/icinga
#    al_bareos::client::pw_director: 'secretpassword'
#    al_bareos::client::onefs:
#
# See examples/hiera* for real life examples.
#
# Authors
# -------
#
# Christian Reiss (support@alpha-labs.net)
#
# Copyright
# ---------
#
# Copyright 2016 Christian Reiss
#

class al_bareos::client (

  $enable            = true,
  $accurate          = true,
  $bootstrap         = '/bareos/bootstraps',
  $director          = false,
  $exclude           = 'unset',
  $include           = 'unset',
  $ip                = $::ipaddress,
  $logdir            = '/var/log/bareos',
  $monitoring        = false,
  $onefs             = 'yes',
  $pw_client         = fqdn_rand_string('64', '', 'bareos-client-password'),
  $pw_console        = fqdn_rand_string('64', '', 'bareos-console-password'),
  $pw_director       = false,
  $pw_storage        = false,
  $sched_day         = (fqdn_rand('26', 'bacula-schedule_day') + 1), # full day.
  $sched_hour        = fqdn_rand('23', 'bacula-schedule_hour'),      # full/diff hour
  $sched_min         = fqdn_rand('59', 'bacula-schedule_minute'),    # reg start minute.
  $sd_ip             = false,
  $storagepath       = '/bareos/storage',

) inherits al_bareos::client::params {

  # Sanity checks.
  if (! $pw_storage){
    fail('Please set ::al_bareos::client::pw_storage in hiera.')
  }

  if (! $sd_ip ){
    fail('Please set ::al_bareos::client::sd_ip in hiera.')
  }

  if (! $director ){
    fail('Please set ::al_bareos::client::director in hiera.')
  }

  # Load the reminder of the class.
  include ::al_bareos::client::repo
  include ::al_bareos::client::install
  include ::al_bareos::client::config
  include ::al_bareos::client::service
  include ::al_bareos::client::monitoring

}
