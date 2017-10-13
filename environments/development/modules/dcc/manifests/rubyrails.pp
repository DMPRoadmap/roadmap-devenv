# Installs Python and dependencies
class dcc::rubyrails {

  class { 'rvm' :
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby { 'ruby-2.2.3' :
    ensure      => 'present',
    default_use => true,
  }

  rvm_gemset { 'ruby-2.2.3@dmproadmap' :
    ensure  => 'present',
    require => Rvm_system_ruby['ruby-2.2.3'],
  }

  rvm_gem { 'ruby-2.2.3@dmproadmap/bundler' :
    ensure  => '1.12.5',
    require => Rvm_gemset['ruby-2.2.3@dmproadmap'],
  }

  rvm_gem { 'ruby-2.2.3@dmproadmap/passenger' :
    ensure  => '5.0.30',
    require => Rvm_gemset['ruby-2.2.3@dmproadmap'],
  }

  class { 'postgresql::globals':
    version => '9.6',
    manage_package_repo => true,
  } ->
  package { [
             'postgresql96-devel',
             'mariadb-devel',
             'ImageMagick-devel',
            ] :
    ensure => 'installed',
  }

  class { '::nodejs':
    repo_url_suffix => '6.x',
    nodejs_dev_package_ensure => 'present',
    npm_package_ensure        => 'present',
    repo_class                => '::epel',
  }

  file { '/opt/src/dmproadmap.git/config/database.yml' :
    owner   => 'vagrant',
    group   => 'source',
    content => "development:\n  adapter: mysql2\n  host: 172.18.0.2\n  database: dmproadmap\n  username: dmproadmap\n  password: dmproadmap\n  encoding: utf8",
    require => Vcsrepo['/opt/src/dmproadmap.git'],
  }

  exec { 'bundle install' :
    command => '/usr/local/rvm/bin/rvm @dmproadmap do bundle config build.pg --with-pg-config=/usr/pgsql-9.6/bin/pg_config && /usr/local/rvm/bin/rvm @dmproadmap do bundle install',
    cwd     => '/opt/src/dmproadmap.git',
    require => [ Rvm_gem['ruby-2.2.3@dmproadmap/bundler'], Vcsrepo['/opt/src/dmproadmap.git'], ]
  }

  file { '/opt/src/dmproadmap.git/config/secrets.yml':
    content => "development:\n    secret_key_base: ",
    owner   => 'vagrant',
    group   => 'source',
  }

  exec { 'rake secret' :
    environment => [ 'RAILS_ENV=development', 'HOME=/home/vagrant', ],
    command => "/bin/bash -c '/usr/local/rvm/bin/rvm @dmproadmap do rake secret >> /opt/src/dmproadmap.git/config/secrets.yml'",
    user    => 'vagrant',
    cwd     => '/opt/src/dmproadmap.git',
    require => [ Rvm_gem['ruby-2.2.3@dmproadmap/bundler'],
                 File['/opt/src/dmproadmap.git/config/secrets.yml'],
                 File['/opt/src/dmproadmap.git/tmp'],],
  }

  exec { 'npm install' :
    command => "/bin/bash -c '/usr/bin/npm install'",
    cwd     => '/opt/src/dmproadmap.git/lib/assets',
    user    => 'vagrant',
  }

  exec { 'npm run bundle -- -p' :
    command => "/bin/bash -c '/usr/bin/npm run bundle &'",
    cwd     => '/opt/src/dmproadmap.git/lib/assets',
    user    => 'vagrant',
  }

  exec { 'rake db:setup' :
    environment => [ 'RAILS_ENV=development', 'HOME=/home/vagrant', ],
    command     => '/usr/local/rvm/bin/rvm @dmproadmap do rake db:setup',
    cwd         => '/opt/src/dmproadmap.git',
    require     => [ Exec['rake secret', 'bundle install', ],
                     File['/opt/src/dmproadmap.git/config/database.yml'],
                     Package['postgresql96-devel', 'mariadb-devel', 'ImageMagick-devel'], ],
  }



}
