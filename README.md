# ReadyAksWorkshop

This repo contains relevant script and config files to deploy Azure Kubernetes Service. This configuration has the following details:
- It enables RBAC
- It uses Azure AD authentication to manage the cluster
- It uses kubenet network configuration
- It requires a log analytics workspace
- It creates a namespace for the application team to manage
- It configures roles and role bindings in the cluster
- It installs Helm
- It install Nginx in the cluster and creates an ingress controller with a private IP address
- It creates a Web Application Firewall to use in front of the internal ingress controller for detection and monitoring purposes
- It prevents access from the Internet to the WAF so it can only be accessed internally. For testing purposes, the Network Security Group can be disassociated to the WAF subnet and public access will be back enabled

## Create service principal

First thing you will need is a service principal to assign to the cluster. If you already have one, you may skip this step. Otherwise, run the following command:

```bash ./scripts/create-service-principal.sh```

## Register AAD Apps to use with the cluster

Since the cluster will be integrated with Azure Active Directory, you need to register a client and server apps to authenticate users. Follow this [https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration]document to complete the steps.

## Fill in environment parameters

In order to use the scripts in this repo, you need to fill in the parameters in the file [scripts/parameters.sh]parameters.sh. Once you have filled all variables, you may proceed with the documentation.

## Create virtual network

Next you will need an existing virtual network and a subnet to deploy the cluster and the WAF. Next, you'll need to grant contributor role access to the service principal to manage the subnet. If you already have a virtual network and a subnet, you may skip this step and, but make sure [scripts/parameters.sh]parameters.sh file reflects your current configuration. Run the following commands:

```
bash ./scripts/create-vnet.sh
bash ./scripts/service-principal-role-assignments.sh
```

## Create cluster

Now you will create the AKS cluster. Run the folloeing command:

```bash ./scripts/create-cluster.sh```

## Create Web Application Firewall

Once the cluster has been created, you can create the firewall. Azure App Firewall v2 runs nginx in the backend and therefore is much faster than its predecesor. Currently it requires a public IP in the initial configuration for it to be deployed successfully, so in order to use the private IP and block Internet access we have deployed a Network Security Group in the [scripts/create-vnet.sh]create-vnet.sh script. If you already had a virtual network and skipped the vnet script, you may have to manually add a subnet for the WAF and create the NSG to limit Internet access. For more information, open the file [scripts/create-vnet.sh]create-vnet.sh and go to the documentation link for more details.

To create the WAF, run the following command:

```bash ./scripts/create-waf.sh```

## Configure the cluster

Now that you have a cluster and a firewall to access it, you can configure the cluster for its initial use. In this step you will:

1- Create a service account for Helm to use
2- Configure prometheus logging
3- Create a namespace for a new app
4- Create custom Roles
5- Create several Role Bindings for cluster admins, app admins and DevOps service account
6- Deploy an ingress controller with a private IP address