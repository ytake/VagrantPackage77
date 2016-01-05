#!/usr/bin/env bash

CURRENT=`pwd`
BASENAME=`basename "$CURRENT"`

vagrant plugin install vagrant-reload
vagrant plugin install vagrant-hostsupdater

cp -i ./stub/vagrant.yaml.stub "$CURRENT/vagrant.yaml"
cp -i ./stub/after.sh "$CURRENT/after.sh"

printf "\033[0;33mDone.${NC}\n"
