#!/usr/bin/env bash

INSTALL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
PREREQS_PATH=$INSTALL_PATH/prereqs
TASKS_PATH=$INSTALL_PATH/tasks
## TODO 引入installConfig配置文件
. $INSTALL_PATH/../config/installConfig
. $PREREQS_PATH/dog.sh


## TODO 安装ansible
function clusterInstaller() {
    read -p "Do you want to install ansible?[Y/N]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to install ansible."
        ansibleInstall
        ret=$?
        if [ $ret -ne 0 ]; then
            echo "Start to install ansible...................Failed! Ret=$ret"
            return 1
        fi
        echo "Start to install ansible...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}

## TODO 部署kerberos到所有服务器
function kerberosDeploy() {
    #  deploy kerberos
    nodes=${KERBEROS_NODES[@]};
    read -p "Do you want to deploy kerberos for [$nodes] ?[Y/N]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to deploy kerberos."
        for ip in $nodes;
        do
            echo "ansible-playbook for this $ip"

        done
        ansible-plybook $TASKS_PATH/test.yml -f
        echo "Start to deploy kerberos...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}
