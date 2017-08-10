#debian
#mariadb 10.2

VERSION='10.1'
CLUSTER_NAME='Esysteme'
CLUSTER_MEMBER=''
PHP='false'
PASSWORD=''
SSD='false'
SPIDER='false'
CLUSTER='OFF'
PURGE='false'

while getopts 'hp:n:m:xv:sgc' flag; do
  case "${flag}" in
    h) 
        echo "auto install mariadb"
        echo "example : ./mariadb_10.1.sh -p 'my_password' -c 'Esysteme' -m '127.0.0.1,127.0.0.2,127.0.0.3'"
        echo " "
        echo "options:"
        echo "-p PASSWORD             specify root password for mariadb"
        echo "-n name                 specify the name of galera cluster"
        echo "-m ip1,ip2,ip3          specify the list of member of cluster"
        echo "-x                      Install last version of PHP"
        echo "-v 10.1                 specify the version of MariaDB/MySQL"
        echo "-s                      specify the hard drive are SSD"
        echo "-g                      specify to activate and make good set up for Spider"
        echo "-c                      set galera cluster ON"
        echo "-u                      [WARNING] purge previous version of MySQL / MariaDB"
        
        exit 0
    ;;
    p) PASSWORD="${OPTARG}" ;;
    n) CLUSTER_NAME="${OPTARG}" ;;
    m) CLUSTER_MEMBER="${OPTARG}" ;;
    x) PHP='true' ;;
    v) VERSION="${OPTARG}" ;;
    s) SSD='true';;
    g) SPIDER='true';;
    c) CLUSTER='ON';;
    u) PURGE='true';;
    *) error "Unexpected option ${flag}" ;;
  esac
done



