# Base Vagrant box

FROM centos:7

# Optional, upgrade to latest (takes a while), but before install sshd
RUN yum -y update

RUN yum -y install systemd systemd-libs initscripts sudo wget curl openssh-server openssh-clients

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Create and configure vagrant user
RUN useradd --create-home -s /bin/bash vagrant
WORKDIR /home/vagrant

# Configure SSH access

RUN mkdir -p /home/vagrant/.ssh && \
#    ssh-keygen -A && \
    wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys && \
    chmod 0700 /home/vagrant/.ssh && \
    chmod 0600 /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \

    mkdir -p /etc/sudoers.d && \
    install -b -m 0440 /dev/null /etc/sudoers.d/vagrant && \
    echo 'vagrant ALL=NOPASSWD: ALL' >> /etc/sudoers.d/vagrant && \
    sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers && \
    sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config && \
    systemctl enable sshd.service && \

    #gpasswd -a vagrant wheel && \
    #usermod -a -G sudo vagrant && \
    #`# Enable passwordless sudo for users under the "sudo" group` && \
    #sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers && \

    echo -n 'vagrant:vagrant' | chpasswd 
    
#`# Thanks to http://docs.docker.io/en/latest/examples/running_ssh_service/` && \
    #mkdir /var/run/sshd



# Puppet
RUN wget http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm -O /tmp/puppetlabs-release-stable.rpm && \
    rpm -i /tmp/puppetlabs-release-stable.rpm && \
#    yum -y install puppet-agent hostname && \
    rm -f /tmp/*.rpm && \
    yum clean all && \
    yum -y install puppet puppet-common hiera facter virt-what lsb-release 

VOLUME [ "/sys/fs/cgroup" ]

# Expose port 22 for ssh
EXPOSE 22

#leave the SHH daemon (and container) running
CMD ["/usr/sbin/init"]
