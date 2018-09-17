#!/usr/bin/env bash

OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $OPS_ROOT
## TODO 引入deployConfig配置文件
. $OPS_ROOT/config/deployConfig
. $OPS_ROOT/deploy/deploy.sh


## TODO k8s服务器服务部署
options=("redis" "confluence")
if [ $# -ne 1 ];then
	echo "Input invalid! Support: redis | confluence"
	exit 1
fi

if [ $1 = "help" ];then
	echo "start_deploy.sh args: redis | confluence"
	exit 0
fi

read -p "Are you sure to deploy $1?[Y/N]:" answer
answer=$(echo $answer)
case $answer in
Y | y)
    echo "Start to deploy $1..."
    ;;
N | n)
    echo "Exit."
    exit 0;;
*)
    echo "Input error, please try again."
    exit 1;;
esac

# TODO 单点部署
if [ $# -ge 1 ]; then
    case $1 in
    "redis")
        redisDeploy
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to deploy $1...................Failed! Ret=$ret"
            exit 2
        fi
        echo "Start to deploy $1...................Successfully!"
        exit 0;;
    "confluence")
        confluenceDeploy
        ret=$?
        if [ $ret -ne 0 ];then
            echo "Start to deploy $1...................Failed! Ret=$ret"
            exit 2
        fi
        echo "Start to deploy $1...................Successfully!"
        exit 0;;
    esac
fi
