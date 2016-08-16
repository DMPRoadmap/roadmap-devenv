# Brings in the latest Centos 7 EPEL repository info
class dcc::epel {

  require dcc::standard

  package { 'epel-release':
    ensure => 'installed',
  }

  package { [
             'pygpgme',
             'curl',
            ] :
    ensure  => 'installed',
    require => Package['epel-release'],
  }

}
