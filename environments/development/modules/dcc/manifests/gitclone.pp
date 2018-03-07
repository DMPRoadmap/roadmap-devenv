# Grab the code from GitHub and bring it into the VM
class dcc::gitclone {

  package { 'git':
    ensure => installed,
  }

  # Define our main repository and bring in the revision we need from it
  vcsrepo { '/opt/src/dmproadmap.git':
    ensure   => latest,
    provider => git,
    user     => vagrant,
    require  => Package['git'],
    source   => 'https://github.com/DMPRoadmap/roadmap.git',
    revision => 'development',
  } ->
  file { '/opt/src/dmproadmap.git/config/initializers/devise.rb':
          ensure => present,
          source => '/opt/src/dmproadmap.git/config/initializers/devise.rb.example',
          owner  => 'vagrant',
          group  => 'source',
  } ->
  file { '/opt/src/dmproadmap.git/config/initializers/recaptcha.rb':
          ensure => present,
          source => '/opt/src/dmproadmap.git/config/initializers/recaptcha.rb.example',
          owner  => 'vagrant',
          group  => 'source',
  } ->
  file { '/opt/src/dmproadmap.git/config/branding.yml':
          ensure => present,
          source => '/opt/src/dmproadmap.git/config/branding_example.yml',
          owner  => 'vagrant',
          group  => 'source',
  } ->
  file { '/opt/src/dmproadmap.git/tmp':
          ensure => 'directory',
          owner  => 'vagrant',
          group  => 'source',
  }

}
