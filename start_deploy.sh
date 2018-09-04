#!/usr/bin/env bash

OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $OPS_ROOT
## TODO 引入clusterConfig配置文件
. $OPS_ROOT/config/clusterConfig
. $OPS_ROOT/cluster/cluster_deploy.sh
. $OPS_ROOT/cluster/cluster_install.sh
. $OPS_ROOT/cluster/cluster_recover.sh


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

## TODO 安装集群组件
# Service Cluser Install
read -p "Do you want to install prereqs ?[Y/N/J]:" answer
answer=$(echo $answer)
case $answer in
Y | y)
    echo "Start to install prepare..."
    clusterInstaller
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Start to install prepare...................Failed! Ret=$ret"
        exit 2
    fi
    echo "Start to install prepare...................Successfully!";;
N | n)
    echo "Exit."
    exit 0;;
J | j)
    echo "Skip the installation of the prepare.";;
*)
    echo "Input error, please try again."
    exit 2;;
esac

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

