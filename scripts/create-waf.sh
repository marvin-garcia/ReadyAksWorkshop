#!/bin/bash

# More info on how to configure an App Gateway to only work with private IP here
# https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq

source ./scripts/parameters.sh

az network public-ip create \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --name "$APP_GW_NAME-ip" \
    --allocation-method Static \
    --sku Standard \
    --zone $APP_GW_ZONES \
    --verbose

az network application-gateway create \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP  \
    --name $APP_GW_NAME \
    --sku $APP_GW_SKU \
    --public-ip-address "$APP_GW_NAME-ip" \
    --public-ip-address-allocation Static \
    --http-settings-cookie-based-affinity $APP_GW_COOKIE_BASED_AFFINITY \
    --min-capacity $APP_GW_MIN_CAPACITY \
    --max-capacity $APP_GW_MAX_CAPACITY \
    --private-ip-address $APP_GW_PRIVATE_IP \
    --servers $APP_GW_BACKEND_IP \
    --vnet-name $VNET_NAME \
    --subnet $APP_GW_SUBNET_NAME \
    --zones $APP_GW_ZONES \
    --verbose
