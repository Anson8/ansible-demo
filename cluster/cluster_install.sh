#!/usr/bin/env bash

CLUSTER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
PREREQS_PATH=$CLUSTER_PATH/prereqs
## TODO 引入clusterConfig配置文件
. $CLUSTER_PATH/../config/clusterConfig
. $PREREQS_PATH/dog.sh


function clusterInstaller() {
    # prereqs install
    read -p "Do you want to install ansible?[Y/N/J]:" answer
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
    J | j)
        echo "Skip the installation of the ansible.";;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}
