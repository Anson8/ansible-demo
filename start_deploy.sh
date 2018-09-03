#!/usr/bin/env bash

BOOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
echo $BOOT_PATH
## TODO 引入clusterConfig配置文件和dog.sh
. $BOOT_PATH/config/clusterConfig
. $BOOT_PATH/boot/gateway_install.sh

## TODO 全流程安装
### TODO 安装ansible、git客户端
read -p "Are you sure to install ansible for this cluster ?[Y/N]" answer
answer =$(echo $answer)
case $answer in
Y | y)
    echo "Start to install gateway machines..."
    gatewayInstall
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "Start to install gateway machine....................Failed! Ret=$ret"
        exit 1
    fi
    exit "Start to ";;
N | n)
    echo "Exit."
    exit 0;;
*)
 echo "Input error,please try again."
 exit 1;;
esac
