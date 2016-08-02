# Sets up webserver-related configuration

class dcc::webserver {

  require dcc::gitclone
  require dcc::rubyrails

  include nginx

  nginx::resource::vhost { 'dmponline-dev':
    www_root => '/opt/src/dmponline',
  }

}
