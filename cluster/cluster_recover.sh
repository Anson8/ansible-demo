#!/usr/bin/env bash

CLUSTER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
## TODO 引入clusterConfig配置文件
. $CLUSTER_PATH/../config/clusterConfig

function clusterRecover() {
    echo " 欢迎使用recover"
}