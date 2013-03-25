include_recipe 'nginx'

directory '/etc/nginx/sites-include' do
  mode 0755
end

node.default.firewall.rules.push(
  {'http' => {}},
  {'https' => {}}
)
