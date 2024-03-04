#!/bin/bash

terraform init

terraform validate -no-color

variable_apply="apply"
variable_deploy="deploy_args"

apply_value=$(curl --silent --header "Authorization: Bearer ${TF_API_TOKEN}" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=${org_name}&filter%5Bworkspace%5D%5Bname%5D=${TF_WORKSPACE}" | jq -r ".data[] | select(.attributes.key == \"$variable_apply\") | .attributes.value")

deploy_value=$(curl --silent --header "Authorization: Bearer ${TF_API_TOKEN}" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=${org_name}&filter%5Bworkspace%5D%5Bname%5D=${TF_WORKSPACE}" | jq -r ".data[] | select(.attributes.key == \"$variable_deploy\") | .attributes.value")

if [ "$deploy_value" = '""' ]; then
    echo "variable $variable_deploy is set to the empty string"
    if [ "$apply_value" = "true" ]; then    
	echo "variable $variable_apply is set to $apply_value, skipping terraform plan & proceeding with terraform apply to both modules"
        terraform apply -auto-approve #-no-color
    else    
	echo "variable $variable_apply is set to $apply_value proceeding with terraform plan to both modules"
        terraform plan -no-color
    fi
else
	echo "variable $variable_deploy has the value: $deploy_value"
        if [ "$apply_value" = "true" ]; then	
        echo "variable $variable_apply is set to $apply_value, skipping terraform plan & proceeding with terraform apply to $deploy_value"
        terraform apply -auto-approve $deploy_value
    else    
        echo "$variable_apply: is set to $apply_value proceeding with terraform plan to $deploy_value"
        terraform plan -no-color $deploy_value
    fi
fi

#terraform plan -no-color -target=module.west1.module.cinegy_ae6_main -target=module.west1.module.cinegy_ae6_backup -target=module.west1.module.cinegy_ae7_main -target=module.west1.module.cinegy_ae7_backup

#terraform apply -target=module.west2.module.red5pro -target=module.west1.module.cinegy_ae6_backup -target=module.west1.module.cinegy_ae7_main -target=module.west1.module.cinegy_ae7_backup

############terraform destroy -auto-approve -target=module.west1.module.cinegy_ae6_main
