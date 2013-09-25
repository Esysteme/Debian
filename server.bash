#you must be root to execute this script
apt-get install -y git
apt-get install -y vim


# install dotdeb 
echo -e "deb http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list
echo -e "deb-src http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list

cd /root
wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | apt-key add -

apt-get update
apt-get -y upgrade

#install screen
apt-get install -y screen

#install LAMP
apt-get install -y apache2
apt-get install -y php5

apt-get install -y mysql-server-5.5

#only to support all application who still use the finction mysql_
apt-get install -y php5-mysql

apt-get install -y curl
apt-get install -y php5-curl php5-gd php5-mcrypt php5-mysqlnd


#install tools
apt-get install -y tree iftop nmap

#install du client NFS
apt-get install -y nfs-common

#install samba (only for dev server)
apt-get install -y samba


mkdir -p /home/www/
cd /home/www/


#specifiy to Alstom
apt-get install mercurial

hg clone http://10.249.8.229/hg/Adel php4_adel
#setup .hg/hgrc





#curl -sS http://www.glial-framework-php.org/installer | php -- --install-dir="/home/www/species" --application="Esysteme/Estrildidae"


echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud-client.list
wget http://download.opensuse.org/repositories/isv:ownCloud:devel/Debian_7.0/Release.key

apt-key add - < Release.key

apt-get update
apt-get install -y owncloud-client


a2enmod rewrite
echo 'syntax on' > ~/.vimrc
