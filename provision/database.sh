#!/usr/bin/env bash

yum remove mysql*

yum -y remove mariadb-libs

wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
rpm -Uvh mysql-community-release-el6-5.noarch.rpm
yum install -y mysql mysql-devel mysql-server mysql-libs

# for backup ini
cp /etc/my.cnf /etc/my.cnf.backup

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/my.cnf

/bin/systemctl enable mysqld.service
/bin/systemctl start mysqld.service

mysql --user="root" -e "set password = password('secret');"
mysql --user="root" --password="secret" -e "DROP USER ''@'localhost';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "CREATE USER 'vagrantphp70'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'vagrantphp70'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'vagrantphp70'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="secret" -e "CREATE DATABASE vagrantphp70;"
mysql --user="root" --password="secret" -e  "set password for 'vagrantphp70'@'localhost' = password('secret');"

/bin/systemctl restart mysqld.service

# memcached
sudo yum install -y memcached memcached-devel

/bin/systemctl enable memcached
/bin/systemctl restart memcached

# redis
sudo yum --enablerepo=remi,epel install -y redis

sed -i "s/daemonize no/daemonize yes/" /etc/redis.conf
sed -i "s/appendonly no/appendonly yes/" /etc/redis.conf

/bin/systemctl enable redis
/bin/systemctl start redis

rm -rf mysql-community-release-el6-5.noarch.rpm

# install fluentd
sudo curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

echo " 
## match tag=local.** (for laravel log develop)
<match local.**>
  type stdout
</match>

# for lumen
<match lumen.**>
  type stdout
</match>
" >> /etc/td-agent/td-agent.conf

/bin/systemctl start td-agent.service
/bin/systemctl enable td-agent.service

# for elasticsearch
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF

sudo yum install -y elasticsearch

sed -i "s/#http.port: 9200/http.port: 9200/" /etc/elasticsearch/elasticsearch.yml

sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
sudo /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
sudo /usr/share/elasticsearch/bin/plugin install polyfractal/elasticsearch-inquisitor
sudo /usr/share/elasticsearch/bin/plugin install analysis-kuromoji
sudo /usr/share/elasticsearch/bin/plugin install analysis-icu

/bin/systemctl start elasticsearch.service
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service

# install couchbase
wget http://packages.couchbase.com/releases/4.1.0-dp/couchbase-server-4.1.0-dp-centos7.x86_64.rpm
rpm -ivh couchbase-server-4.1.0-dp-centos7.x86_64.rpm

# http://your_configure_ip:8091/
/bin/systemctl enable couchbase-server
/bin/systemctl start couchbase-server

rm -rf couchbase-server-4.1.0-dp-centos7.x86_64.rpm

#install mongodb
cat > /etc/yum.repos.d/mongodb-org-3.2.repo << EOF
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
EOF

sudo yum install -y mongodb-org
/bin/systemctl enable mongod
/bin/systemctl start mongod
