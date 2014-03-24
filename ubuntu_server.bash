#ubuntu server 12.04


apt-get update
apt-get -y upgrade


apt-get install -y python-software-properties
add-apt-repository -y ppa:ondrej/php5


apt-get update

apt-get install -y php5 apache2 php-pear



#install mariadb
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

add-apt-repository 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu precise main'

apt-get update

apt-get install -y mariadb-server


#others


apt-get install -y curl php5-curl php5-gd php5-mcrypt php5-mysqlnd tree iftop nmap php5-xsl



sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone =Europe\/Paris/g' /etc/php5/cli/php.ini

sed -i 's/\/var\/www/\/home\/www/g'  /etc/apache2/sites-enabled/000-default.conf


mkdir -p /home/www/
cd /home/www/

a2enmod php5
a2enmod rewrite

service apache2 restart


mkdir -p /home/www/
cd /home/www/

curl -sS https://getcomposer.org/installer | php --
mv composer.phar /usr/local/bin/composer


apt-get install postfix


#samba

apt-get install -y samba

smbpasswd -a www-data


cat >> /etc/samba/smb.conf << EOF

[www]
    path = /home/www
    read only = no
    browseable = yes
    guest ok = no
    browseable = yes
    create mask = 0644
    directory mask = 0755
    force user = aurelien
    
EOF


/etc/init.d/smbd restart






