# more detailed production instructions

customize variables and such for personal environment

tofu init
tofu plan
tofu apply

tofu output -raw talos_config > ~/.talos/config
tofu output -raw kube_config > ~/.kube/config
chmod 600 ~/.talos/config ~/.kube/config

Ensure all the CRDs are deployed:
kubectl apply -k k8s/infrastructure/crds

## infrsastructure set up

Ensure all the CRDs are deployed:
kubectl apply -k k8s/infrastructure/crds

### Cilium CNI

#### Cilium files adaptation

Update k8s/infrastructure/network/cilium/values.yaml to your domain name

#### Cilium Build

kubectl kustomize --enable-helm k8s/infrastructure/network/cilium | kubectl apply -f -

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=cilium -n kube-system --timeout=90s

### External-secrets

#### External-secrets files adaptation

Update k8s/infrastructure/controllers/external-secrets/bitwarden-store.yaml with your organizationID and project ID, and SDKURL to match your domain
Update k8s/infrastructure/controllers/external-secrets/bitwarden-certificate.yaml with your domain name

#### External-Secrets build

kustomize build --enable-helm k8s/infrastructure/controllers/external-secrets | kubectl apply -f -

#### External-Secrets Initial configuration

Replace \<your-token> with your actual Bitwarden API token:
kubectl create secret generic bitwarden-access-token \
  --namespace external-secrets \
  --from-literal=token=\<your-token>

Validate pod status:
kubectl get pods -n external-secrets

Download the ACME root cert:
curl -Lo isrgrootx1.pem <https://letsencrypt.org/certs/isrgrootx1.pem>

Create the certificate trust secret:
kubectl create secret generic letsencrypt-ca \
  --namespace external-secrets \
  --from-file=ca.crt=isrgrootx1.pem

### Cert Manager

Update k8s/infrastructure/controllers/cert-manager/cert-manager-secrets-external.yaml to your bitwarden secrets-manager keys

kustomize build --enable-helm k8s/infrastructure/controllers/cert-manager | kubectl apply -f -

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=webhook -n cert-manager --timeout=90s

### ArgoCD

#### ArgoCD files adaptation

Update:
  k8s/infrastructure/controllers/argocd/{values,http-route-api,http-route}.yaml to your domain
  k8s/infrastructure/controllers/argocd/externalsecret.yaml to your authentik clientID and secret (this comes later)

#### ArgoCD build

kustomize build --enable-helm k8s/infrastructure/controllers/argocd | kubectl apply -f -

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=120s

#### ArgoCD initial configuration

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

### Longhorn storage

#### Longhorn files adaptation

Update:
  k8s/infrastructure/storage/longhorn/http-route.yaml to your domain
  k8s/infrastructure/controllers/argocd/externalsecret.yaml to your authentik clientID and secret (this comes later)

#### Longhorn build

kustomize build --enable-helm k8s/infrastructure/storage/longhorn | kubectl apply -f -

### CoreDNS

#### coreDNS build

kustomize build --enable-helm k8s/infrastructure/network/coredns | kubectl apply -f -
