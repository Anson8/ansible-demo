#!/usr/bin/env bash

## TODO 系统环境安装
BOOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"

## TODO 安装Ansible
function ansibleInstall(){
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
}

## TODO 安装Git客户端
function gitInstall(){
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
}


