#to start this script :
# curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/mariadb10_on_ubuntu12_04.sh | bash
#mkfs.ext4 -j -L varlib -O dir_index -m 2 -J size=400 -b 4096 -R stride=16 /dev/sdb1
# blkid /dev/sdb1
# UUID=5ad079e8-178f-4d11-ba1d-3b1934ac9430 /data        ext4    rw,noatime,nodiratime,nobarrier,data=ordered 0 1

apt-get -y install python-software-properties
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
echo "deb http://mirrors.coreix.net/mariadb/repo/10.0/ubuntu precise main" >> /etc/apt/sources.list.d/mysql.list
echo "deb-src http://mirrors.coreix.net/mariadb/repo/10.0/ubuntu precise main" >> /etc/apt/sources.list.d/mysql.list
apt-get update
apt-get -y install mariadb-server

#get ip and make server-id with crc32

user=`egrep user /etc/mysql/debian.cnf | tr -d ' ' | cut -d '=' -f 2 | head -n1 | tr -d '\n'`
passwd=`egrep password /etc/mysql/debian.cnf | tr -d ' ' | cut -d '=' -f 2 | head -n1 | tr -d '\n'`
ip=`ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | head -n1 | tr -d '\n'`
crc32=`mysql -u $user -p$passwd -e "SELECT CRC32('$ip')"`
id_server=`echo -n $crc32 | cut -d ' ' -f 2 | tr -d '\n'`

/etc/init.d/mysql stop

mkdir -p /data/mysql/log
mkdir -p /data/mysql/backup
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog


cat > /etc/mysql/conf.d/mariadb.cnf << EOF

#custom cnf for photobox

[client]

# default-character-set = utf8

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8
collation-server = utf8_general_ci



bind-address        = 0.0.0.0
external-locking    = off
skip-name-resolve
datadir             = /data/mysql/data

#make a crc32 of ip server
server-id=$id_server

replicate-ignore-db=mysql
replicate-ignore-db=information_schema
replicate-ignore-db=performance_schema
skip-slave-start

#innodb
innodb_buffer_pool_size = 4G
innodb_flush_method     = O_DIRECT


 #for master
log_bin                 = /data/mysql/binlog/mariadb-bin
log_bin_index           = /data/mysql/binlog/mariadb-bin.index

max_binlog_size         = 1G
expire_logs_days        = 15
binlog-ignore-db    = information_schema
binlog-ignore-db    = mysql
binlog-ignore-db    = performance_schema

binlog_format = ROW

#log
slow_query_log_file     = /data/mysql/log/mariadb-slow.log
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


innodb_file_per_table
innodb_autoinc_lock_mode = 2
innodb_flush_log_at_trx_commit = 2
innodb_locks_unsafe_for_binlog = 1

[mysql]
default-character-set   = utf8
    
EOF


cp -pr /var/lib/mysql/* /data/mysql/data

chown mysql:mysql -R /data/mysql

/etc/init.d/mysql start

apt-get -y install libio-socket-inet6-perl libio-socket-ssl-perl libnet-libidn-perl libnet-ssleay-perl libsocket6-perl libterm-readkey-perl

cd /tmp

wget http://www.percona.com/redir/downloads/percona-toolkit/LATEST/deb/percona-toolkit_2.2.7_all.deb && dpkg -i percona-toolkit_2.2.7_all.deb && apt-get -f install && rm percona-toolkit_2.2.7_all.deb
