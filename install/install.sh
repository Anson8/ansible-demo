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

## TODO 测试ansible功能，创建文件
function testAnsible(){
   echo "ansible-playbook test ansible for this $TEST_NODES"
   ansible-playbook $TASKS_PATH/test.yml -i $TEST_NODES, -e "ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
}

## TODO 部署免密登录sshAddkey
function sshAddkey() {
    local seSudoer
    # Check user configuration
    ## SECURITY_SUDOER
    if [ -n $SECURITY_SUDOER ]; then
        seSudoer=$SECURITY_SUDOER
    else
        echo "ERROR: SECURITY_SUDOER is not configured by the user."
        return 1
    fi
    nodes=${SSHKADDKEYS_NODES[@]};
    read -p "Do you want to deploy sshAddkey for [$nodes]?[Y/N]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to deploy sshAddkey."
        for ip in $nodes;
        do
            echo "ansible-playbook deploy sshAddkey for this $ip"
            ansible-playbook $TASKS_PATH/ssh-addkey.yml -i $ip, -e "security_sudoer=$seSudoer ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
            if [ $? -ne 0 ];then
                 echo "Start to deploy sshAddkey...................Failed! Ret=$ret"
                return 1
            fi
        done
        echo "Start to deploy sshAddkey...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}

## TODO 批量部署HostName
function hostnameDeploy() {
    local setHostname
    # Check user configuration
    ## SECURITY_SUDOER
    if [ -n $HOSTNAME ]; then
        setHostname=$HOSTNAME"-s1"
    else
        echo "ERROR: HOSTNAME is not configured by the user."
        return 1
    fi
    nodes=${HOSTNAME_NODES[@]};
    read -p "Do you want to deploy hostname for [$nodes]?[Y/N]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to deploy hostname."
        for ip in $nodes;
        do
            echo "ansible-playbook set hostname $setHostname for this $ip"
            ansible-playbook $TASKS_PATH/hostname.yml -i $ip, -e "hostname=$setHostname ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
            if [ $? -ne 0 ];then
                 echo "Start to deploy hostname...................Failed! Ret=$ret"
                return 1
            fi
        done
        echo "Start to deploy hostname...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}

## TODO 部署kerberos到服务器
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
            ansible-playbook $TASKS_PATH/kerberos.yml -i $ip, -e " ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"

        done
        echo "Start to deploy kerberos...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    *)
        echo "Input error, please try again."
        exit 2;;
    esac

}
