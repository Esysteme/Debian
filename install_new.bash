sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list


echo -e "deb http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list
echo -e "deb-src http://packages.dotdeb.org wheezy-php55 all\n" >> /etc/apt/sources.list.d/php.list
