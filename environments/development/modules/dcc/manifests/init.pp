class dcc {
  include dcc::standard
  include dcc::epel
  include dcc::rubyrails
  include dcc::gitclone
  include dcc::webserver
  include dcc::updatedb

#  include dcc::sshmotd
#  include dcc::maven
#  include dcc::copydb
#  include dcc::firewall
}
