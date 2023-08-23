#!/bin/bash -x

helm upgrade -i --create-namespace -n zetaris solr -f solr/tanzu/tanzuvalues.yaml solr/tanzu

