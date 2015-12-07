#!/usr/bin/env bash

CURRENT=`pwd`
BASENAME=`basename "$CURRENT"`

# install required vagrant plugin to handle reloads during provisioning
vagrant plugin install vagrant-reload

cp -i ./stub/vagrant.yaml.stub "$CURRENT/vagrant.yaml"
cp -i ./stub/after.sh "$CURRENT/after.sh"

printf "\033[0;33mDone.${NC}\n"
