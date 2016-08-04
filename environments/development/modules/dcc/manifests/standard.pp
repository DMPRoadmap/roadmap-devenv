class dcc::standard {

  package { 'deltarpm':
    ensure => 'installed',
    before => Exec['yumupdate'],
  }

  exec { 'yumupdate':
    #command => '/usr/bin/yum -y update',
    command => '/bin/ls',
  }

  package { [
             'bash-completion',
             'bzip2',
             'man',
             'mlocate',
             'nano',
             'net-tools',
             'unzip',
             'which',
            ] :
    ensure => 'installed',
  }

  file { '/usr/bin/pico':
    ensure => 'link',
    target => '/usr/bin/nano',
  }

  group { ['data', 'source',] :
    ensure => 'present',
  }

  file { '/var/data' :
    ensure => directory,
    group  => root,
    owner  => root,
    mode   => '2755',
  }

}
