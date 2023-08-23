#!/bin/bash -x
if [ "$1" == "Y" ]
then
	echo "deploying.."
	helm upgrade -i --create-namespace -n zetaris lightning-server -f lightning-server/tanzu/tanzuvalues.yaml lightning-server/tanzu
	exit;
fi
