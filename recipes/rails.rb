include_recipe 'nginx'

directory '/etc/nginx/sites-include' do
  mode 0755
end

firewall_rule "http" do
  port 80
  action :allow
end

firewall_rule "https" do
  port 443
  action :allow
end

