namespace="{yournamespace}"

#install kubectl and helm if needed
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 

#ingress nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install lightning-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --version 4.0.18 --set rbac.create=true --set rbac.createRole=true --set rbac.createClusterRole=true --set-string controller.config.proxy-body-size=100m --set-string controller.config.server-tokens=false --set controller.config.generate-request-id=\"false\" 

#sparkoperator
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
helm install spark-operator spark-operator/spark-operator --namespace spark-operator --create-namespace --set webhook.enable=true --set resourceQuotaEnforcement.enable=true

#cert manager
helm repo add jetstack https://charts.jetstack.io
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager  --create-namespace --version v1.7.0 --set installCRDs=true

#generate keys
#Generate a private_key.pem
openssl genrsa -out private_key.pem 2048
#Generate a private_key.der
openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt
 #Generate a public_key.der
openssl rsa -in private_key.pem -pubout -outform DER -out public_key.der

#create namespace and secret
kubectl create namespace $namespace
kubectl create secret generic lightning-password-security-encryption-secret
--from-file=private_key.der --from-file=public_key.der –-namespace $namespace

#Install NFS
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
helm install nfs-subdir-external-provisioner --namespace $namespace nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f nfsvalues.yaml

## install Zetaris => Modify the main chart/zetaris/values file
#use Dry run to validate deployment
helm upgrade --install --dry-run zetaris mainchart/zetaris --namespace zetaris -f ./mainchart/zetaris/values.yaml
#install Zetaris
helm upgrade --install zetaris mainchart/zetaris --namespace zetaris -f ./mainchart/zetaris/values.yaml


#Install Airflow
helm repo add apache-airflow https://airflow.apache.org
#modify airflow.values.yaml then install
helm upgrade --install airflow apache-airflow/airflow -f ./airflowvalues.yaml --namespace airflow --create-namespace