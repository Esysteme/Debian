
apt-get -y install python-software-properties

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db


echo "deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu precise main" >> /etc/apt/sources.list.d/mysql.list


apt-get update

apt-get -y install mariadb-server

#set password
