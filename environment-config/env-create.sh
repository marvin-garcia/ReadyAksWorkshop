#!/bin/bash

NAMESPACE='app1'
INGRESS_IP='10.0.0.24'

kubectl apply -f ./environment-config/monitoring/prometheus-configmap.yaml
kubectl apply -f ./environment-config/namespace/app-namespace.yaml
kubectl apply -f ./environment-config/RoleBindings/roles.yaml
kubectl apply -f ./environment-config/RoleBindings/admins-role-bindings.yaml
kubectl apply -f ./environment-config/RoleBindings/app-admins-role-bindings.yaml
kubectl apply -f ./environment-config/RoleBindings/devops-account-role-bindings.yaml

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