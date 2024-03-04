#!/bin/bash

CURRENT_DIRECTORY=$(pwd)
TERRA_FOLDER="/usr/local/red5service"

log_i() {
    log
    printf "\033[0;32m [INFO]  --- %s \033[0m\n" "${@}"
}
log_w() {
    log
    printf "\033[0;35m [WARN] --- %s \033[0m\n" "${@}"
}
log_e() {
    log
    printf "\033[0;31m [ERROR]  --- %s \033[0m\n" "${@}"
}
log() {
    echo -n "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

config_terraform_service(){
    log_i "Red5Pro terraform service configuration"

    if [ -z "$TERRA_API_TOKEN" ]; then
        log_w "Variable TERRA_API_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$TERRA_PARALLELISM" ]; then
        log_w "Variable TERRA_PARALLELISM is empty."
        var_error=1
    fi
    if [ -z "$DB_HOST" ]; then
        log_w "Variable DB_HOST is empty."
        var_error=1
    fi
    if [ -z "$DB_PORT" ]; then
        log_w "Variable DB_PORT is empty."
        var_error=1
    fi
    if [ -z "$DB_USER" ]; then
        log_w "Variable DB_USER is empty."
        var_error=1
    fi
    if [ -z "$DB_PASSWORD" ]; then
        log_w "Variable DB_PASSWORD is empty."
        var_error=1
    fi
    if [ -z "$AWS_ACCESS_KEY" ]; then
        log_w "Variable AWS_ACCESS_KEY is empty."
        var_error=1
    fi
    if [ -z "$AWS_SECRET_KEY" ]; then
        log_w "Variable AWS_SECRET_KEY is empty."
        var_error=1
    fi
    if [ -z "$AWS_VPC_ID" ]; then
        log_w "Variable AWS_VPC_ID is empty."
        var_error=1
    fi
    if [ -z "$AWS_PUBLIC_SUBNETS" ]; then
        log_w "Variable AWS_PUBLIC_SUBNETS is empty."
        var_error=1
    fi
    if [ -z "$AWS_SECURITY_GROUP_NAME" ]; then
        log_w "Variable AWS_SECURITY_GROUP_NAME is empty."
        var_error=1
    fi
    if [ -z "$AWS_SSH_KEY" ]; then
        log_w "Variable AWS_SSH_KEY is empty."
        var_error=1
    fi
    if [ -z "$AWS_VOLUME_SIZE" ]; then
        log_w "Variable AWS_VOLUME_SIZE is empty."
        var_error=1
    fi
    if [ -z "$AWS_ENVIRONMENT" ]; then
        log_w "Variable AWS_ENVIRONMENT is empty."
        var_error=1
    fi
    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"
        exit 1
    fi

    local terra_api_token_pattern='api.accessToken=.*'
    local terra_api_token_new="api.accessToken=${TERRA_API_TOKEN}"

    local terra_parallelism_pattern='terra.parallelism=.*'
    local terra_parallelism_new="terra.parallelism=${TERRA_PARALLELISM}"

    local db_host_pattern='config.dbHost=.*'
    local db_host_new="config.dbHost=${DB_HOST}"

    local db_port_pattern='config.dbPort=.*'
    local db_port_new="config.dbPort=${DB_PORT}"

    local db_user_pattern='config.dbUser=.*'
    local db_user_new="config.dbUser=${DB_USER}"

    local db_password_pattern='config.dbPass=.*'
    local db_password_new="config.dbPass=${DB_PASSWORD}"

    local aws_access_key_pattern='cloud.aws_access_key=.*'
    local aws_access_key_new="cloud.aws_access_key=${AWS_ACCESS_KEY}"

    local aws_secret_key_pattern='cloud.aws_secret_key=.*'
    local aws_secret_key_new="cloud.aws_secret_key=${AWS_SECRET_KEY}"

    local aws_vpc_id_pattern='cloud.aws_vpc_id=.*'
    local aws_vpc_id_new="cloud.aws_vpc_id=${AWS_VPC_ID}"

    local aws_subnet_id_pattern='cloud.aws_subnet_id=.*'
    local aws_subnet_id_new="cloud.aws_subnet_id=${AWS_PUBLIC_SUBNETS}"

    local aws_ec2_security_group_pattern='cloud.aws_ec2_security_group=.*'
    local aws_ec2_security_group_new="cloud.aws_ec2_security_group=${AWS_SECURITY_GROUP_NAME}"

    local aws_ec2_key_pair_pattern='cloud.aws_ec2_key_pair=.*'
    local aws_ec2_key_pair_new="cloud.aws_ec2_key_pair=${AWS_SSH_KEY}"

    local aws_ec2_volume_size_pattern='cloud.aws_ec2_volume_size=.*'
    local aws_ec2_volume_size_new="cloud.aws_ec2_volume_size=${AWS_VOLUME_SIZE}"

    local aws_env_pattern='cloud.aws_environment=.*'
    local aws_env_new="cloud.aws_environment=${AWS_ENVIRONMENT}"

    sudo sed -i -e "s|$terra_api_token_pattern|$terra_api_token_new|" -e "s|$terra_parallelism_pattern|$terra_parallelism_new|" -e "s|$db_host_pattern|$db_host_new|" -e "s|$db_port_pattern|$db_port_new|" -e "s|$db_user_pattern|$db_user_new|" -e "s|$db_password_pattern|$db_password_new|" -e "s|$aws_access_key_pattern|$aws_access_key_new|" -e "s|$aws_secret_key_pattern|$aws_secret_key_new|" -e "s|$aws_vpc_id_pattern|$aws_vpc_id_new|" -e "s|$aws_subnet_id_pattern|$aws_subnet_id_new|" -e "s|$aws_ec2_security_group_pattern|$aws_ec2_security_group_new|" -e "s|$aws_ec2_key_pair_pattern|$aws_ec2_key_pair_new|" -e "s|$aws_ec2_volume_size_pattern|$aws_ec2_volume_size_new|" -e "s|$aws_env_pattern|$aws_env_new|" "$TERRA_FOLDER/application.properties"

###############################################
    if [ -z "$NODE_INSTANCE_PROFILE" ]; then
        log_w "Variable NODE_INSTANCE_PROFILE is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_ORGANISATION" ]; then
        log_w "Variable NODE_TAG_ORGANISATION is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_BUSINESS_VERTICAL" ]; then
        log_w "Variable NODE_TAG_BUSINESS_VERTICAL is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_TLA" ]; then
        log_w "Variable NODE_TAG_TLA is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_COST_CODE" ]; then
        log_w "Variable NODE_TAG_COST_CODE is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_CREATEDBY" ]; then
        log_w "Variable NODE_TAG_CREATEDBY is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_AWS_INSPECTOR" ]; then
        log_w "Variable NODE_TAG_AWS_INSPECTOR is empty."
        var_error=1
    fi
    if [ -z "$NODE_TAG_SERVICE" ]; then
        log_w "Variable NODE_TAG_SERVICE is empty."
        var_error=1
    fi    
    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"
        exit 1
    fi

    local node_instance_profile_pattern='cloud.node_instance_profile=.*'
    local node_instance_profile_new="cloud.node_instance_profile=${NODE_INSTANCE_PROFILE}"

    local node_tag_organisation_pattern='cloud.node_tag_organisation=.*'
    local node_tag_organisation_new="cloud.node_tag_organisation=${NODE_TAG_ORGANISATION}"

    local node_tag_business_vertical_pattern='cloud.node_tag_business_vertical=.*'
    local node_tag_business_vertical_new="cloud.node_tag_business_vertical=${NODE_TAG_BUSINESS_VERTICAL}"

    local node_tag_tla_pattern='cloud.node_tag_tla=.*'
    local node_tag_tla_new="cloud.node_tag_tla=${NODE_TAG_TLA}"

    local node_tag_cost_code_pattern='cloud.node_tag_cost_code=.*'
    local node_tag_cost_code_new="cloud.node_tag_cost_code=${NODE_TAG_COST_CODE}"

    local node_tag_createdby_pattern='cloud.node_tag_createdby=.*'
    local node_tag_createdby_new="cloud.node_tag_createdby=${NODE_TAG_CREATEDBY}"

    local node_tag_aws_inspector_pattern='cloud.node_tag_aws_inspector=.*'
    local node_tag_aws_inspector_new="cloud.node_tag_aws_inspector=${NODE_TAG_AWS_INSPECTOR}"

    local node_tag_service_pattern='cloud.node_tag_service=.*'
    local node_tag_service_new="cloud.node_tag_service=${NODE_TAG_SERVICE}"                        

    sudo sed -i -e "s|$node_instance_profile_pattern|$node_instance_profile_new|" -e "s|$node_tag_organisation_pattern|$node_tag_organisation_new|" -e "s|$node_tag_business_vertical_pattern|$node_tag_business_vertical_new|" -e "s|$node_tag_tla_pattern|$node_tag_tla_new|" -e "s|$node_tag_cost_code_pattern|$node_tag_cost_code_new|" -e "s|$node_tag_createdby_pattern|$node_tag_createdby_new|" -e "s|$node_tag_aws_inspector_pattern|$node_tag_aws_inspector_new|" -e "s|$node_tag_service_pattern|$node_tag_service_new|" "$TERRA_FOLDER/application.properties"    
}

