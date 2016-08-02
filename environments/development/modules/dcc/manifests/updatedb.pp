# Updates the mlocate database so the locate command works
class dcc::updatedb {

  #require isapps::copydb

  exec { 'updatedb':
    command => '/usr/bin/updatedb',
  }

}
