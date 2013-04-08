remote_file node.elasticsearch.cache_path do
  action :create_if_missing
  source node.elasticsearch.url
  mode '0644'
end

package "default-jre-headless"

dpkg_package "elasticsearch" do
  action :install
  source node.elasticsearch.cache_path
end

service "elasticsearch" do
  action [:start,:enable]
  supports [:status, :restart]
end
