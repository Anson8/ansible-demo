#!/usr/bin/env bash

INSTALL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
ANSIBLE_CFG=$BOOT_PATH/../../depend/config/ansible/ansible.cfg
. $INSTALL_PATH/../common/ip-detect

## TODO 安装Ansible
function ansibleInstall(){
    #su icx-admin
    sudo apt-get update
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
    sudo apt-get  install sshpass

    # ansilbe config
    if [ -f $ANSIBLE_CFG ];then
        sudo  mkdir -p /etc/ansible;sudo cp -rf $ANSIBLE_CFG /etc/ansible/
    fi
}

## TODO 安装Git客户端
function gitInstall(){
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
}
## TODO 给host 添加 principal并生成这台 Host 的 keytab
function addprinc(){
    ip=$1;
    ret=`sethostname $ip`
    host_name=${ret}
    sudo mkdir -p /data/keytab/$host_name
    kadmin.local -q "addprinc -randkey  host/$host_name"
    kadmin.local -q "ktadd -k /data/keytab/$host_name/krb5.keytab host/$host_name"
}
