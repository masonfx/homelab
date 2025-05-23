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

To build:
kustomize build k8s/infrastructure/controllers/argocd --enable-helm | kubectl apply -f -

To destroy:
kustomize build k8s/infrastructure/controllers/argocd --enable-helm | kubectl delete -f -

kubectl get pods -n argocd
