# ReadyAksWorkshop

This repo contains relevant script and config files to deploy Azure Kubernetes Service. The scripts in this repo allow you to do the following:
- Create an AKS cluster with the following specs:
    - RBAC enabled
    -Azure AD integrated
    - kubenet network configuration
    - Connected to a log analytics workspace
- Create a namespace for an application team to manage
- Configure roles and role bindings in the cluster
- Install Helm
- Install Nginx in the cluster and create an ingress controller with a private IP address
- Create a Web Application Firewall to use in front of the internal ingress controller for detection and monitoring purposes. Public access from the Internet to the WAF is blocked so it can only be accessed internally. For testing purposes, the Network Security Group can be disassociated to the WAF subnet and public access will be back enabled

## Create service principal

First thing you will need is a service principal to assign to the cluster. If you already have one, you may skip this step. Otherwise, run the following command:

```bash ./scripts/create-service-principal.sh```

## Register AAD Apps to use with the cluster

Since the cluster will be integrated with Azure Active Directory, you need to register a client and server apps to authenticate users. Follow this [document](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration) to complete the steps.

## Fill in environment parameters

In order to use the scripts in this repo, you need to fill in the parameters in the file [parameters.sh](scripts/parameters.sh). Once you have filled all variables, you may proceed with the documentation.

## Create virtual network

Next you will need an existing virtual network and a subnet to deploy the cluster and the WAF. Next, you'll need to grant contributor role access to the service principal to manage the subnet. If you already have a virtual network and a subnet, you may skip this step and, but make sure [parameters.sh](scripts/parameters.sh) file reflects your current configuration. Run the following commands:

```
bash ./scripts/create-vnet.sh
bash ./scripts/service-principal-role-assignments.sh
```

## Create cluster

Now you will create the AKS cluster. Run the folloeing command:

```bash ./scripts/create-cluster.sh```

## Create Web Application Firewall

Once the cluster has been created, you can create the firewall. Azure App Firewall v2 runs nginx in the backend and therefore is much faster than its predecesor. Currently it requires a public IP in the initial configuration for it to be deployed successfully, so in order to use the private IP and block Internet access we have deployed a Network Security Group in the [create-vnet.sh](scripts/create-vnet.sh) script. If you already had a virtual network and skipped the vnet script, you may have to manually add a subnet for the WAF and create the NSG to limit Internet access. For more information, open the file [create-vnet.sh](scripts/create-vnet.sh) and go to the documentation link for more details.

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
