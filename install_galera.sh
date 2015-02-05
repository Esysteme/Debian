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
apt-get -y install mariadb-galera-server galera rsync



apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

 
echo "deb http://repo.percona.com/apt $release main" > /etc/apt/sources.list.d/percona.list
echo "deb-src http://repo.percona.com/apt $release main" >> /etc/apt/sources.list.d/percona.list
 
apt-get update
 
apt-get -y install xtrabackup percona-toolkit
