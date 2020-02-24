#!/bin/bash

source ./parameters.sh

VNET_ID=`az network vnet show --resource-group $RESOURCE_GROUP --name $VNET_NAME --query id -o tsv`

az role assignment create \
    --assignee $SERVICE_PRINCIPAL_ID \
    --scope $VNET_ID \
    --role Contributor