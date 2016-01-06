#!/usr/bin/env bash

mkdir /etc/httpd/ssl 2>/dev/null

PATH_SSL="/etc/httpd/ssl"
PATH_KEY="${PATH_SSL}/${1}.key"
PATH_CSR="${PATH_SSL}/${1}.csr"
PATH_CRT="${PATH_SSL}/${1}.crt"

if [ ! -f $PATH_KEY ] || [ ! -f $PATH_CSR ] || [ ! -f $PATH_CRT ]
then
  openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
  openssl req -new -key "$PATH_KEY" -out "$PATH_CSR" -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in "$PATH_CSR" -signkey "$PATH_KEY" -out "$PATH_CRT" 2>/dev/null
fi

block="
<VirtualHost *:80>
    DocumentRoot \"$2\"
    ServerName $1
    ErrorLog "/var/log/httpd/$1-error_log"
    <Directory $2>
        AllowOverride All
        Require all granted
    </Directory>
    <IfModule mod_fastcgi.c>
        Alias /hhvm /etc/httpd/hhvm
        Action hhvm-php-extension /hhvm virtual
        Action hhvm-hack-extension /hhvm virtual
        FastCgiExternalServer /hhvm -host 127.0.0.1:9000 -pass-header Authorization -idle-timeout 300
        <FilesMatch \.php$>
            SetHandler hhvm-php-extension
        </FilesMatch>
        <FilesMatch \.hh$>
            SetHandler hhvm-hack-extension
        </FilesMatch>
        <Directory /etc/httpd/hhvm>
            Options None
            AllowOverride None
            Require all granted
        </Directory>
    </IfModule>
</VirtualHost>
<VirtualHost *:443>
    DocumentRoot \"$2\"
    ServerName $1
    ErrorLog "/var/log/httpd/$1-error_log"

    SSLEngine on
    SSLCertificateFile $PATH_CRT
    SSLCertificateKeyFile $PATH_KEY

    <Directory $2>
        AllowOverride All
        Require all granted
    </Directory>
    <IfModule mod_fastcgi.c>
        Alias /hhvm /etc/httpd/hhvm
        Action hhvm-php-extension /hhvm virtual
        Action hhvm-hack-extension /hhvm virtual
        FastCgiExternalServer /hhvm -host 127.0.0.1:9000 -pass-header Authorization -idle-timeout 300
        <FilesMatch \.php$>
            SetHandler hhvm-php-extension
        </FilesMatch>
        <FilesMatch \.hh$>
            SetHandler hhvm-hack-extension
        </FilesMatch>
        <Directory /etc/httpd/hhvm>
            Options None
            AllowOverride None
            Require all granted
        </Directory>
    </IfModule>
</VirtualHost>
"

echo "$block" > "/etc/httpd/conf.d/$1.conf"
