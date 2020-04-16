#!/bin/bash

# More info on how to install Helm at https://helm.sh/docs/intro/install/

source ./scripts/parameters.sh

kubectl apply -f ./environment-config/helm/helm-rbac-config.yaml
kubectl apply -f ./environment-config/monitoring/prometheus-configmap.yaml
kubectl apply -f ./environment-config/namespace/app-namespace.yaml
kubectl apply -f ./environment-config/RoleBindings/roles.yaml
kubectl apply -f ./environment-config/RoleBindings/admins-role-bindings.yaml
kubectl apply -f ./environment-config/RoleBindings/app-admins-role-bindings.yaml
kubectl apply -f ./environment-config/RoleBindings/devops-account-role-bindings.yaml

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm upgrade \
    "nginx-$NAMESPACE" \
    stable/nginx-ingress \
    --namespace $NAMESPACE \
    -f ./stable-nginx-ingress/values.yaml \
    --set controller.name="nginx-$NAMESPACE" \
    --set controller.ingressClass="nginx-$NAMESPACE" \
    --set controller.service.loadBalancerIP=$INGRESS_IP \
    --install \
    --force

helm upgrade \
    "nginx-$NAMESPACE" \
    ./sigsci-nginx-ingress/ \
    --namespace $NAMESPACE \
    -f ./sigsci-nginx-ingress/values_sigsci.yaml \
    --set controller.ingressClass="nginx-$NAMESPACE" \
    --set controller.service.loadBalancerIP=$INGRESS_IP \
    --set sigsci.secret.accessKeyId=$SIGSCI_ACCESS_KEY \
    --set sigsci.secret.secretAccessKey=$SIGSCY_SECRET_KEY \
    --install \
    --force

kubectl apply -f ./sampleapps/mathwebapp.yaml
kubectl apply -f ./sampleapps/nginxweb.yaml
