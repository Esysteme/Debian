# curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/install_galera.sh | bash

apt-get update
apt-get -y upgrade



apt-get -y install python-software-properties
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
 
release=`lsb_release -rs`


echo "Version : "$release

if [ "$release" = "14.04" ]
then
echo "Version : "$release
 echo "deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu trusty main" > /etc/apt/sources.list.d/mysql.list
 echo "deb-src http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu trusty main" >> /etc/apt/sources.list.d/mysql.list
elif [ $release = "12.04" ]
then
echo "Version : "$release
 echo "deb http://mirrors.coreix.net/mariadb/repo/10.0/ubuntu precise main" > /etc/apt/sources.list.d/mysql.list
 echo "deb-src http://mirrors.coreix.net/mariadb/repo/10.0/ubuntu precise main" >> /etc/apt/sources.list.d/mysql.list
else
echo "version not supported"
exit 1
fi
 
apt-get update
apt-get -y install mariadb-galera-server galera rsync