function purge {
 rm -rvf /etc/mysql/*
 apt-get -qq -y purge $(dpkg -l | grep mariadb | cut -d ' ' -f 3)
 apt-get -qq -y purge $(dpkg -l | grep mysql | cut -d ' ' -f 3)
 apt-get autoremove
 apt-get clean
}

if [ ${purge} == "true" ]
then;
  purge
fi;


function mytest {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
        exit 1;
    fi
    return $status
}

if [ -z ${VERSION} ]; 
then 
  VERSION='10.1'
fi

if [ -z ${PASSWORD} ]; 
then 
  echo "option -p required (password)"
  echo "for help -h"
  exit 0;
fi

echo "PASSWORD = $PASSWORD"
echo "CLUSTER_NAME = $CLUSTER_NAME"
echo "CLUSTER_MEMBER = $CLUSTER_MEMBER"
echo "VERSION = $VERSION"


OS=`lsb_release -cs`

DISTRIB=`lsb_release -si`
DISTRIB=`echo "$DISTRIB" | tr '[:upper:]' '[:lower:]'`

case "$OS" in
    "jessie")      ;;
    "stretch")     ;;
    "xenial")      ;;
    *)
        echo "This version is not supported : '$OS'"
        exit 1;
     ;; 
esac


case "$DISTRIB" in
    "debian")
        ;;
        
    "ubuntu")
        ;;

    *)
        echo "This distribution GNU/Linux is not supported : '$DISTRIB'"
        exit 1;
        ;; 
esac


echo "DISTRIB = $DISTRIB"
echo "OS = $OS"

#import mariadb key

echo "Import public key"
mytest wget -q -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF1656F24C74CD1D8" | apt-key add -
mytest wget -q -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xcbcb082a1bb943db" | apt-key add -


#to get missing keys
apt-get -qq update 2> /tmp/keymissing; 
for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); 
do 
  echo -e "\nProcessing key: $key"; 
  wget -q -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=$key" | apt-key add -
  #gpg --keyserver subkeys.pgp.net --recv $key && gpg --export --armor $key | apt-key add -; 
done


cat > /etc/apt/sources.list.d/mariadb.list << EOF
# MariaDB $VERSION repository list - created 2017-08-10 22:02 UTC
# http://downloads.mariadb.org/mariadb/repositories/
deb [arch=i386,amd64] http://ftp.igh.cnrs.fr/pub/mariadb/repo/${VERSION}/${DISTRIB} ${OS} main
deb-src http://ftp.igh.cnrs.fr/pub/mariadb/repo/${VERSION}/${DISTRIB} ${OS} main
EOF




mytest apt-get -qq update
mytest apt-get -qq -y upgrade

mytest apt-get -qq install -y software-properties-common


export DEBIAN_FRONTEND=noninteractive
#debconf-set-selections <<< "mariadb-server-${VERSION} mysql-server/root_password password 'PASSWORD'"
#debconf-set-selections <<< "mariadb-server-${VERSION} mysql-server/root_password_again password 'PASSWORD'"

mytest apt-get -qq -y install mariadb-server-${VERSION}





mytest mysql -e "GRANT ALL ON *.* TO dba@'%' IDENTIFIED BY '$PASSWORD'; "

IFS=',' read -r -a array <<< "$CLUSTER_MEMBER"

for server in "${array[@]}"
do
    mysql -e "GRANT ALL ON *.* TO sst@'$server' IDENTIFIED BY 'QSEDWGRg133';" 
done


mysql -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY '$PASSWORD';flush privileges; "



echo -e "[client]
user=root
password='$PASSWORD'" > /root/.my.cnf

version=`mysql -u root -p$PASSWORD -se "SELECT VERSION()" | sed -n 1p | grep -Po '10\.([0-9]{1,2})'`

case "$VERSION" in
    "10.1")
        apt-get -qq -y install mariadb-plugin-mroonga mariadb-plugin-oqgraph mariadb-plugin-spider 
        apt-get -qq -y install mariadb-plugin-tokudb
        ;;
    "10.2")
        apt-get -qq -y install mariadb-plugin-mroonga mariadb-plugin-oqgraph mariadb-plugin-spider 
        apt-get -qq -y install mariadb-plugin-myrocks
        ;;
    "10.3")
        apt-get -qq -y install mariadb-plugin-mroonga mariadb-plugin-oqgraph mariadb-plugin-spider 
        apt-get -qq -y install mariadb-plugin-myrocks
        ;;

    *)
        echo "This version is not supported : '$VERSION'"
        ;; 
esac

ip=`ifconfig | grep -Eo 'inet (a[d]{1,2}r:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
crc32=`mysql -u root -p$PASSWORD -e "SELECT CRC32('$ip')"`
id_server=`echo -n $crc32 | cut -d ' ' -f 2 | tr -d '\n'`

hostname=`hostname`

innodb_buffer_pool_size='512M'
memtotal=`grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc`

new_buffer=`echo "$memtotal * 0.75" | bc -l`


if [ memtotal > 4 ];then
  innodb_buffer_pool_size=`echo $new_buffer | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}'`
fi

/etc/init.d/mysql stop

mkdir -p /data/mysql/log
mkdir -p /data/mysql/backup
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog

cp -pr /var/lib/mysql/* /data/mysql/data

chown mysql:mysql -R /data/mysql

# install xtrabackup
wget https://repo.percona.com/apt/percona-release_0.1-4.${os}_all.deb
dpkg -i percona-release_0.1-4.${os}_all.deb

apt-get -qq update
apt-get -qq install -y percona-xtrabackup-24

cat > /etc/mysql/conf.d/99-esysteme.cnf << EOF

# MariaDB database server configuration file.
#
# You can copy this file to one of:
# - "/etc/mysql/my.cnf" to set global options,
# - "~/.my.cnf" to set user-specific options.
# 
# One can use all long options that the program supports.
# Run program with --help to get a list of available options and with
# --print-defaults to see which it would actually understand and use.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

# This will be passed to all mysql clients
# It has been reported that passwords should be enclosed with ticks/quotes
# escpecially if they contain "#" chars...
# Remember to edit /etc/mysql/debian.cnf when changing the socket location.
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.sock

# Here is entries for some specific programs
# The following values assume you have at least 32M ram

# This was formally known as [safe_mysqld]. Both versions are currently parsed.
[mysqld_safe]
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]
#
# * Basic Settings
#

#innodb_force_recovery = 1

user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
basedir         = /usr
datadir         = /data/mysql/data
tmpdir          = /tmp
lc_messages_dir = /usr/share/mysql
lc_messages     = en_US

plugin_dir = /usr/lib/mysql/plugin/

skip-name-resolve

#logs
error_log=/data/mysql/log/error.log


#
# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address           = 127.0.0.1
#
# * Fine Tuning
#
max_connections         = 100
connect_timeout         = 5
wait_timeout            = 600
max_allowed_packet      = 16M
thread_cache_size       = 128
sort_buffer_size        = 4M
bulk_insert_buffer_size = 16M
tmp_table_size          = 256M
max_heap_table_size     = 256M
#
# * MyISAM
#
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched. On error, make copy and try a repair.
myisam_recover_options = BACKUP
key_buffer_size         = 128M
open-files-limit       = 2000
table_open_cache        = 400
myisam_sort_buffer_size = 512M
concurrent_insert       = 2
read_buffer_size        = 2M
read_rnd_buffer_size    = 1M
key_cache_segments      = 64

#mroonga.replicate_rewrite_db="repl->repl2"
#mroonga.replicate_do_table="repl2.article2"

#
# * Query Cache Configuration
#
# Cache only tiny result sets, so we can fit more in the query cache.
query_cache_limit               = 128K
query_cache_size                = 0
# for more write intensive setups, set to DEMAND or OFF
query_cache_type                = OFF
#
# * Logging and Replication
#
# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# As of 5.1 you can enable the log at runtime!
#general_log_file        = /data/mysql/log/general.log
#general_log             = 1
#
# Error logging goes to syslog due to /etc/mysql/conf.d/mysqld_safe_syslog.cnf.
#
# we do want to know about network errors and such
log_warnings            = 2
#
# Enable the slow query log to see queries with especially long duration
#slow_query_log[={0|1}]
slow_query_log_file     = /var/log/mysql/mariadb-slow.log
long_query_time = 1
#log_slow_rate_limit    = 1000
log_slow_verbosity      = query_plan
log_slave_updates       = 1
#log-queries-not-using-indexes
#log_slow_admin_statements
#
# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
server-id               = $id_server

report_host            = $hostname

#auto_increment_increment = 2
#auto_increment_offset  = 1
log_bin                        = /data/mysql/binlog/mariadb-bin
log_bin_index          = /data/mysql/binlog/mariadb-bin.index
# not fab for performance, but safer
#sync_binlog            = 1
expire_logs_days        = 10
max_binlog_size         = 1G

# slaves
#relay_log              = /var/log/mysql/relay-bin
#relay_log_index        = /var/log/mysql/relay-bin.index
#relay_log_info_file    = /var/log/mysql/relay-bin.info

log_slave_updates

#read_only

#
# If applications support it, this stricter sql_mode prevents some
# mistakes like inserting invalid dates etc.
#sql_mode               = NO_ENGINE_SUBSTITUTION,TRADITIONAL
#
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
default_storage_engine  = InnoDB
# you can't just change log file size, requires special procedure
innodb_log_file_size    = 2G
innodb_buffer_pool_size = ${innodb_buffer_pool_size}G
innodb_log_buffer_size  = 8M
innodb_file_per_table   = 1
innodb_open_files       = 400
innodb_io_capacity      = 2000
innodb_flush_method     = O_DIRECT
#
# * Security Features

#
# Read the manual, too, if you want chroot!
# chroot = /var/lib/mysql/
#
# For generating SSL certificates I recommend the OpenSSL GUI "tinyca".
#
# ssl-ca=/etc/mysql/cacert.pem
# ssl-cert=/etc/mysql/server-cert.pem
# ssl-key=/etc/mysql/server-key.pem

#
# * Galera-related settings
event-scheduler = ON
#
[galera]
# Mandatory settings
wsrep_on=$CLUSTER
wsrep_cluster_name='$CLUSTER_NAME'
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_address=gcomm://$CLUSTER_MEMBER
wsrep_node_address=$ip
wsrep_node_name=$hostname
wsrep_gtid_mode=ON

wsrep_sst_method = xtrabackup-v2
wsrep_sst_auth = 'sst:QSEDWGRg133'

binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2

#
# Allow server to accept connections on all interfaces.
#
bind-address=0.0.0.0
#
# Optional setting
wsrep_slave_threads=4
innodb_flush_log_at_trx_commit=2

[mysqldump]
quick
quote-names
max_allowed_packet      = 16M

[mysql]
#no-auto-rehash # faster start of mysql but no tab completion

[isamchk]
key_buffer              = 16M


EOF




/etc/init.d/mysql start

#vim 

apt-get -qq -y install vim

echo -e "syntax on" > /root/.vimrc


/* others */

apt-get -qq install -y tree locate screen iftop htop curl git unzip atop nmap




#install php 


if [ "$PHP" = "true" ]
then
  echo "Installation of PHP"
  
  apt-get -qq install -y apache2



  case "$os" in
      "stretch")

          ;;
      "jessie")
                  echo ' ' >> /etc/apt/sources.list
                  echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list
                  echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list

                  wget http://www.dotdeb.org/dotdeb.gpg
                  apt-key add dotdeb.gpg

                  rm dotdeb.gpg

          ;;


      *)
          echo "This version is not supported : '$os'"
          ;; 
  esac


  apt-get -qq update

  apt-get -qq install -y php7.0 php7.0-mysql php7.0-json php7.0-gd php7.0-geoip php7.0-dba php7.0-curl  php7.0-cli php7.0-common php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-memcached php7.0-xml


  sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php/7.0/apache2/php.ini
  sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php/7.0/cli/php.ini
  sed -i 's/\/var\/www\/html/\/data\/www/g'  /etc/apache2/sites-enabled/000-default.conf
  sed -i 's/\/var\/www/\/data\/www/g'  /etc/apache2/apache2.conf

  mkdir -p /data/www/
  cd /data/www/

  apt-get -q -y install libapache2-mod-php7.0

  a2enmod php7.0
  a2enmod rewrite

  service apache2 restart


  mkdir -p /data/www/
  cd /data/www/

  curl -sS https://getcomposer.org/installer | php --
  mv composer.phar /usr/local/bin/composer
fi
