sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list

echo -e "deb http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list
echo -e "deb-src http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list


cd /root
wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | apt-key add -
rm dotdeb.gpg

apt-get -y update
apt-get -y upgrade

apt-get -y install php5


curl -sS https://getcomposer.org/installer | php


mv composer.phar /usr/local/bin/composer
