#!/bin/bash
# More info on how to install Helm at https://helm.sh/docs/intro/install/

source ./scripts/parameters.sh

echo -e "\n#### Environment Config Script ####\n"

read -p "Do you want to create and configure a new namespace? [y/n] (Default=n): " CREATE_NAMESPACE
CREATE_NAMESPACE=${CREATE_NAMESPACE:-n}

if [ $CREATE_NAMESPACE == 'y' ]
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

echo -e "\nNginx Ingress controller options:"
echo -e "1- None"
echo -e "2- Stable"
echo -e "3- SigSci"
echo -e ""

read -p "Choose one of the options above [1-3] (Default=1)" INGRESS_INSTALLATION_TYPE
INGRESS_INSTALLATION_TYPE=${INGRESS_INSTALLATION_TYPE:-1}

if [ $INGRESS_INSTALLATION_TYPE == '1' ]
then
    echo -e "\nSkipping ingress controller installation"
elif [ $INGRESS_INSTALLATION_TYPE == '2' ]
then
    echo -e "\nInstalling 'stable' version of nginx ingress in namesapce $NAMESPACE"
    
    helm delete \
        "nginx-$NAMESPACE" \
        --namespace $NAMESPACE > /dev/null 2>&1

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
elif [ $INGRESS_INSTALLATION_TYPE == '3' ]
then
    echo -e "\nInstalling 'SigSci' version of nginx ingress in namesapce $NAMESPACE"
    
    helm delete \
        "nginx-$NAMESPACE" \
        --namespace $NAMESPACE > /dev/null 2>&1

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
    echo -e "\nOption '$INGRESS_INSTALLATION_TYPE' is not recognized. Skipping ingress controller installation"
fi

echo -e ""
read -p "Do you want to install the sample app 'mathweb'? [y/n] (Default=n): " INSTALL_MATHWEB
INSTALL_MATHWEB=${INSTALL_MATHWEB:-n}

if [ $INSTALL_MATHWEB == 'y' ]
then
    echo -e ""
    read -p "    Do you want to install mathweb with SigSci sidecar? [y/n] (Default=n): " INSTALL_SIGSCI
    
    helm delete \
        "mathweb" \
        --namespace $NAMESPACE > /dev/null 2>&1

    if [ $INSTALL_SIGSCI == 'y' ]
    then
        helm upgrade \
            "mathweb" \
            ./sampleapps/mathweb/ \
            --namespace $NAMESPACE \
            -f ./sampleapps/mathweb/values.yaml \
            --set ingress.annotations."kubernetes\.io/ingress\.class"="nginx-$NAMESPACE" \
            --set sigsci.enabled=true \
            --set sigsci.secret.accessKeyId=$SIGSCI_ACCESS_KEY \
            --set sigsci.secret.secretAccessKey=$SIGSCY_SECRET_KEY \
            --install \
            --force
    else
            helm upgrade \
            "mathweb" \
            ./sampleapps/mathweb/ \
            --namespace $NAMESPACE \
            -f ./sampleapps/mathweb/values.yaml \
            --set ingress.annotations."kubernetes\.io/ingress\.class"="nginx-$NAMESPACE" \
            --set sigsci.enabled=false \
            --install \
            --force
    fi
fi

echo -e ""
read -p "Do you want to install the sample app 'nginxweb'? [y/n] (Default=n): " INSTALL_NGINXWEB
INSTALL_NGINXWEB=${INSTALL_NGINXWEB:-n}

if [ $INSTALL_NGINXWEB == 'y' ]
then
    helm delete \
        "nginxweb" \
        --namespace $NAMESPACE > /dev/null 2>&1
        
    helm upgrade \
        "nginxweb" \
        ./sampleapps/nginxweb/ \
        --namespace $NAMESPACE \
        -f ./sampleapps/nginxweb/values.yaml \
        --set ingress.annotations."kubernetes\.io/ingress\.class"="nginx-$NAMESPACE" \
        --install \
        --force
fi