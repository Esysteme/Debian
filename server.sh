apt-get install -y git
apt-get install -y vim


#get install version of Debian
#version = lsb_release -c | cut -d ':' -f2 | tr -d '\t'
version = lsb_release -sc

if [ $version -eq "wheezy" ]
then
echo -e "deb http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list
echo -e "deb-src http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list
else
echo -e "deb http://packages.dotdeb.org squeeze-php54 all\n" >> /etc/apt/sources.list
echo -e "deb-src http://packages.dotdeb.org squeeze-php54 all\n" >> /etc/apt/sources.list
fi

cd /root
wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | apt-key add -


apt-get update
apt-get -y upgrade



apt-get install -y apache2
apt-get install -y php5

apt-get install -y mysql-server-5.5
apt-get install -y php5-mysql

apt-get install -y curl
apt-get install -y php5-curl php5-gd php5-mcrypt php5-mysqlnd
