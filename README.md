# What's included

## Base

* [ohai](http://community.opscode.com/cookbooks/ohai)
* [hostname](http://community.opscode.com/cookbooks/hostname)
* [vim](http://community.opscode.com/cookbooks/vim)
* [git](http://community.opscode.com/cookbooks/git)
* [htop](http://community.opscode.com/cookbooks/htop)


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

* Installs [postgresql](http://community.opscode.com/cookbooks/postgresql) client and server.


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
* Installs `node.rails.application.unicorn.version`


## Rails application

### Attributes

* `node.rails.application.name`: nil
* `node.rails.application.root_prefix`: /var/www
* `node.rails.application.domain`: example.com
* `node.rails.application.environment`: production
* `node.rails.application.packages`: []
* `node.rails.application.unicorn.workers`: 2
* `node.rails.application.unicorn.timeout`: 60
* `node.rails.application.db.name`: `node.rails.application.name`
* `node.rails.application.db.username`: `node.rails.application.name`
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
* Installs `node.rails.application.packages` packadges
* Creates db:
  * database `node.rails.application.db.name` name
  * grants access to db to `node.rails.application.db.username` with `node.rails.application.db.password`
* Creates `/var/www/#{node.rails.application.name}/shared/config/database.yml`

# Develop

* `script/bootstrap`
* develop
* `rake foodcritic`

# TODO

* configure iptables
* sshd config
* logentries https://github.com/jagregory/chef-logentries
* setup logrotate
* crontab https://github.com/fs/sliceconfig/blob/master/config/etc/crontab
* motd https://github.com/fs/sliceconfig/blob/master/config/etc/motd
