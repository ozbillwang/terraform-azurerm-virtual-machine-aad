#! /usr/bin/env bash

# Check if the number of command-line arguments is equal to 2
if [ "$#" -eq 2 ]; then
    # Assign the first command-line argument to the first_param variable
    subscription_id="$1"
    # Assign the second command-line argument to the second_param variable
    env="$2"

    echo "First Parameter: ${subscription_id}"
    echo "Second Parameter: ${env}"
else
    # If the number of command-line arguments is not 2, display an error message
    echo "Error: Please provide two parameters."
    echo "Usage: $0 <subscription_id> <env_for_tfvar>"
    exit 1  # Exit with an error code
fi

admin_password=$(pwgen -s -1 16)
export TF_VAR_admin_password=${admin_password}
# save admin password locally for reference only
echo $admin_password > password-$(date +%Y%m%d%H%M%S)

# update with your subscription
az account set --subscription ${subscription_id}
az account show

terraform fmt
terraform init -reconfigure
terraform validate
terraform plan -var-file=${env}.tfvars -out='planfile'
# terraform apply "planfile"
# terraform destroy -var-file=${env}.tfvars
