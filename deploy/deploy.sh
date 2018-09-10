#!/usr/bin/env bash

DEPLOY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
TASKS_PATH=$DEPLOY_PATH/service/tasks/
## TODO 引入deployConfig配置文件
. $DEPLOY_PATH/../config/deployConfig

## TODO 部署redis
function redisDeploy(){
     kubectl create -f $TASKS_PATH/config/redis-conf.yaml
     kubectl create -f $TASKS_PATH/services/redis-master.yaml
     kubectl create -f $TASKS_PATH/services/redis-sentinel.yaml
}
