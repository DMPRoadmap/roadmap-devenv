# Installs and sets up the required database
class dcc::database {

  class { 'postgresql::globals':
    version => '9.6',
    manage_package_repo => true,
  }

  class { 'postgresql::server':
    listen_addresses     => '*',
    port                 => 5435,
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
  postgresql::server::pg_hba_rule { 'local all postgres trust' :
    type        => 'local',
    database    => 'all',
    user        => 'postgres',
    auth_method => 'trust',
  }
  postgresql::server::pg_hba_rule { 'local all dmproadmap trust' :
    type        => 'local',
    database    => 'all',
    user        => 'dmproadmap',
    auth_method => 'trust',
  }
  postgresql::server::pg_hba_rule { 'host all dmproadmap 172.18.0.0/24 md5' :
    type        => 'host',
    database    => 'all',
    user        => 'dmproadmap',
    address     => '172.18.0.0/24',
    auth_method => 'md5',
  }


}
