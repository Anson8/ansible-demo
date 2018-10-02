#!/usr/bin/env bash

INSTALL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
TASKS_PATH=$INSTALL_PATH/tasks
## TODO 引入installConfig配置文件
. $INSTALL_PATH/../config/installConfig
. $INSTALL_PATH/common/ip-detect
. $INSTALL_PATH/prereqs/dog.sh


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
            ansible-playbook $TASKS_PATH/bootstrap.yml -i $ip, -e "security_sudoer=$seSudoer ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
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
    local host_name
    nodes=${KERBEROS_NODES[@]};
    system_user=$SYSTEM_USER
    read -p "Do you want to deploy kerberos for [$nodes] ?[Y/N/J]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to deploy kerberos."
        for ip in $nodes;
        do
            if ip_valid $ip;then
                ret=`sethostname $ip`
                host_name=${ret}
                echo "ansible-playbook for this [$ip] and hostname is set to [$host_name]."
                ansible-playbook $TASKS_PATH/kerberos.yml -i $ip, -e "hostname=$host_name sysuser=$system_user ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
                echo "add krb5.keytab and principal for this [$ip]."
                addprinc $ip
                echo "copy the krb5.keytab and principal to this [$ip]."
                ansible-playbook $TASKS_PATH/keytab-copy.yml -i $ip, -e "hostname=$host_name ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
                #在 $HOME/.k5login 中加入允许登录到该 linux 帐户的 Kerberos principal
                principal_all=${KERBEROS_PRINCIPAL[@]}
                echo "add the principals [$principal_all] to this [$ip]."
                ret=`getprincipals`
                princi=${ret}
                echo "ansible-playbook for this [$ip] and set principals [$princi] to .k5login."
                ansible-playbook $TASKS_PATH/kerberos-principal.yml -i $ip, -e "principals=$princi ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"

            else
                # ip valid
                echo "ERROR: invalid slave public ip = $ip."
                return 4
            fi
        done


        echo "Start to deploy kerberos...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    J | j)
        echo "Skip the installation of the spot.";;
    *)
        echo "Input error, please try again."
        exit 5;;
    esac

   ##批量添加票据到服务器
   read -p "Do you want to add principals to mechine?[Y/N/J]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to addd principals to mechine."
        cd $OPS_PRINCIPAL
        for file in $(ls *)
        do
            princi=$file@ICARBONX.NET
            while read fileLine
            do
               ip=$(echo $fileLine | awk '{print $1 }')   #取每行的第一列值（IP）
               system_name=$(echo $fileLine | awk '{print $2 }')   #取每行的第二列值(系统名)

               echo "ansible-playbook add principals to this $ip----$system_name"
               ansible-playbook $TASKS_PATH/kerberos-principal.yml -i $ip, -e "principals=$princi systemName=$system_name ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
               if [ $? -ne 0 ];then
                   echo "Start to add principals..................Failed! Ret=$ret"
                   return 1
               fi
            done < $file
        done
        echo "Start to add principals...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    J | j)
        echo "Skip the installation of the spot.";;
    *)
        echo "Input error, please try again."
        exit 5;;
    esac

}
