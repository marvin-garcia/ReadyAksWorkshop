#!/bin/bash

source ./parameters.sh

SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $AKS_SUBNET_NAME --query id -o tsv)

az aks create \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --aad-client-app-id $CLIENT_APP_ID \
    --aad-server-app-id $SERVER_APP_ID \
    --aad-server-app-secret $SERVER_APP_SECRET \
    --aad-tenant-id $TENANT_ID \
    --service-principal $SERVICE_PRINCIPAL_ID \
    --client-secret $SERVICE_PRINCIPAL_SECRET \
    --admin-username $ADMIN_USERNAME \
    --generate-ssh-keys \
    --network-plugin $NETWORK_PLUGIN \
    --dns-service-ip $DNS_SERVICE_IP \
    --pod-cidr $POD_CIDR \
    --service-cidr $SERVICE_CIDR \
    --docker-bridge-address $DOCKER_BRIDGE_ADDRESS \
    --enable-addons $ADDONS \
    --load-balancer-managed-outbound-ip-count $LB_OUTBOUND_IP_COUNT \
    --load-balancer-sku $LB_SKU \
    --enable-cluster-autoscaler \
    --max-count $MAX_COUNT \
    --min-count $MIN_COUNT \
    --max-pods $MAX_PODS \
    --node-count $NODE_COUNT \
    --nodepool-name $NODEPOOL_NAME \
    --node-vm-size $NODE_SIZE \
    --vm-set-type $VM_SET_TYPE \
    --vnet-subnet-id $SUBNET_ID \
    --workspace-resource-id $WORKSPACE_ID \
    --zones $CLUSTER_ZONES \
    --verbose