#!/usr/bin/env bash

BOOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
ANSIBLE_CFG=$BOOT_PATH/../../depend/config/ansible/ansible.cfg

## TODO 安装Ansible
function ansibleInstall(){
    #su icx-admin

    # ansilbe config
    if [ -f $ANSIBLE_CFG ];then
         mkdir -p /etc/ansible;sudo cp -rf $ANSIBLE_CFG /etc/ansible/
    fi

     apt-get update
     apt-get install software-properties-common
     apt-add-repository ppa:ansible/ansible
     apt-get update
     apt-get install ansible
}

## TODO 安装Git客户端
function gitInstall(){
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
}
