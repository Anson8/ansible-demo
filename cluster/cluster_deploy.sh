#!/usr/bin/env bash

CLUSTER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
TASKS_PATH=$CLUSTER_PATH/k8sservice/tasks/
## TODO 引入clusterConfig配置文件
. $CLUSTER_PATH/../config/clusterConfig

#验证ip地址的正确性
function ip_valid()  {
    echo $1 | grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" > /dev/null
    if [ $? = 1 ]; then
        return 1
    else
        a=`echo $1 | awk -F. '{print $1}'`
        b=`echo $1 | awk -F. '{print $2}'`
        c=`echo $1 | awk -F. '{print $3}'`
        d=`echo $1 | awk -F. '{print $4}'`

        if [ $a -ge 255 -o $a -le 0 -o $b -gt 255 -o $b -lt 0 -o $c -gt 255 -o $c -lt 0 -o $d -gt 255 -o $d -le 0 ]; then
            return 2;
        fi

        #验证是否组播地址
        if [ $a -ge 224 -a $a -le 239 ]; then
            return 3
        fi

        #验证回环
        if [ $a -eq 127 ]; then
            return 4
        fi

    fi
    return 0
}

## TODO 到10.100.0.2用kubelet运行nginx-test
function deployTomcat(){
     local ip = ${K8S_RUN_NODE[0]}
     if ip_valid $ip; then
        echo "ansible-playbook $TASKS_PATH/tomcat-test.yml "
        ansible-playbook $TASKS_PATH/tomcat-test.yml -i $ip, -e "ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD"
     else
        # ip valid
        echo "ERROR: invalid glusterfs server ip = $ip"
        return 1
     fi
}

## TODO 测试test
function deployTest(){
     local ip = ${K8S_RUN_NODE[0]}
     if ip_valid $ip; then
        echo "ansible-playbook $TASKS_PATH/test.yml "
        ansible-playbook $TASKS_PATH/test.yml -i $ip, -e "ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD"
     else
        # ip valid
        echo "ERROR: invalid glusterfs server ip = $ip"
        return 1
     fi
}


function clusterDeploy() {
       echo " 欢迎使用deploy"
}