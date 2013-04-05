maintainer       'FlatStack'
maintainer_email 'support@flatstack.com'
license          'All rights reserved'
description      'Installs/Configures FlatStack Chef Cookbooks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.6'

depends 'ohai'
depends 'apt'
depends 'hostname'
depends 'vim'
depends 'git'
depends 'rbenv'
depends 'user', '0.3.0'
depends 'nginx'
depends 'database'
depends 'mysql'
depends 'postgresql'
depends 'postfix'
depends 'logentries'
depends 'sudo'
depends 'ufw'
depends 'sysctl'
depends 'fail2ban'
