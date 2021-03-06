# VagrantPackage77 (Gardening)
for php7.0 and HipHop VM(CentOS7)

*require*
 - VirtualBox

## include
use bento/centos-7.1

 - MySQL 5.6
 - php 7.0.1(remi) / composer
 - HipHop VM 3.9.0
 - node.js 5.*
 - gulp, grunt
 - Redis(default)
 - memcached(default)
 - fluentd
 - elasticsearch (2.1 / port 9200)
 - couchbase 4.1 (port 8091)

## php extension

```
[PHP Modules]
apc
apcu
bcmath
bz2
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
imagick
json
ldap
libxml
mbstring
mcrypt
memcached
msgpack
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
readline
Reflection
session
SimpleXML
sockets
SPL
sqlite3
standard
tokenizer
wddx
xdebug
xml
xmlreader
xmlwriter
xsl
Zend OPcache
zlib

[Zend Modules]
Xdebug
Zend OPcache
```

## Composer global

 - fabpot/php-cs-fixer
 - squizlabs/php_codesniffer
 - phpmd/phpmd

## MySQL

 - user:gardening
 - password:secret

## Xdebug

```
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_port = 9000
xdebug.max_nesting_level = 512
xdebug.idekey = PHPSTORM
```

## fluentd
for laravel, lumen (/etc/td-agent/td-agent.conf)

```
<match local.**>
  type stdout
</match>

# for lumen
<match lumen.**>
  type stdout
</match>
```

## elasticsearch

 - mobz/elasticsearch-head
 - royrusso/elasticsearch-HQ
 - polyfractal/elasticsearch-inquisitor
 - analysis-kuromoji
 - analysis-icu

## couchbase

fo admin console
http://your_configure_ip:8091/

## redis
/etc/redis.conf
 - daemonize yes
 - appendonly yes
