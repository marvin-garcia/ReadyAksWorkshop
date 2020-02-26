#!/bin/bash

# More info on how to install Helm at https://helm.sh/docs/intro/install/

NAMESPACE='app1'
INGRESS_IP='10.0.0.24'

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
    -f ./nginx/ingress-internal.yaml \
    --set controller.name="nginx-$NAMESPACE" \
    --set controller.ingressClass="nginx-$NAMESPACE" \
    --set controller.service.loadBalancerIP=$INGRESS_IP \
    --install \
    --force