# DMP Roadmap Development Environment

This is the easiest way to get started with DMP Roadmap, as it sets up and deploys a (largely) platform-agnostic and totally sandboxed development environment based on:
* Docker / Vagrant / Puppet
* CentOS 7 / nginx / PostgreSQL / Ruby on Rails

It uses Vagrant to deploy two Docker containers, one for the database and the other for the Rails app.

## Requirements 
1. Docker
  * Linux: [Docker v1.10.3](https://docs.docker.com/engine/installation)
  * Mac OSX: [Docker for Mac Beta](https://docs.docker.com/docker-for-mac)
  * Windows: [Docker for Windows Beta](https://docs.docker.com/docker-for-windows) (untested)
2. Vagrant 
  * [Vagrant v1.8.6](https://www.vagrantup.com/downloads.html)

## Instructions
1. Clone this configuration repository:

 ```bash
 git clone https://github.com/DMPRoadmap/roadmap-devenv.git
 ```

2. Enter your local copy:

 ```bash
 cd roadmap-devenv
 ```

3. Configure Docker networking that the two containers will use:

 ```bash
 docker network create -d bridge --ip-range=172.18.0.0/24 \
                       --subnet=172.18.0.0/24 --gateway=172.18.0.254 \
                       dmpbridge
 ```
 
4. Create the two containers (this should only take a few minutes):

 ```bash
 vagrant up
 ```

5. Your DMP Roadmap development instance is up and running! You can now:
 - Open the running instance with your web browser at:
    - [http://[your_hostname]:8080/](http://[your_hostname]:8080/) (also visible from your network)
    - [http://localhost:8080/](http://localhost:8080/) (only visible locally)

 - Log into either container:
    
    ```bash
    vagrant ssh db
    vagrant ssh dev
    ```
    
 - Find the source code on your host machine (e.g. to edit locally with an IDE) in the shared folder:
    
    ```console
    roadmap-devenv/src/dmproadmap.git/
    ```
    
    which appears inside the `dev` container as:
    
    ```console
    /opt/src/dmproadmap.git/
    ```
    

6. You can customize the fork/branch to check out for deployment in the last two lines of Puppet manifest [`gitclone.pp`](environments/development/modules/dcc/manifests/gitclone.pp):
 
 ```puppet
   vcsrepo { '/opt/src/dmproadmap.git':
    ensure   => latest,
    owner    => vagrant,
    group    => source,
    provider => git,
    user     => vagrant,
    require  => Package['git'],
    source   => 'https://github.com/DMPRoadmap/roadmap.git',
    revision => 'development',
  }
 ```
