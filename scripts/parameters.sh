#!/bin/bash

VNET_NAME='aks-vnet'
VNET_ADDRESS_SPACE='10.0.0.0/16'
AKS_SUBNET_NAME='aks-subnet'
AKS_SUBNET_RANGE='10.0.240.0/27'
APP_GW_SUBNET_NAME='waf-subnet'
APP_GW_SUBNET_RANGE='10.0.1.0/28'
INGRESS_IP='10.0.0.23'

LOCATION=''
RESOURCE_GROUP=''
CLUSTER_NAME=''
ADMIN_USERNAME='cluster-admin'
NETWORK_PLUGIN='kubenet'
SERVICE_CIDR='10.151.0.0/16'
DNS_SERVICE_IP='10.151.0.10'
POD_CIDR='10.152.0.0/16'
DOCKER_BRIDGE_ADDRESS='10.153.0.1/16'
LB_OUTBOUND_IP_COUNT=2
LB_SKU='standard'
ADDONS='monitoring'
MIN_COUNT=2
MAX_COUNT=10
MAX_PODS=30
NODEPOOL_NAME='pool1'
NODE_COUNT=2
NODE_SIZE='Standard_DS2_v2'
VM_SET_TYPE='VirtualMachineScaleSets'
WORKSPACE_ID='/subscriptions/subscription-id/resourceGroups/resource-grou-name/providers/Microsoft.OperationalInsights/workspaces/workspace-name'
CLUSTER_ZONES=1
NAMESPACE='app2'

APP_GW_NAME='aks-waf_v2'
APP_GW_MIN_CAPACITY=2
APP_GW_MAX_CAPACITY=10
APP_GW_SKU='WAF_v2'
APP_GW_PRIVATE_IP='10.0.1.4'
APP_GW_BACKEND_IP='10.0.0.24'
APP_GW_COOKIE_BASED_AFFINITY='Disabled'
APP_GW_WAF_POLICY='app1-policy'
APP_GW_ZONES=1

CLIENT_APP_ID=''
SERVER_APP_ID=''
SERVER_APP_SECRET=''
SERVICE_PRINCIPAL_NAME=''
SERVICE_PRINCIPAL_ID=''
SERVICE_PRINCIPAL_SECRET=''
TENANT_ID=''

SIGSCI_ACCESS_KEY='e14500e0-5ecd-47e0-b1ac-c0e628450807'
SIGSCY_SECRET_KEY='6z2EZ7iSy53Vhe4--GMnkfvtP6xQk35ZgWohVkTLT0s'