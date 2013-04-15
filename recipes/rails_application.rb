include_recipe 'flatstack::rails'

application_name = node.rails.application.name

directory node.rails.application.root_prefix

if application_name
  application_environment = node.rails.application.environment
  application_domain = node.rails.application.domain

  application_root = "#{node.rails.application.root_prefix}/#{application_name}"
  application_current_path = "#{application_root}/current"
  application_shared_path = "#{application_root}/shared"

  unicorn_socket = "#{application_shared_path}/sockets/unicorn.sock"
  unicorn_pid = "#{application_shared_path}/pids/unicorn.pid"
  unicorn_log = "#{application_shared_path}/log/unicorn.log"
  unicorn_config = "#{application_shared_path}/config/unicorn.rb"

  database_yml_config = "#{application_shared_path}/config/database.yml"

  # Create application folders
  #
  directory application_root do
    owner node.users.deployer.user
    group node.users.deployer.user
  end

  %W(releases shared shared/sockets shared/log shared/pids shared/config).each do |dir|
    directory "#{application_root}/#{dir}" do
      recursive true
      owner node.users.deployer.user
      group node.users.deployer.user
    end
  end

  # Setup nginx
  #
  template_variables = {
    application_environment: application_environment,
    application_name: application_name,
    application_domain: application_domain,
    application_root: application_root,
    application_current_path: application_current_path,
    application_shared_path: application_shared_path,
    unicorn_config: unicorn_config,
    unicorn_socket: unicorn_socket,
    unicorn_pid: unicorn_pid,
    unicorn_log: unicorn_log,
    unicorn_workers: node.rails.application.unicorn.workers,
    unicorn_timeout: node.rails.application.unicorn.timeout,
    unicorn_user: node.users.deployer.user,
    database_yml_config: database_yml_config,
    database_host: node.rails.application.db.host,
    database_name: node.rails.application.db.name,
    database_username: node.rails.application.db.username,
    database_password: node.rails.application.db.password,

  }

  template "/etc/nginx/sites-include/#{application_name}.conf" do
    source 'app_nginx_include.conf.erb'

    variables template_variables

    notifies :reload, resources(service: 'nginx')
  end

  template "/etc/nginx/sites-available/#{application_name}.conf" do
    source 'app_nginx.conf.erb'

    variables template_variables

    notifies :reload, resources(service: 'nginx')
  end

  nginx_site application_name do
    action :enable
  end

  # Setup application packages
  #
  application_packages = node.rails.application.packages
  if application_packages
    application_packages.each do |package_name|
      package package_name
    end
  end

  # Setup unicorn
  #
  template unicorn_config do
    source 'unicorn.rb.erb'

    variables template_variables

    owner node.users.deployer.user
    group node.users.deployer.user
  end

  template "/etc/init.d/unicorn_#{application_name}" do
    source 'unicorn_init.erb'
    mode 0755
    variables template_variables
  end


  # Setup database yaml
  #
  template database_yml_config do
    source "database.yml.#{node.rails.application.db.type}.erb"

    variables template_variables

    owner node.users.deployer.user
    group node.users.deployer.user
  end

else
  Chef::Log.info 'Recipe flatstack::rails_application skipped'
  Chef::Log.info <<-INFO
    Please setup rails application name in the `rails.application.name` attribute for node
    In case you would like to setup rails application

  INFO
end
