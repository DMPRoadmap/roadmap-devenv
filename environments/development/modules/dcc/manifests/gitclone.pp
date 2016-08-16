# Grab the code from GitHub and bring it into the VM
class dcc::gitclone {

  package { 'git':
    ensure => installed,
  }

  # Define the standard location for our source code
  file { '/opt/src' :
    ensure => directory,
    group  => source,
    owner  => vagrant,
    mode   => '0755',
  }

  # Define our main repository and bring in the revision we need from it
  vcsrepo { '/opt/src/dmponline':
    ensure   => latest,
    owner    => vagrant,
    group    => source,
    provider => git,
    user     => vagrant,
    require  => [Package['git'],
                 File['/opt/src'], ],
    source   => 'https://github.com/DigitalCurationCentre/roadmap.git',
    revision => 'development',
  }

}
