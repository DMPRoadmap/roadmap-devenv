# Installs Python and dependencies
class dcc::rubyrails {

  class { 'rvm' :
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby { 'ruby-2.2.5' :
    ensure      => 'present',
    default_use => true,
  }

  rvm_gemset { 'ruby-2.2.5@dmponline' :
    ensure  => 'present',
    require => Rvm_system_ruby['ruby-2.2.5'],
  }

  rvm_gem { 'ruby-2.2.5@dmponline/bundler' :
    ensure  => '1.12.5',
    require => Rvm_gemset['ruby-2.2.5@dmponline'],
  }

  rvm_gem { 'ruby-2.2.5@dmponline/passenger' :
    ensure  => '5.0.30',
    require => Rvm_gemset['ruby-2.2.5@dmponline'],
  }

  rvm_wrapper { [
                 'bundle',
                 'rake',
                ]:
    target_ruby => 'ruby-2.2.5@dmponline',
    prefix      => 'dmp',
    ensure      => 'present',
    require     => Rvm_gemset['ruby-2.2.5@dmponline'],
  }

  package { 'mariadb-devel' :
    ensure => 'installed',
  }

  file { '/opt/src/dmponline.git/config/database.yml' :
    owner  => 'vagrant',
    group  => 'source',
    source => 'puppet:///files/database.yml',
  }

  file { '/opt/src/dmponline.git/config/secrets.yml' :
    owner  => 'vagrant',
    group  => 'source',
    source => 'puppet:///files/secrets.yml',
  }

  exec { 'bundle install' :
    command => '/usr/local/rvm/dmp_bundle install',
    cwd     => '/opt/src/dmponline.git',
    require => Rvm_wrapper['bundle'],
  }

  exec { 'rake db:setup' :
    command => '/usr/local/rvm/dmp_rake db:setup RAILS_ENV=development',
    cwd     => '/opt/src/dmponline.git',
    require => [ Rvm_wrapper['rake'],
                 File['/opt/src/dmponline.git/config/database.yml'],
                 Package['mariadb-devel'], ],
  }

  exec { 'rake secrets' :
    command => '/usr/local/rvm/dmp_rake secrets >> config/secrets.yml',
    cwd     => '/opt/src/dmponline.git',
    require => File['/opt/src/dmponline.git/config/secrets.yml'],
  }
}
