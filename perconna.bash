#curl -sS https://raw.githubusercontent.com/Esysteme/Debian/master/xtrabackup.bash | bash

apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

gpg -a --export CD2EFD2A | apt-key add -

echo 'deb http://repo.percona.com/apt precise main' > /etc/apt/sources.list.d/percona.list
echo 'deb-src http://repo.percona.com/apt precise main' >> /etc/apt/sources.list.d/percona.list

apt-get update
