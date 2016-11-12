# Class: al_bareos::server
# ===========================
#
# This class manages the server side of the bareos System.
# It installs the repository, installs the daemons, configures the sd and dir
# and exports needed data to the clients.
#
# Parameters & Variables
# ----------
#
# Override these variables via hiera.
#
# Compulsory settings:
# $pw_director      = Password for the director
# $pw_storage       = Password for the storage daemon
# $pw_mysql         = Password for user bareos for database bareos.
#
# Optional settings:
# $enable           = Complety enables or disabled the director
# $db_user          = MySQL username
# $db_name          = MySQL database name
# $director         = Name of the director, defaults to fqdn
# $ip               = The IP of the director
# $storagepath      = Directory where to store client data
# $bootpath         = Where to store Boostraps
# $logdir           = Where to store logfiles
# $zfs_pool         = Name of the ZFS pool
# $mail_relay       = IP for the mail relay server (localhost)
# $pw_webui_console = Password for the web-interface
# $webui_vhost      = vhost for th web-interface, defaults to fqdn
#
#
# Examples
# --------
#
# @example
#    include al_bareos::server
#
# Hiera component (plain):
#  al_bareos::server::pw_mysql: 'secretpassword'
#  al_bareos::server::pw_director: 'secretpassword'
#  al_bareos::client::pw_director: 'secretpassword'
#
# Hiera component (using eyaml):
#  al_bareos::server::pw_mysql: ENC[PKCS7,MIIBuQY...ZR6A==]
#  al_bareos::server::pw_director: ENC[PKCS7,MIIBuQY....oXY08bF+W7A==]
#  al_bareos::client::pw_director: ENC[PKCS7,MIIBuQYJKoZ...XY08bF+W7A==]
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

class al_bareos::server (

  $enable           = true,
  $director         = $::fqdn,
  $ip               = $::al_ip::ip_int,
  $storagepath      = '/bareos/storage',
  $bootpath         = '/bareos/bootstraps',
  $logdir           = '/var/log/bareos',
  $zfs_pool         = 'bareos',
  $pw_director      = false,
  $pw_storage       = false,
  $pw_mysql         = false,
  $mail_relay       = '127.0.0.1',
  $db_user          = 'bareos',
  $db_name          = 'bareos',
  $pw_webui_console = fqdn_rand_string('64', '', 'bareos-webui-password'),
  $webui_vhost      = $::fqdn,

) inherits al_bareos::server::params {

  # Sanity checks.
  if (! $pw_storage){
    fail('Please set ::al_bareos::server::pw_storage in hiera.')
  }

  if (! $pw_mysql){
    fail('Please set ::al_bareos::server::pw_mysql in hiera.')
  }

  if (! $pw_director){
    fail('Please set ::al_bareos::server::pw_direcor in hiera.')
  }

  include ::al_bareos::server::install
  include ::al_bareos::server::config
  include ::al_bareos::server::service
  include ::al_bareos::server::monitoring

}
