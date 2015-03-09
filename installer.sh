#!/bin/bash


# Retrieve Ubuntu version name
VERSION=`lsb_release -c -s`

# Variables for colored output
COLOR_INFO='\e[1;34m'
COLOR_COMMENT='\e[0;33m'
COLOR_NOTICE='\e[1;37m'
COLOR_NONE='\e[0m'

# Intro
echo -e "${COLOR_INFO}"
echo "=============================="
echo "=        HHVM && HACK        ="
echo "=           Nginx            ="
echo "=============================="
echo "= This script is to be used  ="
echo "= to install HHVM and HACK   ="
echo "= With PHP5-FPM FAILOVER     ="
echo "= using apt-get              ="
echo "=============================="
echo -e "${COLOR_NONE}"

# Basic Packages
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Basic Packages             ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get update
sudo apt-get install -y unzip vim git-core curl wget build-essential python-software-properties htop software-properties-common monit

# PPA && Repositories
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= PPA && Repositories        ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:mapnik/boost
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main'
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://dl.hhvm.com/ubuntu $VERSION main | sudo tee /etc/apt/sources.list.d/hhvm.list
sudo apt-get update

# Nginx
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing Nginx           ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y nginx

# PHP5-FPM
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= INSTALLING PHP5-FPM        ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y php5-fpm php5-mysql php5-curl

# HHVM
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing HHVM            ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y hhvm
sudo /usr/share/hhvm/install_fastcgi.sh
sudo update-rc.d hhvm defaults

# Nginx Config
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Nginx Config               ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo rm /etc/nginx/sites-enabled/default
wget -P /etc/nginx/sites-enabled/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/standard
sudo rm /etc/nginx/fastcgi.conf
wget -P /etc/nginx/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/fastcgi.conf
sudo rm /etc/nginx/hhvm.conf
wget -P /etc/nginx/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/hhvm.conf
sudo rm /etc/hhvm/server.ini
wget -P /etc/hhvm/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/server.ini
sudo rm /etc/nginx/nginx.conf
wget -P /etc/nginx/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/nginx.conf
wget -P /etc/monit/conf.d/ https://cdn.rawgit.com/jaanus85/Nginx-HHVM-With-PHP5-FPM-Failover---MariaDB/master/hhvm-monit
sudo sed -i "0,/^worker_processes/ s/^worker_processes .*$/worker_processes `grep -c processor /proc/cpuinfo`;/" /etc/nginx/nginx.conf
sudo /etc/init.d/hhvm restart
sudo /etc/init.d/monit restart
sudo service nginx reload

echo -e "${COLOR_INFO}"
echo "=============================="
echo "= Script Complete            ="
echo "=============================="
echo -e "${COLOR_NONE}"