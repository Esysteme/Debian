#to start this script :
# curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/mariadb10_on_ubuntu12_04.sh | bash


#mkfs.ext4 -j -L varlib -O dir_index -m 2 -J size=400 -b 4096 -R stride=16 /dev/sdb1



apt-get -y install python-software-properties
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
echo "deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu precise main" >> /etc/apt/sources.list.d/mysql.list
apt-get update
apt-get -y install mariadb-server

#set password


mkdir -p /var/lib/mysql_log
chown mysql:mysql /var/lib/mysql_log
mkdir -p /var/lib/mysql_backup
chown mysql:mysql /var/lib/mysql_backup



testvm = `hostname | grep test | wc -l`

if  testvm = 1 
then
 innodb_use_native_aio = 0
 else
 innodb_use_native_aio = 1
 fi;


cat >> /etc/mysql/conf.d/mariadb10.cnf << EOF

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
 innodb_buffer_pool_size = 4G


 #for master
 log_bin                 = /var/lib/mysql_log/mariadb-bin
 log_bin_index           = /var/lib/mysql_log/mariadb-bin.index

 max_binlog_size         = 1G
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
    
EOF


/etc/init.d/mysql restart
