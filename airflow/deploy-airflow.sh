#!/bin/bash

if [ "$1" == "Y" ]
then
        echo "deploying airflow"
        helm upgrade -i --create-namespace -n airflow airflow -f airflow-ing/tanzu/airflowvalues.yaml apache-airflow/airflow
        exit;
fi

if [ "$1" == "ing" ]
then
        echo "deploying ing for airflow"
        helm upgrade -i --create-namespace -n airflow airflow-ing -f airflow-ing/tanzu/values.yaml airflow-ing/tanzu
        exit;
fi
