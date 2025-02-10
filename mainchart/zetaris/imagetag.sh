branchname="v2.4.0.0-azure"
ghtoken="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"
#### Package helm charts
helm package ./solr/azure -d ./solr/azure
helm package ./airflow-ing/azure -d ./airflow-ing/azure

#### Adding index
helm repo index solr/azure/ --url https://$ghtoken@raw.githubusercontent.com/zetaris/HelmDeployment/$branchname/solr/azure
helm repo index airflow-ing/azure/ --url https://$ghtoken@raw.githubusercontent.com/zetaris/HelmDeployment/$branchname/airflow-ing/azure

git add .
git commit -a -m "tagging main branch with $branchname"
git push

git tag $branchname
git push origin $branchname