#!/usr/bin/env bash

BOOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
. $BOOT_PATH/config.sh
. $BOOT_PATH/dog.sh

function gatewayInstall(){

    # filling genconf
    echo "Start to fill genconf."
    fillGatewayConfig
    ret=$?
    if [[ $ret -ne 0 ]];then
        echo "Start to fill genconf...................Failed! Ret=$ret"
        return 1
    fi
    echo "Start to fill genconf...................Successfully!"

    # download tools
    echo "Start to prepare install."
    prepareInstall
    ret=$?
    if [[ $ret -ne 0 ]]; then
        echo "Start to prepare install...................Failed! Ret=$ret"
        return 2
    fi
    echo "Start to prepare install...................Successfully!"
}