if node.logentries.account_key
  include_recipe 'logentries'

  logentries do
    account_key node.logentries.account_key
    server_name node.logentries.hostname

    action :register
  end

  node.logentries.logs.each do |name, file|
    logentries file do
      log_name name
      action :follow
    end
  end
end
