#ubuntu server 12.04


apt-get update
apt-get -y upgrade


apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php5


apt-get update

apt-get install -y php5 apache2 php-pear

apt-get install -y graphviz

#install mariadb
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

add-apt-repository 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu precise main'

apt-get update

apt-get install -y mariadb-server


#others


apt-get install -y curl php5-curl php5-gd php5-mcrypt php5-mysqlnd tree iftop nmap php5-xsl libssh2-php



sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/cli/php.ini

sed -i 's/\/var\/www\/html/\/data\/www/g'  /etc/apache2/sites-enabled/000-default.conf


sed -i 's/\/var\/www/\/data\/www/g'  /etc/apache2/apache2.conf

mkdir -p /data/www/
cd /data/www/

a2enmod php5
a2enmod rewrite

service apache2 restart


mkdir -p /data/www/
cd /data/www/

curl -sS https://getcomposer.org/installer | php --
mv composer.phar /usr/local/bin/composer


apt-get install postfix


#samba

apt-get install -y samba

smbpasswd -a alequoy


cat >> /etc/samba/smb.conf << EOF

[data]
    path = /data/www
    read only = no
    browseable = yes
    guest ok = no
    browseable = yes
    create mask = 0644
    directory mask = 0755
    force user = www-data
    
EOF


/etc/init.d/smbd restart

chown www-data:www-data -R /data/www





#custom cnf for photobox

 [client]

 #default-character-set = utf8



 [mysqld]
 character-set-client-handshake = FALSE
 character-set-server = utf8
 collation-server = utf8_general_ci



 bind-address        = 0.0.0.0
 external-locking    = off
 skip-name-resolve

 #make a crc32 of ip server
 server-id=2577252028
 #replicate-do-db=PRODUCTION,SHIPPINGENGINE
 replicate-ignore-db=mysql,information_schema,performance_schema


 #innodb
 innodb_buffer_pool_size = 14G


 #for master
 log_bin                 = /var/lib/log_mysql/mariadb-bin
 log_bin_index           = /var/lib/log_mysql/mariadb-bin.index

 max_binlog_size         = 500M
 expire_logs_days        = 15
 binlog-ignore-db    = information_schema,mysql,performance_schema


 #log
 slow_query_log_file     = /var/log/mysql/mariadb-slow.log
 long_query_time = 10


 # * Fine Tuning
 #
 max_connections         = 500
 connect_timeout         = 60
 wait_timeout            = 600
 max_allowed_packet      = 16M
 thread_cache_size       = 128
 sort_buffer_size        = 10M
 bulk_insert_buffer_size = 16M
 tmp_table_size          = 64M
 max_heap_table_size     = 64M


[mysql]
 default-character-set   = utf8
