include_recipe 'ohai'
include_recipe 'apt'
include_recipe 'hostname'
include_recipe 'vim'
include_recipe 'git'
include_recipe 'postfix'

node.base.packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end
