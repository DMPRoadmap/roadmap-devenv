# -*- mode: ruby -*-
# vi: set ft=ruby :

#avoids having to $ vagrant up --provider docker
ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'
#ENV['VAGRANT_NO_PARALLEL'] = 'yes'


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
        d.name = 'vagrant-dev'
        d.create_args = [ "--privileged", "-v",
                          "/sys/fs/cgroup:/sys/fs/cgroup:ro",
                          "--net=dmpbridge", "--ip=172.18.0.1", ]
      end

      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true
      d.ports = [ "8080:80" ]
    end
    dev.vm.host_name = 'dmponline-dev'
    dev.vm.synced_folder 'dmponline.git', '/opt/src/dmponline.git'
    dev.vm.network :forwarded_port, host: 8080, guest: 80 #web
    dev.ssh.host = "172.18.0.1"
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


  config.vm.define 'db' do |db|
    db.vm.provider 'docker' do |d|
      #use a prebuilt image ie 'npoggi/vagrant-docker:latest'
      if ENV['DOCKER_IMAGE'] then
        print 'Using docker image ' + ENV['DOCKER_IMAGE'] +' (downloads if necessary)\n'
        d.image = ENV['DOCKER_IMAGE']
      else
        #build from the Dockerfile
        d.build_dir = '.'
        d.name = 'vagrant-db'
        d.create_args = [ "--privileged", "-v",
                          "/sys/fs/cgroup:/sys/fs/cgroup:ro",
                          "--net=dmpbridge", "--ip=172.18.0.2", ]
        d.ports = [ "3306:3306" ]
      end
      #the docker image must remain running for SSH (See the Dockerfile)
      d.remains_running = true
      d.has_ssh = true
    end
    db.vm.host_name = 'dmponline-db'
    db.ssh.host = "172.18.0.2"
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

end
