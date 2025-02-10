branchname="v2.3.6.0-vmware"
ghtoken="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"
#### Package helm charts
helm package ./mainchart/zetaris -d ./mainchart/zetaris

#### Adding index
helm repo index mainchart/zetaris/ --url https://$ghtoken@raw.githubusercontent.com/zetaris/HelmDeployment/$branchname/mainchart/zetaris

git add .
git commit -a -m "tagging main branch with $branchname"
git push

git tag $branchname
git push origin $branchname