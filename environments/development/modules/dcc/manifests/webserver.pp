# Sets up webserver-related configuration

class dcc::webserver {

  require dcc::gitclone
  require dcc::rubyrails

  yumrepo { 'passenger' :
    descr         => 'Passenger',
    baseurl       => 'https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch',
    repo_gpgcheck => 1,
    gpgcheck      => 0,
    enabled       => 1,
    gpgkey        => 'https://packagecloud.io/gpg.key',
    sslverify     => 1,
    sslcacert     => '/etc/pki/tls/certs/ca-bundle.crt',
  }

  package { 'passenger' :
    ensure  => 'installed',
    require => Yumrepo['passenger'],
  }

  class { 'nginx::config' :
    http_cfg_append => {
                         passenger_root                  => '/usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini',
                         passenger_instance_registry_dir => '/var/run/passenger-instreg',
                       },
  }

  class { 'nginx' :
    require          => Package['passenger'],
  }

  #include nginx::config

  nginx::resource::vhost { 'dmponline-dev' :
    www_root         => '/opt/src/dmponline.git/public',
    vhost_cfg_append => {
                          passenger_enabled => 'on',
                          rails_env         => 'development',
                          passenger_ruby    => '/usr/local/rvm/gems/ruby-2.2.3@dmponline/wrappers/ruby',
                        },
    require          => Package['passenger'],
  }



}
