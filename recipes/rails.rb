include_recipe 'nginx'

directory '/etc/nginx/sites-include' do
  mode 0755
end
