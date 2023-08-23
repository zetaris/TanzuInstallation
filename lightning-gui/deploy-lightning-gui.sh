#!/bin/bash

if [ "$1" == "Y" ]
then
        echo "deploying..."
        helm upgrade -i --create-namespace -n zetaris lightning-gui -f lightning-gui/tanzu/tanzuvalues.yaml lightning-gui/tanzu
        exit;
fi
