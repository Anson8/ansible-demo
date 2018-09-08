#!/usr/bin/env bash

OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $OPS_ROOT
## TODO 引入clusterConfig配置文件
. $OPS_ROOT/config/clusterConfig
. $OPS_ROOT/deploy/deploy.sh


## TODO 全流程操作

## TODO 运行Kubernetes服务
# Deploy Kubernetes Service
read -p "Do you want to deploy kubernetes service ?[Y/N/J]:" answer
answer=$(echo $answer)
case $answer in
Y | y)
    echo "Start to deploy kubernetes service..."
    clusterDeploy
    deployTest
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Start to deploy kubernetes service...................Failed! Ret=$ret"
        exit 2
    fi
    echo "Start to deploy kubernetes service...................Successfully!";;
N | n)
    echo "Exit."
    exit 0;;
J | j)
    echo "Skip the deploy kubernetes service.";;
*)
    echo "Input error, please try again."
    exit 2;;
esac

