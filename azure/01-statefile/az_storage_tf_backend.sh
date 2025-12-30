#!/bin/bash

RESOURCE_GROUP_NAME="tfstate"
LOCATION="centralindia"
STORAGE_ACCOUNT_NAME="vstfstatestorage"
CONTAINER_NAME="tfstate"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS

# Create storage blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME