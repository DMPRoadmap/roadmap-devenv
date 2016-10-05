# Installs and sets up the required database
class dcc::database {

  class { 'postgresql::globals':
    version => '9.5',
    manage_package_repo => true,
  }

  class { 'postgresql::server':
    listen_addresses     => '*',
    port                 => 5435,
    ipv4acls             => [
                             'local all postgres                trust',
                             'local all dmponline               trust',
                             'host  all dmponline 172.18.0.0/24 md5  ',
                            ],
    pg_hba_conf_defaults => false,
  }
  postgresql::server::db { 'dmponline' :
    owner    => 'dmponline',
    user     => 'dmponline',
    password => postgresql_password('dmponline', 'dmponline'),
  }
  postgresql::server::role { 'dmponline':
    superuser     => true,
    password_hash => postgresql_password('dmponline', 'dmponline'),
  }
}
