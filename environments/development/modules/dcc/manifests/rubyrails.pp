# Installs Python and dependencies
class dcc::rubyrails {

  require dcc::gitclone

  class { 'rvm' :
  }

  rvm::system_user { vagrant: ; }

  rvm_system_ruby { 'ruby-2.2.5' :
    ensure      => 'present',
    default_use => true,
  }

  rvm_gemset { 'ruby-2.2.5@dmponline' :
    ensure  => 'present',
    require => Rvm_system_ruby['ruby-2.2.5'],
  }

  rvm_gem { 'ruby-2.2.5@dmponline/rails' :
    ensure  => '4.2.7',
    require => Rvm_gemset['ruby-2.2.5@dmponline'],
  }

  rvm_gem { 'ruby-2.2.5@dmponline/passenger' :
    ensure  => '5.0.30',
    require => Rvm_gemset['ruby-2.2.5@dmponline'],
  }

}
