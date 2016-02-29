include_attribute 'hhvm'

default.wiw_hhvm.user = 'www-data'
default.wiw_hhvm.group = 'www-data'

default.wiw_hhvm.install_fastcgi = true
default.wiw_hhvm.listen_socket = true
default.wiw_hhvm.socket = '/var/run/hhvm/hhvm.sock'
default.wiw_hhvm.conf_dir = '/etc/hhvm'
default.wiw_hhvm.server_conf = 'server.ini'
