# Host system requirements

* Tested on Ubuntu 12.04 LTS 64bit
* You should have root or nopasswd sudo access

# What's included

## Base

* [ohai](http://community.opscode.com/cookbooks/ohai)
* [hostname](http://community.opscode.com/cookbooks/hostname)
* [vim](http://community.opscode.com/cookbooks/vim)
* [git](http://community.opscode.com/cookbooks/git)
* [postfix](http://community.opscode.com/cookbooks/postfix)

### Attributes
* `base.packages`: ['wget', 'curl', 'htop'] -- these packages will get automatically installed to the host


## Deployer

### Attributes

* `node.users.deployer.user`: deployer
* `node.users.deployer.shell`: /bin/bash

### Recipe

Creates `node.users.deployer.user` user with `node.users.deployer.shell`.

You can allow different users to login using key based auth by storing ssh public keys
in the `deployer_authorized_keys` data bag, one json file per user:

```json
// data_bags/deployer_authorized_keys/user-name.json
{
  "id": "user-name",
  "key": "ssh-rsa AAAAB3..."
}
```

## Postgres

### Attributes

* `node.rails.application.db.name`: `node.rails.application.name`
* `node.rails.application.db.username`: `node.rails.application.name`
* `node.rails.application.db.password`: 'change-me'

### Recipes

#### recipe[flatstack::postgresql]
* Installs [postgresql](http://community.opscode.com/cookbooks/postgresql) client
* Installs [postgresql](http://community.opscode.com/cookbooks/postgresql) ruby bindings

#### recipe[flatstack::postgresql_server]
* Installs [postgresql](http://community.opscode.com/cookbooks/postgresql) server.
* Creates database `node.rails.application.db.name`
* Creates `node.rails.application.db.username` with `node.rails.application.db.password`
* Grants full access on `node.rails.application.db.name` to `node.rails.application.db.username`


## Ruby

### Attributes

* `node.ruby.version`: ruby-1.9.3-p194
* `node.ruby.bundler_version`: 1.2.4

### Recipe

* Installs `node.ruby.version` as default using [rbenv](http://community.opscode.com/cookbooks/rbenv).
* Installs `node.ruby.bundler_version`.


## Rails

### Attributes

* `node.rails.application.unicorn.version`: 4.6.2

### Recipe

* Installs [nginx](https://github.com/jsierles/chef_cookbooks/tree/master/nginx)


## Rails application

### Attributes

* `node.rails.application.name`: nil
* `node.rails.application.root_prefix`: /var/www
* `node.rails.application.domain`: example.com
* `node.rails.application.environment`: production
* `node.rails.application.packages`: []
* `node.rails.application.unicorn.workers`: 2
* `node.rails.application.unicorn.timeout`: 60
* `node.rails.application.db.type`: postgres
* `node.rails.application.db.password`: 'change-me'

### Recipe

* Creates `/var/www/#{node.rails.application.name}` as application root
* Creates `releases`, `shared/sockets`, `shared/log`, `shared/pids`, `shared/config`
  folders inside application root, requried for capistrano
* Nginx configuration files
  * `/etc/nginx/sites-include/#{node.rails.application.name}.conf`
  * `/etc/nginx/sites-available/#{node.rails.application.name}.conf`
* Creates `unicorn`:
  * configuration at `/var/www/#{node.rails.application.name}/shared/config/unicorn.rb`
  * init script at `/etc/init.d/unicorn_#{node.rails.application.name}`
* Installs `node.rails.application.packages` packages
* Creates `/var/www/#{node.rails.application.name}/shared/config/database.yml`

## Logentries

### Attributes
* `logentries.account_key`: nil
* `logentries.hostname`: node.fqdn
* `logentries.logs`: {}

### Recipe
* Installs packages `logentries` and `logentries-daemon`
* Registers the node in logentries
* Follows all logs from `logentries.logs`

## ElasticSearch

### Attributes
* `elasticsearch.version`: 0.20.6

### Recipe
* Downloads and installs ElasticSearch deb-package of the specified version

# Develop

* `script/bootstrap`
* develop
* `rake foodcritic`

# TODO

* configure iptables
* sshd config
* setup logrotate
* crontab https://github.com/fs/sliceconfig/blob/master/config/etc/crontab
* motd https://github.com/fs/sliceconfig/blob/master/config/etc/motd
