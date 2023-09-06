# TanzuInstallation

# Ingress nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx \
helm upgrade --install lightning-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --version 4.0.18 --set rbac.create=true --set rbac.createRole=true --set rbac.createClusterRole=true --set-string controller.config.proxy-body-size=100m --set-string controller.config.server-tokens=false --set controller.config.generate-request-id=\"false\" \

# Spark Operator
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator \
helm install spark-operator spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true --set resourceQuotaEnforcement.enable=true

# Cert Manager
helm repo add jetstack https://charts.jetstack.io
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager  --create-namespace --version v1.7.0 --set installCRDs=true

# Generate keys
#Generate a private_key.pem
openssl genrsa -out private_key.pem 2048
#Generate a private_key.der
openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt
#Generate a public_key.der
openssl rsa -in private_key.pem -pubout -outform DER -out public_key.der
#Create namespace and secret
kubectl create namespace {yournamespace}
kubectl create secret generic lightning-password-security-encryption-secret --from-file=private_key.der --from-file=public_key.der –-namespace {yournamespace}

# For Tanzu, create NFS by creating the following file:

nfs:
  #The NFS server endpoint that we got from vSAN FS
  server: vsan-fs01.tanzu.lab
  #The NFS share mount path from vSAN FS
  path: /share01
storageClass:
  #The name of the StorageClass to be created on the K8s cluster to allow provisioning of RWM volumes from the share
  name: nfs-external
  #The accessMode that we want to be created from these subvolumes (ReadWriteMany allows multiple containers to mount it at once)
  accessModes: ReadWriteMany
podSecurityPolicy:
  #Enabling the pod security policy allows it to run on TKGS clusters out of the box
  enabled: true

## install nfs with this nfsvalues file
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
kubectl create namespace infra
helm install nfs-subdir-external-provisioner --namespace infra nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f nfsvalues.yaml

# install Zetaris => Modify the main chart/zetaris/values file

Modify all values file for server, api, ui, solr and airflow (single values file and chart coming in next release)
#use bash script run to deploy  
./lightning-server/deploy-lightning-server Y
./lightning-api/deploy-lightning-api Y
./lightning-gui /deploy-lightning-gui Y
./solr/deploy-solr Y

# Install Airflow
helm repo add apache-airflow https://airflow.apache.org
#modify airflow.values.yaml then install
helm upgrade --install airflow apache-airflow/airflow -f ./airflow/airflowvalues.yaml --namespace airflow --create-namespace