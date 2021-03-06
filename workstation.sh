cd /root
wget http://download.netbeans.org/netbeans/7.3.1/final/bundles/netbeans-7.3.1-php-linux.sh
sh netbeans-7.3.1-php-linux.sh

apt-get install -y xbmc



echo "deb http://ftp.u-picardie.fr/mirror/debian/ wheezy main contrib" >> /etc/apt/sources.list
echo "deb-src http://ftp.u-picardie.fr/mirror/debian/ wheezy main contrib" >> /etc/apt/sources.list

apt-get update


#installation des polices d'écran
apt-get install -y ttf-mscorefonts-installer
apt-get install -y gsfonts gsfonts-other gsfonts-x11 msttcorefonts t1-xfree86-nonfree ttf-alee ttf-ancient-fonts ttf-arabeyes ttf-arphic-bkai00mp ttf-arphic-bsmi00lp ttf-arphic-gbsn00lp ttf-arphic-gkai00mp ttf-atarismall ttf-bpg-georgian-fonts ttf-dustin ttf-f500 ttf-sil-gentium ttf-georgewilliams ttf-isabella ttf-larabie-deco ttf-larabie-straight ttf-larabie-uncommon ttf-sjfonts ttf-staypuft ttf-summersby ttf-ubuntu-title ttf-xfree86-nonfree xfonts-intl-european xfonts-jmk xfonts-terminus



#install skype
wget -O skype-install.deb http://www.skype.com/go/getskype-linux-deb

dpkg --add-architecture i386
apt-get update

dpkg -i skype-install.deb
apt-get -f -y install


apt-get install -y curl


#pidgin
apt-get install -y pidgin


cd
wget -q http://prdownloads.sourceforge.net/webadmin/
dpkg -i webmin_1.630_all.deb



#for Geforce 640 GT
echo "deb http://http.debian.net/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list

aptitude update
aptitude -r install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') nvidia-kernel-dkms

mkdir /etc/X11/xorg.conf.d
echo -e 'Section "Device"\n\tIdentifier "My GPU"\n\tDriver "nvidia"\nEndSection' > /etc/X11/xorg.conf.d/20-nvidia.conf

reboot
