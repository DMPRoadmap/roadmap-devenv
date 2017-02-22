node 'dmproadmap-dev' {

  include dcc::standard
  include dcc::epel
  include dcc::gitclone
  include dcc::rubyrails
  include dcc::webserver
  include dcc::updatedb

}

node 'dmproadmap-db' {
  include dcc::standard
  include dcc::database
  include dcc::updatedb
}