config_terraform_service_extra(){

statefile_bucket='bucket =.*'
statefile_bucket_new="bucket = ${bucket_name_for_statefile}"

statefile_bucket_folder_path='key = ""'
statefile_bucket_folder_path_new="key = ${bucket_folder_path_for_statefile}"

state_lock_dynamodb='dynamodb_table =.*'
state_lock_dynamodb_new="dynamodb_table = ${terraform_state_lock_dynamodb_name}" 

statefile_bucket_region='region =.*'
statefile_bucket_region_new="region = ${bucket_region_for_statefile}"

sudo sed -i -e "s|$statefile_bucket|$statefile_bucket_new|" -e "s|$statefile_bucket_folder_path|$statefile_bucket_folder_path_new|" -e "s|$state_lock_dynamodb|$state_lock_dynamodb_new|" -e "s|$statefile_bucket_region|$statefile_bucket_region_new|"  "$TERRA_FOLDER/providers.tf"

sudo git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
sudo tfenv install 1.5.2
sudo tfenv use  1.5.2
cd $TERRA_FOLDER
sudo terraform init
}

config_red5pro_node_vars(){
    log_i "Red5Pro node variables configuration."

    if [ -z "$NODE_SM_IP" ]; then
        log_w "Variable NODE_SM_IP is empty."
        var_error=1
    fi
    if [ -z "$NODE_SM_API_TOKEN" ]; then
        log_w "Variable NODE_SM_API_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$NODE_API_TOKEN" ]; then
        log_w "Variable RED5PRO_NODE_API_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$NODE_CLUSTER_TOKEN" ]; then
        log_w "Variable RED5PRO_NODE_CLUSTER_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_ENABLE" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_ENABLE is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_HOST" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_HOST is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_PORT" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_PORT is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_PROTOCOL" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_PROTOCOL is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID is empty."
        var_error=1
    fi
    if [ -z "$NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID" ]; then
        log_w "Variable NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID is empty."
        var_error=1
    fi
    if [ -z "$NODE_SRT_RESTREAMER_ENABLE" ]; then
        log_w "Variable NODE_SRT_RESTREAMER_ENABLE is empty."
        var_error=1
    fi

    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"
        exit 1
    fi

    local node_sm_ip_pattern='# NODE_SM_IP'
    local node_sm_ip_new="NODE_SM_IP=${NODE_SM_IP}"

    local node_sm_token_pattern='# NODE_SM_API_TOKEN'
    local node_sm_token_new="NODE_SM_API_TOKEN=${NODE_SM_API_TOKEN}"

    local node_api_token_pattern='# NODE_API_TOKEN'
    local node_api_token_new="NODE_API_TOKEN=${NODE_API_TOKEN}"

    local node_cluster_token_pattern='# NODE_CLUSTER_TOKEN'
    local node_cluster_token_new="NODE_CLUSTER_TOKEN=${NODE_CLUSTER_TOKEN}"

    local node_rta_pattern='# NODE_ROUND_TRIP_AUTH_ENABLE'
    local node_rta_new="NODE_ROUND_TRIP_AUTH_ENABLE=${NODE_ROUND_TRIP_AUTH_ENABLE}"

    local node_rta_host_pattern='# NODE_ROUND_TRIP_AUTH_HOST'
    local node_rta_host_new="NODE_ROUND_TRIP_AUTH_HOST=${NODE_ROUND_TRIP_AUTH_HOST}"

    local node_rta_port_pattern='# NODE_ROUND_TRIP_AUTH_PORT'
    local node_rta_port_new="NODE_ROUND_TRIP_AUTH_PORT=${NODE_ROUND_TRIP_AUTH_PORT}"

    local node_rta_protocol_pattern='# NODE_ROUND_TRIP_AUTH_PROTOCOL'
    local node_rta_protocol_new="NODE_ROUND_TRIP_AUTH_PROTOCOL=${NODE_ROUND_TRIP_AUTH_PROTOCOL}"

    local node_rta_valid_pattern='# NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID'
    local node_rta_valid_new="NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID=${NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID}"

    local node_rta_invalid_pattern='# NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID'
    local node_rta_invalid_new="NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID=${NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID}"

    local node_srt_pattern='# NODE_SRT_RESTREAMER_ENABLE'
    local node_srt_new="NODE_SRT_RESTREAMER_ENABLE=${NODE_SRT_RESTREAMER_ENABLE}"

    local nodes_logs_s3_bucket='LOGS_S3_BUCKET=""'
    local nodes_logs_s3_bucket_new="LOGS_S3_BUCKET=${NODES_LOGS_S3_BUCKET}"

    sudo sed -i -e "s|$node_sm_ip_pattern|$node_sm_ip_new|" -e "s|$node_sm_token_pattern|$node_sm_token_new|" -e "s|$node_api_token_pattern|$node_api_token_new|" -e "s|$node_cluster_token_pattern|$node_cluster_token_new|" -e "s|$node_rta_pattern|$node_rta_new|" -e "s|$node_rta_host_pattern|$node_rta_host_new|" -e "s|$node_rta_port_pattern|$node_rta_port_new|" -e "s|$node_rta_protocol_pattern|$node_rta_protocol_new|" -e "s|$node_rta_valid_pattern|$node_rta_valid_new|" -e "s|$node_rta_invalid_pattern|$node_rta_invalid_new|" -e "s|$node_srt_pattern|$node_srt_new|" -e "s|$nodes_logs_s3_bucket|$nodes_logs_s3_bucket_new|" "$TERRA_FOLDER/config_red5pro_node.sh"

}

