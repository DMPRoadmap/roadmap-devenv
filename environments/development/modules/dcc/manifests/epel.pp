# Brings in the latest Centos 7 EPEL repository info
class dcc::epel {

  require dcc::standard
 
  include epel

  package { [
             'pygpgme',
             'curl',
            ] :
    ensure  => 'installed',
  }

}
