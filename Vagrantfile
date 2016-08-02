# -*- mode: ruby -*-
# vi: set ft=ruby :

#avoids having to $ vagrant up --provider docker
ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.configure(2) do |config|

  config.vm.define 'dev' do |dev|
    dev.vm.provider 'docker' do |d|

      #use a prebuilt image ie 'npoggi/vagrant-docker:latest'
      if ENV['DOCKER_IMAGE'] then
        print 'Using docker image ' + ENV['DOCKER_IMAGE'] +' (downloads if necessary)\n'
        d.image = ENV['DOCKER_IMAGE']
      else
        #build from the Dockerfile
        d.build_dir = '.'
        d.name = 'vagrant-docker'
        d.create_args = [ "--privileged", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro" ]
      end

      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true

    end

    dev.vm.host_name = 'dmponline-dev'
    dev.vm.synced_folder 'web-root/', '/vagrant/web-root'
    dev.vm.network :forwarded_port, host: 8080, guest: 80 #web

    dev.vm.provision :shell do |shell|
      shell.inline = "
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/vcsrepo;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/motd;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules jfryman/nginx;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules maestrodev/rvm;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules ghoneycutt/ssh;
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

  config.vm.define 'db' do |db|
    db.vm.provider 'docker' do |d|

      #use a prebuilt image ie 'npoggi/vagrant-docker:latest'
      if ENV['DOCKER_IMAGE'] then
        print 'Using docker image ' + ENV['DOCKER_IMAGE'] +' (downloads if necessary)\n'
        d.image = ENV['DOCKER_IMAGE']
      else
        #build from the Dockerfile
        d.build_dir = '.'
        d.name = 'vagrant-docker'
        d.create_args = [ "--privileged", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro" ]
      end

      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true

    end

    db.vm.host_name = 'dmponline-dev-db'
    #db.vm.synced_folder 'web-root/', '/vagrant/web-root'
    db.vm.network :forwarded_port, host: 3306, guest: 3306 #mysql

    db.vm.provision :shell do |shell|
      shell.inline = "
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules puppetlabs/mysql;
                      puppet module install --modulepath /opt/puppetlabs/puppet/modules ghoneycutt/ssh;
                     "
    end

    db.vm.provision :puppet do |puppet|
      puppet.environment = 'database'
      puppet.environment_path = 'environments'
      puppet.options = [ "--fileserverconfig=/vagrant/fileserver.conf", ]
      puppet.facter = {
        "vagrant" => "1"
      }
    end
  end





  #container linking for multiple machines
  # Read http://docs.docker.com/userguide/dockerlinks/#container-linking
  #d.link('vagrant-docker:web')

end
