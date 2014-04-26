sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list


apt-get install -y curl

# curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/server_prod.bash | bash


#install mariadb10
apt-get -y install python-software-properties

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

add-apt-repository 'deb http://ftp.igh.cnrs.fr/pub/mariadb/repo/10.0/debian wheezy main'
apt-get -y update
apt-get -y install mariadb-server


#you must be root to execute this script
apt-get install -y git
apt-get install -y vim


# install dotdeb 
echo -e "deb http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list
echo -e "deb-src http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list

cd /root
wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | apt-key add -

apt-get update
apt-get -y upgrade

#install screen
apt-get install -y screen

#install LAMP
apt-get install -y apache2 php5 php-pear
apt-get install -y curl php5-curl php5-gd php5-mcrypt php5-mysqlnd tree iftop nmap php5-xsl libapache2-mod-suphp libapache2-mod-php5


apt-get remove apache2-mpm-worker

sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/cli/php.ini

sed -i 's/\/var\/www/\/home\/www/g'  /etc/apache2/sites-enabled/000-default


a2enmod php5
a2enmod rewrite

service apache2 restart





mkdir -p /home/www/
cd /home/www/


curl -sS https://getcomposer.org/installer | php --
mv composer.phar /usr/local/bin/composer

composer create-project -sdev glial/new-project glial


glial install index


