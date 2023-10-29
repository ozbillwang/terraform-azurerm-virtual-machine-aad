# adjust with your environment
subscription=<replace_with_your_subscrption_id>
bastionName="<replace_with_bastion_name>"
bastionRG="<replace_with_bastion_resource_group>"

# replace with the virtual machine name and its resource group.
vmName="vm-dev-4134"
vmRG="vm-dev-4134"

az account set -s ${subscription}
az account show

vmId=$(az vm list --resource-group ${vmRG} --query "[?name=='$vmName'].id" --output tsv)
echo $vmId

az network bastion ssh --name "${bastionName}" --resource-group "${bastionRG}" --target-resource-id "${vmId}" --auth-type AAD
