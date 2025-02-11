branchname="v2.3.6.0-tanzu"
#ghtoken="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"
#### Package helm charts
helm package ./mainchart/zetaris -d ./mainchart/zetaris

#### Adding index
helm repo index mainchart/zetaris/ --url https://raw.githubusercontent.com/zetaris/TanzuInstallation/$branchname/mainchart/zetaris

git add .
git commit -a -m "tagging main branch with $branchname"
git push

git tag $branchname
git push origin $branchname