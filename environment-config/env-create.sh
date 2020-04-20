#!/bin/bash
# More info on how to install Helm at https://helm.sh/docs/intro/install/

source ./scripts/parameters.sh

CREATE_NAMESPACE=false
INGRESS_INSTALLATION_TYPE='sigsci' # Possible options are 'stable', 'sigsci' or 'none'
INSTALL_SAMPLE_APPS=false

if [ $CREATE_NAMESPACE == true ]
then
    echo "Creating namespace $NAMESPACE"
    
    kubectl apply -f ./environment-config/helm/helm-rbac-config.yaml
    kubectl apply -f ./environment-config/monitoring/prometheus-configmap.yaml
    kubectl apply -f ./environment-config/namespace/app-namespace.yaml
    kubectl apply -f ./environment-config/RoleBindings/roles.yaml
    kubectl apply -f ./environment-config/RoleBindings/admins-role-bindings.yaml
    kubectl apply -f ./environment-config/RoleBindings/app-admins-role-bindings.yaml
    kubectl apply -f ./environment-config/RoleBindings/devops-account-role-bindings.yaml
    
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    helm repo update
fi

if [ $INGRESS_INSTALLATION_TYPE == 'stable' ]
then
    echo "Installing Helm chart for stable nginx ingress in namesapce $NAMESPACE"
    
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
elif [ $INGRESS_INSTALLATION_TYPE == 'sigsci' ]
then
    echo "Installing custom chart for SigSci nginx ingress in namesapce $NAMESPACE"
    
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
else
    echo 'Skipping ingress controller installation'
fi

if [ $INSTALL_SAMPLE_APPS == true ]
then
    echo "Installing sample apps mathwebapp and nginxweb"

    helm upgrade \
        "mathweb" \
        ./sampleapps/mathweb/ \
        --namespace $NAMESPACE \
        -f ./sampleapps/mathweb/values.yaml \
        --set ingress.annotations."kubernetes\.io/ingress\.class"="nginx-$NAMESPACE" \
        --install \
        --force
    
    helm upgrade \
        "nginxweb" \
        ./sampleapps/nginxweb/ \
        --namespace $NAMESPACE \
        -f ./sampleapps/nginxweb/values.yaml \
        --set ingress.annotations."kubernetes\.io/ingress\.class"="nginx-$NAMESPACE" \
        --install \
        --force
fi

