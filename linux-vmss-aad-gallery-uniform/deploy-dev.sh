#! /usr/bin/env bash

# update with your environment
az account set --subscription <replace_with_your_subscrption_id>
az account show

terraform fmt
terraform init -reconfigure
terraform validate

terraform plan -var-file=dev.tfvars -out='planfile'
# terraform apply "planfile"
