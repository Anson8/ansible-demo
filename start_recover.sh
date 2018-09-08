#!/usr/bin/env bash

OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $OPS_ROOT
## TODO 引入recoverConfig配置文件
. $OPS_ROOT/config/recoverConfig
. $OPS_ROOT/recover/recover.sh


## TODO K8S集群宕机恢复
# Kubernetes Recover
read -p "Do you want to recover kubernetes $PROJECT_NAME ?[Y/N/J]:" answer
answer=$(echo $answer)
case $answer in
Y | y)
    echo "Start to recover kubernetes..."
    clusterRecover
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Start to recover kubernetes...................Failed! Ret=$ret"
        exit 2
    fi
    echo "Start to recover kubernetes...................Successfully!";;
N | n)
    echo "Exit."
    exit 0;;
J | j)
    echo "Skip the recover kubernetes.";;
*)
    echo "Input error, please try again."
    exit 2;;
esac

