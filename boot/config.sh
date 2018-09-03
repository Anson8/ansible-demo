#!/usr/bin/env bash

BOOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
ANSIBLE_CFG=$BOOT_PATH/../depend/config/ansible/ansible.cfg


. $BOOT_PATH/../config/clusterConfig


function fillGatewayConfig() {
#    local gatewayIP
#
#    # ip-detect
#    if [ -n $HOST_NETCARD_NAME ];then
#        gatewayIP=$(ip addr show $HOST_NETCARD_NAME | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
#        echo "The gatewayIP is $gatewayIP."
#    else
#        echo "ERROR: HOST_NETCARD_NAME is not configured by the user."
#        return 1
#    fi

    # ansilbe config
    if [ -f $ANSIBLE_CFG ];then
        sudo mkdir -p /etc/ansible/;sudo cp -rf $ANSIBLE_CFG /etc/ansible/
    fi

}