#!/usr/bin/env bash

# replace with your vm detail
subscription=<replace_with_your_subscrption_id>
bastionName="<replace_with_bastion_name>"
bastionRG="<replace_with_bastion_resource_group>"

#vmssName="vm-dev-aa6f-vmss"
vmRG="vmss-dev-aa6f"
vmName="vmss-dev-aa6f"

# main
az account set -s ${subscription}
az account show

#vmId=$(az vmss list-instances --resource-group ${vmRG} --name ${vmssName} --query "[?name=='$vmName'].id" --output tsv)
vmId=$(az vm list --resource-group ${vmRG} --query "[?name=='$vmName'].id" --output tsv)
echo $vmId

az network bastion ssh --name "${bastionName}" --resource-group "${bastionRG}" --target-resource-id "${vmId}" --auth-type AAD
