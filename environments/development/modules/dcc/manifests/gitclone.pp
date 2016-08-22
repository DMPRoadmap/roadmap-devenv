# Grab the code from GitHub and bring it into the VM
class dcc::gitclone {

  package { 'git':
    ensure => installed,
  }

  # Define our main repository and bring in the revision we need from it
  vcsrepo { '/opt/src/dmponline.git':
    ensure   => latest,
    provider => git,
    user     => vagrant,
    require  => Package['git'],
    source   => 'https://github.com/DigitalCurationCentre/roadmap.git',
    revision => 'master',
  }

}
