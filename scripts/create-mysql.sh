#!/usr/bin/env bash

DB=$1;

mysql -u vagrantphp70 -psecret -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
