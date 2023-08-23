#!/bin/bash

if [ "$1" == "Y" ]
then
        echo "deploying for load test"
        helm upgrade -i --create-namespace -n zetaris lightning-api -f lightning-api/tanzu/tanzuvalues.yaml lightning-api/tanzu
        exit;
fi

