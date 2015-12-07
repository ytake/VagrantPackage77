#!/usr/bin/env bash

yum update

rpm -Uvh http://mirror.oss.ou.edu/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

yum install -y telnet
## to japanese
yum -y install ibus-kkc vlgothic-*
localectl set-locale LANG=ja_JP.UTF-8
source /etc/locale.conf
timedatectl set-timezone Asia/Tokyo

sudo yum groupinstall 'Development tools'
sudo yum -y install vim
sudo yum install -y unzip

# iptables無効
iptables -F
systemctl disable firewalld.service

# SELinux無効
cp /vagrant/rewrites/selinux.conf /etc/selinux/config
setenforce 0

sudo yum install -y git

# openssl
sudo yum install -y openssl-devel
sudo yum install -y readline-devel
sudo yum install -y zlib-devel
sudo yum install -y gcc
sudo yum install -y gcc-c++
sudo yum install -y boost

# node.js install 5.*
curl -sL https://rpm.nodesource.com/setup_5.x | bash -
yum install -y nodejs

# node.js version
node -v
npm --version

sudo npm install -g jshint
sudo npm install -g grunt
sudo npm install -g gulp

# for memory swap
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# for freetds
yum install -y freetds

echo "
export PS1=\"\[\e[1;32m\][\u@\h:\w]\$\[\e[00m\] \"
" >> /home/vagrant/.bash_profile

# install java
sudo yum install -y java
java -version
export JAVA_HOME=/usr/bin
