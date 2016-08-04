# Installs and sets up the required database
class dcc::database {

  class { 'mysql::server':
    package_ensure => '5.5.47',
    override_options => {
      mysqld => {
                  bind-address => '0.0.0.0',
                }
    },
  }


  mysql::db { 'dmponline' :
    user     => 'dmponline',
    password => 'dmponline',
    host     => '172.17.0.1',
    grant    => [ 'ALL', ],
  }

}
