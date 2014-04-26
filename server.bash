
sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list


apt-get install -y curl



#install mariadb10
apt-get -y install python-software-properties

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db

add-apt-repository 'deb http://ftp.igh.cnrs.fr/pub/mariadb/repo/10.0/debian wheezy main'
apt-get update
apt-get install mariadb-server


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

#install du client NFS
apt-get install -y nfs-common

#install samba (only for dev server)
apt-get install -y samba



#samba config

add :
[www]
    path = /home/www
    browseable = yes
    read only = no
    guest ok = no
    create mask = 0644
    directory mask = 0755
    force user = aurelien


useradd aurelien 

smbpasswd -a aurelien






mkdir -p /home/www/
cd /home/www/


curl -sS https://getcomposer.org/installer | php --
mv composer.phar /usr/local/bin/composer



#specifiy to Alstom
apt-get install mercurial

hg clone http://10.249.8.229/hg/Adel php4_adel
#setup .hg/hgrc



################################################################
# install oracle client for php                                #
################################################################

#software required to install clien ocracle
aptitude install php-pear php5-dev build-essential unzip libaio1


#install tools to install RPM package
apt-get install -y alien 


#install clien oracle
#get package from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#you need to be registered and accept license agreement to dl these the following files
alien -i oracle-instantclient12.1-basic-12.1.0.1.0-1.x86_64.rpm
alien -i oracle-instantclient11.2-devel-11.2.0.3.0-1.x86_64.rpm 

#install package manager for php
pecl install oci8

#set configuration for apache and php-cli
mkdir -p /usr/share/php5/oci8
echo "extension=oci8.so" > /usr/share/php5/oci8/oci8.ini
echo "extension=oci8.so" > /etc/php5/apache2/conf.d/20-oci8.ini
echo "extension=oci8.so" > /etc/php5/cli/conf.d/20-readline.ini

#restart apache
service apache2 restart
################################################################


#install server mail
apt-get install postfix
# let default configuration


################################################################
#install webmin
################################################################


apt-get install apt-show-versions libapt-pkg-perl libauthen-pam-perl libio-pty-perl libnet-ssleay-perl
#get webmin
#wget http://prdownloads.sourceforge.net/webadmin/webmin_1.650_all.deb
wget http://optimate.dl.sourceforge.net/project/webadmin/webmin/1.650/webmin_1.650_all.deb

#install package
dpkg -i webmin_1.650_all.deb

#get dependencies
apt-get -f install

#go to https://192.168.24.135:10000/
#login with root and his password
#go to samba onglet

#active all in "User Synchronisation", put all to yes

# click on "Convert Users" and apply

#curl -sS http://www.glial-framework-php.org/installer | php -- --install-dir="/home/www/species" --application="Esysteme/Estrildidae"


echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud-client.list
wget http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/Release.key

apt-key add - < Release.key

apt-get update
apt-get install -y owncloud-client


a2enmod rewrite
echo 'syntax on' > ~/.vimrc
