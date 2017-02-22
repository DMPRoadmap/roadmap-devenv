# Installs and sets up the required database
class dcc::database {

  class { 'postgresql::globals':
    version => '9.6',
    manage_package_repo => true,
  }

  class { 'postgresql::server':
    listen_addresses     => '*',
    port                 => 5435,
    ipv4acls             => [
                             'local all postgres                 trust',
                             'local all dmproadmap               trust',
                             'host  all dmproadmap 172.18.0.0/24 md5  ',
                            ],
    pg_hba_conf_defaults => false,
  }
  postgresql::server::db { 'dmproadmap' :
    owner    => 'dmproadmap',
    user     => 'dmproadmap',
    password => postgresql_password('dmproadmap', 'dmproadmap'),
  }
  postgresql::server::role { 'dmproadmap':
    superuser     => true,
    password_hash => postgresql_password('dmproadmap', 'dmproadmap'),
  }
}
