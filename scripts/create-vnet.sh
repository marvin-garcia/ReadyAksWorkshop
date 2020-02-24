#!/bin/bash
clear
source ./scripts/parameters.sh

az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefixes $VNET_ADDRESS_SPACE \
    --subnet-name $AKS_SUBNET_NAME \
    --subnet-prefix $AKS_SUBNET_RANGE

az network nsg create \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --name "$APP_GW_NAME-nsg"

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name "$APP_GW_NAME-nsg" \
    --name AllowGatewayManager \
    --priority 100 \
    --direction Inbound \
    --source-address-prefixes GatewayManager \
    --source-port-ranges '*' \
    --destination-port-ranges 65200-65535 \
    --access Allow

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name "$APP_GW_NAME-nsg" \
    --name AllowAzureLoadBalancer \
    --priority 110 \
    --direction Inbound \
    --source-port-ranges '*' \
    --source-address-prefixes AzureLoadBalancer \
    --destination-port-ranges '*' \
    --access Allow

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name "$APP_GW_NAME-nsg" \
    --name DenyAllInboundInternet \
    --priority 4096 \
    --direction Inbound \
    --source-port-ranges '*' \
    --source-address-prefixes Internet \
    --destination-port-ranges '*' \
    --access Deny

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $APP_GW_SUBNET_NAME \
    --address-prefixes $APP_GW_SUBNET_RANGE \
    --network-security-group "$APP_GW_NAME-nsg"
