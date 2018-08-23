#!/usr/bin/env bash

K8S_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $K8S_ROOT
## TODO 引入clusterConfig配置文件和dog.sh
. $K8S_ROOT/config/clusterConfig
. $K8S_ROOT/boot/dog.sh

## TODO 全流程安装
## TODO 安装ansible

read -p "Are you sure to install ansible for this cluster ?[Y/N/J]" answer
answer =$(echo $answer)
case $answer in
Y | y)
    echo "Start install ansible the machines."
    ansibleInstall
    exit 0;;
N | n)
    echo "Exit."
    exit 0;;
J | j)
    echo "Skip the installation of the ansible.";;
*)
 echo "Input error,please try again."
 exit 1;;
esac

read -p "Are you sure to install ansible for this [ ${K8S_WDOGGY[@]} ] ?[Y/N]" answer
answer =$(echo $answer)
case $answer in
Y | y)
    echo "Start install ansible the machines."

    exit 0;;
N | n)
    echo "Exit."
    exit 0;;
*)
 echo "Input error,please try again."
 exit 2;;
esac