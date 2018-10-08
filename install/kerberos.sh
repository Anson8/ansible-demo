#!/usr/bin/env bash

INSTALL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
TASKS_PATH=$INSTALL_PATH/tasks
## TODO 引入installConfig配置文件
. $INSTALL_PATH/../config/installConfig
. $INSTALL_PATH/common/ip-detect
. $INSTALL_PATH/prereqs/dog.sh


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

## TODO 批量创建用户实体
    read -p "Do you want to create user principals?[Y/N/J]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to create user ${KERBEROS_PRINCIPAL[@]}."
        for p in ${KERBEROS_PRINCIPAL[@]}
        do
            createprincipals $p
        done;
        echo "Start to create principals...................Successfully!";;
    N | n)
        echo "Exit."
        exit 0;;
    J | j)
        echo "Skip the installation of the spot.";;
    *)
        echo "Input error, please try again."
        exit 5;;
    esac

## TODO 批量添加用户票据信息到服务器的 .k5login
    read -p "Do you want to add user principals to .k5login?[Y/N/J]:" answer
    answer=$(echo $answer)
    case $answer in
    Y | y)
        echo "Start to add user principals to .k5login."
        cd $OPS_PRINCIPAL
        for file in $(ls *)
        do
            princi=$file@ICARBONX.NET
            while read fileLine
            do
               ip=$(echo $fileLine | awk '{print $2 }')   #取每行的第二列值（IP）
               if ip_valid $ip;then
                   system_name=$(echo $fileLine | awk '{print $3 }')   #取每行的第三列值(系统名)
                   echo "ansible-playbook add principals to this $ip .k5login----$system_name"
                   ansible-playbook $TASKS_PATH/kerberos-principal.yml -i $ip, -e "principals=$princi systemName=$system_name ansible_user=$USER ansible_port=22 ansible_ssh_pass=$PASSWD ansible_become_pass=$PASSWD condition=false"
                   if [ $? -ne 0 ];then
                       echo "Start to add principals .k5login..................Failed! Ret=$ret"
                       return 1
                   fi
               else
                   # ip valid
                   echo "ERROR: invalid mechine public ip = $ip."
                   return 4
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
