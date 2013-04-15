include_recipe 'postgresql::client'
include_recipe 'postgresql::ruby'
include_recipe 'postgresql::server'

postgresql_connection_info = {
  host: node.postgresql.config.listen_addresses,
  port: node.postgresql.config.port,
  username: 'postgres',
  password: node.postgresql.password.postgres
}

postgresql_database(node.rails.application.db.name) do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user(node.rails.application.db.username) do
  connection postgresql_connection_info
  password node.rails.application.db.password
  action :create
end

postgresql_database_user(node.rails.application.db.username) do
  connection postgresql_connection_info
  database_name node.rails.application.db.name
  privileges [:all]
  action :grant
end
