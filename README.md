# TanzuInstallation

# Ingress nginx
`helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx` \
`helm upgrade --install lightning-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --version 4.0.18 --set rbac.create=true --set rbac.createRole=true --set rbac.createClusterRole=true --set-string controller.config.proxy-body-size=100m --set-string controller.config.server-tokens=false --set controller.config.generate-request-id=\"false\"` \

# Spark Operator
`helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator` \
`helm install spark-operator spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true --set resourceQuotaEnforcement.enable=true`

# Cert Manager
`helm repo add jetstack https://charts.jetstack.io` \
`helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager  --create-namespace --version v1.7.0 --set installCRDs=true`

# Generate keys
#Generate a private_key.pem \
`openssl genrsa -out private_key.pem 2048` \
#Generate a private_key.der \
`openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt` \
#Generate a public_key.der \
`openssl rsa -in private_key.pem -pubout -outform DER -out public_key.der` \
#Create namespace and secret \
`kubectl create namespace {yournamespace}` \
`kubectl create secret generic lightning-password-security-encryption-secret --from-file=private_key.der --from-file=public_key.der –-namespace {yournamespace}` \

# NFS confiuration:

Modify the nfs.values.yaml to point to your NFS file share and your sharename, and specify your storage class name

## install nfs with this nfsvalues file
Run the following commands to install the Tanzu NFS provisioner:
`helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner` \
`helm repo update` \
`kubectl create namespace $namespace` \
`helm install nfs-subdir-external-provisioner --namespace $namespace nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f nfs.values.yaml`

# install Zetaris

Modify the zetaris values.yaml file. \
Run this command with "dry-run" to validate the templates. \
`helm upgrade --install --dry-run zetaris mainchart/zetaris --namespace $namespace -f ./mainchart/zetaris/values.yaml` \ <br>

This command will then install all 5 commands of zetaris. \
`helm upgrade --install zetaris mainchart/zetaris --namespace $namespace -f ./mainchart/zetaris/values.yaml` <br>

Once deployed, run kubectl get pods -n $namespace to make sure that everything is running properly <br>

# Install Airflow
`helm repo add apache-airflow https://airflow.apache.org` \
#modify the airflow.values.yaml then install \
`helm upgrade --install airflow apache-airflow/airflow -f ./airflow/airflowvalues.yaml --namespace airflow --create-namespace`