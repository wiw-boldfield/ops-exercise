include_attribute 'wiw-nginx'
include_attribute 'wiw-mysql'
include_attribute 'wiw-blog'
include_attribute 'wiw-hhvm'


default.wiw_mysql.service_name = 'wiw-blog'
default.wiw_blog.domain = 'blog.wheniwork.com'
default.wiw_blog.ssl_vault = 'wiw-blog'
default.wiw_mysql.password_vault = 'mysql'
default.wiw_mysql.tablename = 'wiw'
default.wiw_mysql.username = 'wiw'
