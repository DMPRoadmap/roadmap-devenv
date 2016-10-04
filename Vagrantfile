# -*- mode: ruby -*-
# vi: set ft=ruby :

# avoids having to $ vagrant up --provider docker
ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

# build one image before the other (no race)
ENV['VAGRANT_NO_PARALLEL'] = 'yes'


Vagrant.configure(2) do |config|


  config.vm.define 'db' do |db|
    db.vm.provider 'docker' do |d|
      d.force_host_vm = false

      #build from the Dockerfile
      d.build_dir = '.'
      d.name = 'vagrant-db'
      d.create_args = [ "--privileged", "-v",
                        "/sys/fs/cgroup:/sys/fs/cgroup:ro",
                        "--net=dmpbridge", "--ip=172.18.0.2", ]
      d.ports = [ "5435:5435","4022:22" ]

      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true
    end
    db.vm.host_name = 'dmponline-db'
    db.ssh.port = "4022"
    db.ssh.host = "127.0.0.1"
    db.vm.network :forwarded_port, host:5435 , guest:5435
    db.vm.provision :shell do |shell|
      shell.inline = "
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/vcsrepo;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/motd;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules jfryman/nginx;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules maestrodev/rvm;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules ghoneycutt/ssh;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/mysql;
                     "
    end
    db.vm.provision :puppet do |puppet|
      puppet.environment = 'development'
      puppet.environment_path = 'environments'
      puppet.options = [ "--fileserverconfig=/vagrant/fileserver.conf", ]
      puppet.facter = {
        "vagrant" => "1"
      }
    end
  end


  config.vm.define 'dev' do |dev|
    dev.vm.provider 'docker' do |d|
      d.force_host_vm = false

      #build from the Dockerfile
      d.build_dir = '.'
      d.name = 'vagrant-dev'
      d.create_args = [ "--privileged", "-v",
                        "/sys/fs/cgroup:/sys/fs/cgroup:ro",
                        "--net=dmpbridge", "--ip=172.18.0.1", ]

      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true
      d.ports = [ "8080:80","5020:22" ]
    end
    dev.vm.host_name = 'dmponline-dev'
    dev.vm.synced_folder 'src', '/opt/src'
    dev.vm.network :forwarded_port, host: 8080, guest: 80 #web
    dev.ssh.host = "127.0.0.1"
    dev.ssh.port = "5020"
    dev.vm.provision :shell do |shell|
      shell.inline = "
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/vcsrepo;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/motd;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules jfryman/nginx;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules maestrodev/rvm;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules ghoneycutt/ssh;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/mysql;
                     "
    end
    dev.vm.provision :puppet do |puppet|
      puppet.environment = 'development'
      puppet.environment_path = 'environments'
      puppet.options = [ "--fileserverconfig=/vagrant/fileserver.conf", ]
      puppet.facter = {
        "vagrant" => "1"
      }
    end
  end


end
