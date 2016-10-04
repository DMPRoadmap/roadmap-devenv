# Installs Python and dependencies
class dcc::rubyrails {

  require dcc::gitclone

  class { 'rvm' :
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby { 'ruby-2.2.3' :
    ensure      => 'present',
    default_use => true,
  }

  rvm_gemset { 'ruby-2.2.3@dmponline' :
    ensure  => 'present',
    require => Rvm_system_ruby['ruby-2.2.3'],
  }

  rvm_gem { 'ruby-2.2.3@dmponline/bundler' :
    ensure  => '1.12.5',
    require => Rvm_gemset['ruby-2.2.3@dmponline'],
  }

  rvm_gem { 'ruby-2.2.3@dmponline/passenger' :
    ensure  => '5.0.30',
    require => Rvm_gemset['ruby-2.2.3@dmponline'],
  }

  package { [
             'postgresql-devel',
             'ImageMagick-devel',
            ] :
    ensure => 'installed',
  }

  file { '/opt/src/dmponline.git/config/database.yml' :
    owner  => 'vagrant',
    group  => 'source',
    source => 'puppet:///files/database.yml',
  }

  exec { 'bundle install' :
    command => '/usr/local/rvm/bin/rvm @dmponline do bundle install',
    cwd     => '/opt/src/dmponline.git',
    require => Rvm_gem['ruby-2.2.3@dmponline/bundler'],
  }

  file { '/opt/src/dmponline.git/config/secrets.yml':
    content => "development:\n    secret_key_base: ",
    owner   => 'vagrant',
    group   => 'source',
  }

  exec { 'rake secret' :
    environment => [ 'RAILS_ENV=development', 'HOME=/home/vagrant', ],
    command => "/bin/bash -c '/usr/local/rvm/bin/rvm @dmponline do rake secret >> /opt/src/dmponline.git/config/secrets.yml'",
    user    => 'vagrant',
    cwd     => '/opt/src/dmponline.git',
    require => [ Rvm_gem['ruby-2.2.3@dmponline/bundler'], File['/opt/src/dmponline.git/config/secrets.yml'], ],
  }

  exec { 'rake db:setup' :
    environment => [ 'RAILS_ENV=development', 'HOME=/home/vagrant', ],
    #command     => '/usr/local/rvm/gems/ruby-2.2.3@dmponline/wrappers/rake db:setup',
    command     => '/usr/local/rvm/bin/rvm @dmponline do rake db:setup',
    cwd         => '/opt/src/dmponline.git',
    require     => [ Exec['rake secret', 'bundle install', ],
                     File['/opt/src/dmponline.git/config/database.yml'],
                     Package['postgresql-devel', 'ImageMagick-devel'], ],
  }



}
