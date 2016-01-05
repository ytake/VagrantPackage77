#!/usr/bin/env bash

block="
<VirtualHost *:80>
    DocumentRoot \"$2\"
    ServerName $1
    ErrorLog "/var/log/httpd/$1-error_log"
    <IfModule mod_fastcgi.c>
        Alias /fcgi-bin /etc/httpd/fcgi-bin
        <Directory /etc/httpd/fcgi-bin>
            Options None
            AllowOverride None
            Require all granted
        </Directory>
        FastCGIExternalServer /etc/httpd/fcgi-bin -socket /var/run/php7-fpm.sock
        Action application/x-httpd-php-fastcgi /fcgi-bin/php
        <FilesMatch \".+\.php$\">
            SetHandler application/x-httpd-php-fastcgi
        </FilesMatch>
    </IfModule>
</VirtualHost>
"

echo "$block" > "/etc/httpd/conf.d/$1.conf"
