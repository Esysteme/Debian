# curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/install_galera.sh | bash

apt-get update
apt-get -y upgrade

apt-get -y install python-software-properties
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
 
release=`lsb_release -cs`

echo "Version : "$release

echo "deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu $release main" > /etc/apt/sources.list.d/mysql.list
echo "deb-src http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu $release main" >> /etc/apt/sources.list.d/mysql.list
apt-get update
apt-get -y install mariadb-galera-server galera-3 rsync pwgen netcat-openbsd socat



apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb http://repo.percona.com/apt $release main" > /etc/apt/sources.list.d/percona.list
echo "deb-src http://repo.percona.com/apt $release main" >> /etc/apt/sources.list.d/percona.list
apt-get update
apt-get -y install xtrabackup percona-toolkit



apt-get install -y psmisc rsync libaio1 netcat netcat-openbsd lsb-release socat iproute htop tree screen vim curl cmake libncurses5-dev bison make gcc build-essential pv bc qpress socat netcat-traditional netcat netcat-openbsd iftop


user=`egrep user /etc/mysql/debian.cnf | tr -d ' ' | cut -d '=' -f 2 | head -n1 | tr -d '\n'`
passwd=`egrep password /etc/mysql/debian.cnf | tr -d ' ' | cut -d '=' -f 2 | head -n1 | tr -d '\n'`
ip=`ifconfig eth0 | grep "inet ad" | awk -F: '{print $2}' | awk '{print $1}' | head -n1 | tr -d '\n'`
crc32=`mysql -u $user -p$passwd -e "SELECT CRC32('$ip')"`
SERVERID=`echo -n $crc32 | cut -d ' ' -f 2 | tr -d '\n'`
 
wsrep_cluster_name='xtrabackup_test'
wsrep_cluster_address="gcomm://10.10.16.211,10.10.16.212,10.10.16.213"
wsrep_node_address=$ip

cat > /etc/mysql/conf.d/galera.cnf << EOF
 
[client]
 
#default-character-set=utf8
loose-default-character-set=utf8
 
[mysqld]
#mysql settings


auto_increment_increment=1
auto_increment_offset=3
concurrent_insert = AUTO

log-slave-updates=1
default-storage-engine=innodb
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0
 
server-id=$SERVERID
 
skip-slave-start
explicit_defaults_for_timestamp = 1
 
 
datadir = /data/mysql/data
#galera settings
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_name="$wsrep_cluster_name"
wsrep_node_address="$wsrep_cluster_name"
wsrep_cluster_address="$wsrep_cluster_address"
 


#wsrep_sst_method=rsync


wsrep_slave_threads = 4
wsrep_sst_method = xtrabackup-v2
wsrep_sst_auth = "xtrabackup:cw1IOXK7TpZHyY0Y8uqY9K9hLakR4j"
wsrep_provider_options="gcache.size=2G"

wsrep_replicate_myisam= ON

 
 
#innoDB
innodb_file_per_table
connect_timeout         = 60
wait_timeout            = 3600
innodb_buffer_pool_size = 1G
innodb_flush_method     = O_DIRECT
 
innodb_log_file_size = 64M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 2
innodb_autoinc_lock_mode=2

innodb_data_file_path= "ibdata1:100M:autoextend"
 
#for master
 
binlog_format=ROW
log_bin                 = /data/mysql/binlog/mariadb-bin
log_bin_index           = /data/mysql/binlog/mariadb-bin.index
 
max_binlog_size         = 1G
expire_logs_days        = 10
 
 
sync_binlog=0
skip_name_resolve=ON
memlock=0
sysdate_is_now=1
max_connections=200
thread_cache_size=512
query_cache_type = 0
query_cache_size = 0
table_open_cache=1024
lower_case_table_names=0


sort_buffer_size        = 10M
bulk_insert_buffer_size = 16M
tmp_table_size          = 64M
max_heap_table_size     = 64M
 
#log
slow_query_log_file     = /data/mysql/log/mariadb-slow.log
long_query_time = 1
 
 
performance_schema = 'ON'
open_files_limit =  65535
event_scheduler = on
 
 
collation-server = utf8_unicode_ci
character-set-server = utf8
init-connect = 'SET NAMES utf8'
 
 
max_connections = 500
open_files_limit =  65535
 
log-error=/data/mysql/log/error.log
log_warnings=2

[mysql]
default-character-set=utf8

[xtrabackup]
compress
compact
parallel = 2
compress_threads = 2
rebuild_threads = 2

[sst]
streamfmt=xbstream


EOF

mysql -pzeb33tln -e "GRANT ALL PRIVILEGES ON *.* TO 'xtrabackup'@'localhost' IDENTIFIED BY 'cw1IOXK7TpZHyY0Y8uqY9K9hLakR4j' WITH GRANT OPTION; flush privileges;"
mysql -pzeb33tln -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.%' IDENTIFIED BY '' WITH GRANT OPTION; flush privileges;"
mysql -pzeb33tln -e "GRANT ALL PRIVILEGES ON *.* TO 'dba'@'%' IDENTIFIED BY '' WITH GRANT OPTION; flush privileges;"
mysql -pzeb33tln -e "GRANT ALL PRIVILEGES ON *.* TO 'pmacontrol'@'%' IDENTIFIED BY '' WITH GRANT OPTION; flush privileges;"
mysql -pzeb33tln -e "GRANT ALL PRIVILEGES ON *.* TO 'mysql'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION; flush privileges;"


/etc/init.d/mysql stop
 
mkdir -p /data/mysql/log
mkdir -p /data/mysql/backup
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog
cp -pr /var/lib/mysql/* /data/mysql/data
chown mysql:mysql -R /data/mysql


#service mysql start --wsrep-new-cluster


