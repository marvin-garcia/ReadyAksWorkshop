#!/bin/bash

source ./parameters.sh

az ad sp create-for-rbac \
    --name $SERVICE_PRINCIPAL_NAME \
    --skip-assignment \
    -o json