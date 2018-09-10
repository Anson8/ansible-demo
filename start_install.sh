#!/usr/bin/env bash

OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $OPS_ROOT
## TODO 引入installConfig配置文件
. $OPS_ROOT/config/installConfig
. $OPS_ROOT/install/install.sh

## TODO 服务器各种组件安装
options=("ansible" "test" "sshaddkey" "hostname" "kerberos" )
if [ $# -ne 1 ];then
	echo "Input invalid! Support: ansible | test | sshaddkey | hostname | kerberos"
	exit 1
fi

if [ $1 = "help" ];then
	echo "start_install.sh args: ansible | test | sshaddkey | hostname | kerberos"
	exit 0
fi

read -p "Are you sure to install $1?[Y/N]:" answer
answer=$(echo $answer)
case $answer in
Y | y)
    echo "Start to deploy $1.."
    ;;
N | n)
    echo "Exit."
    exit 0;;
*)
    echo "Input error, please try again."
    exit 1;;
esac

# 单点安装
if [ $# -ge 1 ]; then
    case $1 in
    "ansible")
        clusterInstaller
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to install ansible...................Failed! Ret=$ret"
            exit 2
        fi
        echo "Start to install ansible...................Successfully!"
        exit 0;;
    "test")
        testAnsible
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to Test ansible...................Failed! Ret=$ret"
            exit 2
        fi
        echo "Start to Test ansible...................Successfully!"
        exit 0;;
    "sshaddkey")
        sshAddkey
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to deploy sshAddkey...................Failed! Ret=$ret"
            exit 2
        fi
        echo "Start to deploy sshAddkey...................Successfully!"
        exit 0;;
    "hostname")
        hostnameDeploy
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to deploy hostname...................Failed! Ret=$ret"
            exit 3
        fi
        echo "Start to deploy hostname...................Successfully!"
        exit 0;;
    "kerberos")
        kerberosDeploy
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to deploy kerberos...................Failed! Ret=$ret"
            exit 3
        fi
        echo "Start to deploy kerberos...................Successfully!"
        exit 0;;
    esac
fi


