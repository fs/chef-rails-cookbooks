# Copypaste from upstream to get rid of apt-get update running each chef run
case node['platform_family']
when 'debian'
  apt_repository '10gen' do
    uri "http://downloads-distro.mongodb.org/repo/#{node[:mongodb][:apt_repo]}"
    distribution 'dist'
    components ['10gen']
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key '7F0CEB10'
    action :add
  end

when 'rhel','fedora'
  yum_repository '10gen' do
    description '10gen RPM Repository'
    url "http://downloads-distro.mongodb.org/repo/redhat/os/#{node['kernel']['machine']  =~ /x86_64/ ? 'x86_64' : 'i686'}"
    action :add
  end

else
    Chef::Log.warn("Adding the #{node['platform']} 10gen repository is not yet not supported by this cookbook")
end

package node[:mongodb][:package_name] do
  action :install
end

# configure default instance
mongodb_instance 'mongodb' do
  mongodb_type 'mongod'
  bind_ip      node['mongodb']['bind_ip']
  port         node['mongodb']['port']
  logpath      node['mongodb']['logpath']
  dbpath       node['mongodb']['dbpath']
  enable_rest  node['mongodb']['enable_rest']
end

# take the config templates from 'mongodb' cookbook
%w(/etc/default/mongodb /etc/init.d/mongodb).each do |resource|
  resource = (resources("template[#{resource}]") rescue nil)
  resource.cookbook 'mongodb' if resource
end
