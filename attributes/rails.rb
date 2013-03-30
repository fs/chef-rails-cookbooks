default.rails.application.name = nil
default.rails.application.root_prefix = '/var/www'
default.rails.application.domain = 'example.com'
default.rails.application.environment = 'production'
default.rails.application.packages = []

default.rails.application.unicorn.workers = 2
default.rails.application.unicorn.timeout = 60

default.rails.application.db.type = 'postgres'
default.rails.application.db.host = 'localhost'
default.rails.application.db.name = node.rails.application.name
default.rails.application.db.username = node.rails.application.name
default.rails.application.db.password = 'change-me'
