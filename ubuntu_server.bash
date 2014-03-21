#ubuntu server 12.04


apt-get update
apt-get -y upgrade


apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php5


apt-get update

apt-get install -y php5 apache2

#install mariadb
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

add-apt-repository 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu precise main'

apt-get update

apt-get install -y mariadb-server
