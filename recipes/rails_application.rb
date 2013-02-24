application_name = node.rails.application.name

directory node.rails.application.root_prefix

if application_name
  application_environment = node.rails.application.environment
  application_domain = node.rails.application.domain

  application_full_name = "#{application_name}_#{node.rails.application.environment}"
  application_root = "#{node.rails.application.root_prefix}/#{application_name}"
  application_current_path = "#{application_root}/current"
  application_shared_path = "#{application_root}/shared"

  unicorn_socket = "#{application_shared_path}/sockets/unicorn.sock"
  unicorn_pid = "#{application_shared_path}/pids/unicorn.pid"
  unicorn_log = "#{application_shared_path}/log/unicorn.log"
  unicorn_config = "#{application_shared_path}/config/unicorn.rb"

  # Create application folders
  # Need for nginx logs
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

  # TODO: add logrotate
  # Setup nginx
  #
  directory '/etc/nginx/sites-include' do
    mode 0755
  end

  template_variables = {
    :application_environment => application_environment,
    :application_full_name => application_full_name,
    :application_name => application_name,
    :application_domain => application_domain,
    :application_root => application_root,
    :application_current_path => application_current_path,
    :application_shared_path => application_shared_path,
    :unicorn_socket => unicorn_socket,
    :unicorn_pid => unicorn_pid,
    :unicorn_log => unicorn_log,
    :unicorn_workers => node.rails.application.unicorn.workers,
    :unicorn_timeout => node.rails.application.unicorn.timeout,
    :unicorn_user => node.users.deployer.user
  }

  template "/etc/nginx/sites-include/#{application_full_name}.conf" do
    source 'app_nginx_include.conf.erb'

    variables template_variables

    notifies :reload, resources(:service => 'nginx')
  end

  template "/etc/nginx/sites-available/#{application_full_name}.conf" do
    source 'app_nginx.conf.erb'

    variables template_variables

    notifies :reload, resources(:service => 'nginx')
  end

  nginx_site application_full_name do
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

    variables template_variables
  end
else
  Chef::Log.info 'Recipe flatstack::rails_application skipped'
  Chef::Log.info <<-INFO
    Please setup rails application name in the `rails.application.name` attribute for node
    In case you would like to setup rails application

  INFO
end
