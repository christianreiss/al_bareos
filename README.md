# al_bareos

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with al_bareos](#setup)
    * [What al_bareos affects](#what-al_bareos-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with al_bareos](#beginning-with-al_bareos)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This is a module for Puppet V4 to manage a bareos server/client architecture.
The module -as is- is currently used in production in two sites. The original
code was tailored specificaly to the needs of the data centers; this edition
here has these customizations stripped in favor of generalism.

Main Features:

- Trying to avoid as much load as possible for the clients,
- Compression is done on the storage side,
- storing all data in ZFS Datasets, one set for each client,
- non-destructive installation,
- non-destructive client removal,
- Monitoring included,
- Bareos Server has full-access bconsole shell,
- all clients have restricted (host only) bconsole shells

The Server will place all client files in a ZFS dataset (for each client) and
will utilize serve-side compression for zero client load. As we are deploying
this module via a seperated physical network there is no encryption done to
avoid any load on the clients. You can extend the class to use SSL or set up
VPN links for (truly) remote clients.

It was written with Centos 6 and 7 in mind, but (at least the client) will work
with Debian. The client component will install needed repositories, create the
configuration, export data to the server and will also create ressources for
monitoring (nagios). Note: You have to employ any kind of monitoring solution
that uses exported nagios_services puppet types. This module does create the
service checks but does not install, maintain or run a Nagios/Icinga server.

The Server component is a non-destructive installation. It will install the
repositories on CentOS (tested and run on 7) and configure clients, monitoring,
storage, clients-config, client-consoles and the web-frontent.

Be aware that you need to setup MySQL and the required ZFS repository by
yourself to avoid destruction of data (think dkms after kernel upgrade). Please
read and follow the Setup Instructions below.

## Setup

### What al_bareos affects

The client side does not affect the client side permanently or invaseivly.
Disabling this module via hiera will remove all traces.

The Server side is not so gently. It is highly recommended to install and
deploy the server inside a fresh CentOS7 server.

I'd say backup your data first; but that's what this module is for. :)

### Setup Requirements

The clients have no requirements.

The server needs to have a configured MySQL environment (see below) with a matching username,
database name and password as configured in hiera (see examples directory).
Furthermore the sevrer needs to have ZFS filesystem readily mounted on whatever
you set '$storagepath' via hiera to, by default this is '/bareos/storage'. I
recommended to create a pool named 'bareos' and mount it as '/bareos'. This will
avoid a lot of pitfalls.

### Beginning with al_bareos

If you have your clients readily in puppet and the server has ZFS running, add
the 'al_baroes::client' class to the clients needing a backup, and
'al_bareos::server' *and* 'al_baroes::client' to the server. The server module
is 'just' an extension to the client.

You'll also need to supply some hiera facts. For hiera setup, have a look at

 - examples directory,
 - server.pp and client.pp in the manifests file.

I'd setup MySQL as follows:

- yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
- yum install -y Percona-Server-client-56 Percona-Server-server-56
- systemctl stop mysql
- rm -rf /var/lib/mysql/
- mysql_install_db --user=mysql
- chmod 755 /var/lib/mysql/
- systemctl start mysql
- mysql_secure_installation
- alternatives --config libbaccats.so
- /usr/lib/bareos/scripts/create_bareos_database
- /usr/lib/bareos/scripts/make_bareos_tables
- /usr/lib/bareos/scripts/grant_bareos_privileges

My recommendation for ZFS install:

- yum localinstall -y --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release.el7.noarch.rpm
- yum install -y kernel-devel zfs
- zpool create bareos /path/to/free/disk1 [/path/to/free/disk2 /path/to/free/disk3 ...]

## Usage

Once a client runs puppet, it will create its side of bareos and leave
a running process  behind (bareos-fd). The directory /etc/bareos will be
fully managed and all not needed files will be purged. There is nothing more
to that. If you want to include/exclude files, see the 'manifests/client.pp'
file for possible variables and 'examples/hiera-client.yaml' for hiera
overrides. A client has, by default access to 'bconsole' and all items relating
to this one client only. If you need a cross-client-restore, run bconsole from
the server.

The server will, after a client has run for the first time, create all needed
configurations and a unique ZFS dataset just for this client.

Backups are done (by default)...

- Once a month: A random day of the month: Full Backup,
- Once a day: Differential Backup,
- Every hour: Incremental Backup.

The start minute is also random for each client so the server has a nice even
load. Default renention times:

- Full Backups: Maximum of 5 volumes, keep 3 months at most,
- Differential Backups: Maximum of 35 volumes, keep 31 days at most.
- Incremental Backups: Maximum of 30 volumes, keep 1 day at most.

## Reference

[needs to be written]

## Limitations

This module has been tested with

Client side:
 - Centos 5
 - Centos 6
 - Centos 7
 - Debian 6
 - Debian 7
 - Debian 8
 - XenServer 6.0
 - XenServer 6.2
 - XenServer 6.5

Server side:
 - CentOS 7

This module does *not* encrypt traffic between the nodes.

## Development

All pull requests are welcome and will be considered :)
