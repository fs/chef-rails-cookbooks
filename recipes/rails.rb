include_recipe 'nginx'

directory '/etc/nginx/sites-include' do
  mode 0755
end

rbenv_gem 'unicorn' do
  ruby_version node.ruby.version
  version node.rails.application.unicorn.version
end

