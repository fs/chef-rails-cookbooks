deployer_deployer_authorized_keys_data_bag = 'deployer_authorized_keys'

# Add authorized keys
#
deployer_authorized_keys = data_bag(deployer_deployer_authorized_keys_data_bag).map do |bag|
  data_bag_item(deployer_deployer_authorized_keys_data_bag, bag)['key']
end

# Create user
#
user_account node.users.deployer.user do
  shell node.users.deployer.shell
  ssh_keys deployer_authorized_keys

  action :create
end

# Make sure it has sudo access
#
node.default.authorization.sudo.users << node.users.deployer.user