copy_node_config_script(){
    log_i "Copy node configuration script: config_red5pro_node.sh to $TERRA_FOLDER"

    config_script="$CURRENT_DIRECTORY/config_red5pro_node.sh"

    if [ -f "$config_script" ]; then
        mv "$config_script" $TERRA_FOLDER/
        chmod +x $TERRA_FOLDER/config_red5pro_node.sh
    else
        log_e "File $config_script was not found. Exit!"
        exit 1
    fi
}


start_terraform_service(){
    log_i "Start Terraform service"

    sudo systemctl restart red5proterraform.service
    if [ "0" -eq $? ]; then
        log_i "Terraform service started!"
    else
        log_e "Terraform service didn't start!!!"
        exit 1
    fi
}

red5pro_logs_config_extra(){
    ############## Cloudwatch agent configuration ######################
    INSTANCE_ID=$(ec2metadata --instance-id)
    new_var=$(ec2metadata --availability-zone | rev | cut -c 1-2 | rev)
    CURRENT_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
    NEW_NAME="$CURRENT_NAME-$new_var"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$NEW_NAME"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Node_Type,Value=terraform_service 
    sudo aws s3 cp s3://$LOGS_S3_BUCKET/config.json /opt/aws/amazon-cloudwatch-agent/bin/
    sudo sed -i 's/{instance_id}/terraform_service_{instance_id}/g' /opt/aws/amazon-cloudwatch-agent/bin/config.json    
    sudo sed -i 's#/usr/local/red5pro/log/*#/usr/local/red5service/red5.log#g' /opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status 

########### termination logs to s3 ######################
sudo tee -a /tmp/ec2-termination.sh <<EOF
#!/bin/bash
/usr/local/bin/aws s3api put-object --bucket $LOGS_S3_BUCKET --key terraform_service_$(ec2metadata --instance-id)/
/usr/local/bin/aws s3 cp /usr/local/red5service/red5.log s3://$LOGS_S3_BUCKET/terraform_service_$(ec2metadata --instance-id)/
EOF
sudo chmod +x /tmp/ec2-termination.sh
sudo tee -a /etc/systemd/system/run-before-shutdown.service <<EOF
[Unit]
Description=Run my custom task at shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/tmp/ec2-termination.sh
TimeoutStartSec=0
    
[Install]
WantedBy=shutdown.target
EOF
sudo systemctl daemon-reload    
sudo systemctl enable run-before-shutdown.service

}

config_terraform_service
config_terraform_service_extra
copy_node_config_script
config_red5pro_node_vars
start_terraform_service
red5pro_logs_config_extra
