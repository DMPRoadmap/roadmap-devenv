# Installs and sets up the required database
class dcc::database {

  class { 'mysql::server':
    package_ensure => 'installed',
    override_options => {
      mysqld => {
                  bind-address => '0.0.0.0',
                  character-set-server => 'utf8',
                }
    },
  }


  mysql::db { 'dmproadmap' :
    user     => 'dmproadmap',
    password => 'dmproadmap',
    host     => '%',
    grant    => [ 'ALL', ],
  }

}
