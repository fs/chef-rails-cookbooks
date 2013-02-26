include_recipe 'nginx'

rbenv_gem 'unicorn' do
  ruby_version node.ruby.version
  version rails.application.unicorn.version
end

