# Updates the mlocate database so the locate command works
class dcc::updatedb {

  exec { 'updatedb':
    command => '/usr/bin/updatedb',
  }

}
