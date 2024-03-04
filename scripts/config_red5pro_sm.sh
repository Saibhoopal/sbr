#!/bin/bash
RED5_HOME="/usr/local/red5pro"

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

smart_config_sm_properties_main(){
    log_i "Configuration Stream Manager general properties."

    smhost=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 | tr '[:upper:]' '[:lower:]')

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
    if [ -z "$RED5PRO_NODE_PREFIX_NAME" ]; then
        log_w "Variable RED5PRO_NODE_PREFIX_NAME is empty."
        var_error=1
    fi
    if [ -z "$RED5PRO_NODE_CLUSTER_TOKEN" ]; then
        log_w "Variable RED5PRO_NODE_CLUSTER_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$RED5PRO_NODE_API_TOKEN" ]; then
        log_w "Variable RED5PRO_NODE_API_TOKEN is empty."
        var_error=1
    fi
    if [ -z "$RED5PRO_SM_API_TOKEN" ]; then
        log_w "Variable RED5PRO_SM_API_TOKEN is empty."
        var_error=1
    fi

    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"

    fi

    local db_host_pattern='config.dbHost=.*'
    local db_host_new="config.dbHost=${DB_HOST}"

    local db_port_pattern='config.dbPort=.*'
    local db_port_new="config.dbPort=${DB_PORT}"

    local db_user_pattern='config.dbUser=.*'
    local db_user_new="config.dbUser=${DB_USER}"

    local db_pass_pattern='config.dbPass=.*'
    local db_pass_new="config.dbPass=${DB_PASSWORD}"

    local node_prefix_pattern='instancecontroller.instanceNamePrefix=.*'
    local node_prefix_new="instancecontroller.instanceNamePrefix=${RED5PRO_NODE_PREFIX_NAME}"

    local node_cluster_password_pattern='cluster.password=.*'
    local node_cluster_password_new="cluster.password=${RED5PRO_NODE_CLUSTER_TOKEN}"

    local sm_ip_pattern='streammanager.ip=.*'
    local sm_ip_new="streammanager.ip==${smhost}.com"

    local node_api_token_pattern='serverapi.accessToken=.*'
    local node_api_token_new="serverapi.accessToken=${RED5PRO_NODE_API_TOKEN}"

    local sm_rest_token_pattern='rest.administratorToken=.*'
    local sm_rest_token_new="rest.administratorToken=${RED5PRO_SM_API_TOKEN}"

    local sm_proxy_enabled_pattern='proxy.enabled=.*'
    local sm_proxy_enabled_new='proxy.enabled=true'

    sudo sed -i -e "s|$db_host_pattern|$db_host_new|" -e "s|$db_port_pattern|$db_port_new|" -e "s|$db_user_pattern|$db_user_new|" -e "s|$db_pass_pattern|$db_pass_new|" -e "s|$node_prefix_pattern|$node_prefix_new|" -e "s|$node_cluster_password_pattern|$node_cluster_password_new|" -e "s|$sm_ip_pattern|$sm_ip_new|" -e "s|$node_api_token_pattern|$node_api_token_new|" -e "s|$sm_rest_token_pattern|$sm_rest_token_new|" -e "s|$sm_proxy_enabled_pattern|$sm_proxy_enabled_new|" "$RED5_HOME/webapps/streammanager/WEB-INF/red5-web.properties"

#    local mpegts='<logger name="com.red5pro.mpegts.stream.TSHandler" level="INFO"/>'  
#    local mpegts_new='<logger name="com.red5pro.mpegts.stream.TSHandler" level="DEBUG"/>' 
#    sudo sed -i -e "s|$mpegts|$mpegts_new|" "$RED5_HOME/conf/logback.xml" 
}

smart_config_sm_properties_terra(){
    log_i "Configuration Stream Manager properties for AWS with terraform-service."

    if [ -z "$TERRA_HOST" ]; then
        log_w "Variable TERRA_HOST is empty."
        var_error=1
    fi
    if [ -z "$TERRA_PORT" ]; then
        log_w "Variable TERRA_PORT is empty."
        var_error=1
    fi
    if [ -z "$TERRA_API_TOKEN" ]; then
        log_w "Variable TERRA_API_TOKEN is empty."
        var_error=1
    fi
    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"
        exit 1
    fi

    local region_new="terra.regionNames=eu-central-1, eu-west-1, eu-west-2, us-west-1"
    local instance_name_new="terra.instanceName=aws_instance"
    local terra_host_new="terra.host=${TERRA_HOST}"
    local terra_port_new="terra.port=${TERRA_PORT}"
    local terra_token_new="terra.token=${TERRA_API_TOKEN}"

    sudo sed -i "/## TERRAFORM-CLOUD CONTROLLER CONFIGURATION##/a $region_new\n$instance_name_new\n$terra_host_new\n$terra_port_new\n$terra_token_new" "$RED5_HOME/webapps/streammanager/WEB-INF/red5-web.properties"
}

test_set_mem(){

    local phymem=$(free -m|awk '/^Mem:/{print $2}') # Value in Mb
    local mem=$((phymem/1024)); # Value in Gb

    if [[ "$mem" -le 2 ]]; then
        MEMORY=1;
        elif [[ "$mem" -gt 2 && "$mem" -le 4 ]]; then
        MEMORY=2;
    else
        MEMORY=$((mem-6));
    fi
    log_i "SET JVM MEMORY (-Xms-Xmx) ${MEMORY}GB"
}

install_red5pro_service(){
    log_i "Install Red5Pro service file"

    test_set_mem

    cp "$RED5_HOME/red5pro.service" /lib/systemd/system/red5pro.service

    local service_memory_pattern='-Xms2g -Xmx2g'
    local service_memory_new="-Xms${MEMORY}g -Xmx${MEMORY}g"

    sudo sed -i -e "s|$service_memory_pattern|$service_memory_new|" "/lib/systemd/system/red5pro.service"

    sudo systemctl enable red5pro.service
}

install_sm(){
    log_i "Delete unnecessary webapps"
    rm -r $RED5_HOME/webapps/api $RED5_HOME/webapps/bandwidthdetection $RED5_HOME/webapps/inspector $RED5_HOME/webapps/template $RED5_HOME/webapps/videobandwidth
    rm -r $RED5_HOME/conf/autoscale.xml $RED5_HOME/plugins/red5pro-autoscale-plugin-*.jar $RED5_HOME/plugins/red5pro-webrtc-plugin-*.jar

    log_i "Delete unnecessary plugins"
    rm $RED5_HOME/plugins/red5pro-mpegts-plugin-*.jar
    rm $RED5_HOME/plugins/red5pro-socialpusher-plugin-*.jar
    rm $RED5_HOME/plugins/inspector.jar
    rm $RED5_HOME/plugins/red5pro-restreamer-plugin-*.jar
}

config_sm_applicationContext(){
    log_i "Set aws-cloud-controller in $RED5_HOME/webapps/streammanager/WEB-INF/applicationContext.xml"

    local def_controller='<!-- Default CONTROLLER -->'
    local def_controller_new='<!-- Disabled: Default CONTROLLER --> <!--'

    local aws_controller='<!-- AWS CONTROLLER -->'
    local aws_controller_new='--> <!-- AWS CONTROLLER -->'

    local terra_controller_in='<!-- <bean id="apiBridge" class="com.red5pro.services.terraform.component.TerraformCloudController"'
    local terra_controller_in_new='<bean id="apiBridge" class="com.red5pro.services.terraform.component.TerraformCloudController"'

    local terra_controller_out='/> <property name="terraToken" value="${terra.token}"/> </bean> -->'
    local terra_controller_out_new='/> <property name="terraToken" value="${terra.token}"/> </bean>'

    sudo sed -i '' -e "s|$def_controller|$def_controller_new|" -e "s|$aws_controller|$aws_controller_new|" -e "s|$terra_controller_in|$terra_controller_in_new|" -e "s|$terra_controller_out|$terra_controller_out_new|" "$RED5_HOME/webapps/streammanager/WEB-INF/applicationContext.xml"
}

config_sm_cors(){
    log_i "Set CORS * in $RED5_HOME/webapps/streammanager/WEB-INF/web.xml"

    local STR1="<filter>\n<filter-name>CorsFilter</filter-name>\n<filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n<init-param>\n<param-name>cors.allowed.origins</param-name>\n<param-value>*</param-value>\n</init-param>\n<init-param>\n<param-name>cors.exposed.headers</param-name>\n<param-value>Access-Control-Allow-Origin</param-value>\n</init-param>\n<init-param>\n<param-name>cors.allowed.methods</param-name>\n<param-value>GET, POST, PUT, DELETE</param-value>\n</init-param>\n<async-supported>true</async-supported>\n</filter>"
    local STR2="\n<filter-mapping>\n<filter-name>CorsFilter</filter-name>\n<url-pattern>/api/*</url-pattern>\n</filter-mapping>"

    sudo sed -i "/<\/web-app>/i $STR1 $STR2" "$RED5_HOME/webapps/streammanager/WEB-INF/web.xml"
}

config_sm_extra(){
    log_i "Extra configuration Stream Manager..."
    log_w "Disable node group management in Stream Manager and transfer this role to the Node Manager."
    log_i "Config: $RED5_HOME/webapps/streammanager/WEB-INF/red5-web.properties"

    local group_time_pattern='instancecontroller.nodeGroupStateToleranceTime=.*'
    local group_time_new="instancecontroller.nodeGroupStateToleranceTime=2074000000"

    local node_time_pattern='instancecontroller.nodeStateToleranceTime=.*'
    local node_time_new="instancecontroller.nodeStateToleranceTime=2074000000"

    local cloud_interval_pattern='instancecontroller.cloudCleanupInterval=.*'
    local cloud_interval_new="instancecontroller.cloudCleanupInterval=2074000000"

    sudo sed -i -e "s|$group_time_pattern|$group_time_new|" -e "s|$node_time_pattern|$node_time_new|" -e "s|$cloud_interval_pattern|$cloud_interval_new|" "$RED5_HOME/webapps/streammanager/WEB-INF/red5-web.properties"
}

mysql_config(){
    log_i "Check MySQL Database cluster configuration.."
    RESULT=$(mysqlshow -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD | grep -o cluster)
    if [ "$RESULT" != "cluster" ]; then
        log_i "Start MySQL DB config ..."
        log_i "Creating DB cluster ..."
        mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE cluster;"
        log_i "Importing sql script to DB cluster ..."
        mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p${DB_PASSWORD} cluster < $RED5_HOME/webapps/streammanager/WEB-INF/sql/cluster.sql
    else
        log_i "Database cluster was configured by another StreamManager. Skip."
    fi
}

start_red5pro(){
    log_i "Start Red5Pro service"
    sudo systemctl daemon-reload
    sudo systemctl start red5pro
    if [ "0" -eq $? ]; then
        log_i "RED5PRO SERVICE started!"
    else
        log_e "RED5PRO SERVICE didn't start!!!"
        log_e "Please check file /lib/systemd/system/red5pro.service"
        exit 1
    fi
}

red5pro_logs_config_extra(){
    ###################cloudwatch agent configaration ################
    INSTANCE_ID=$(ec2metadata --instance-id)
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Node_Type,Value=stream_manager
    sudo aws s3 cp s3://$LOGS_S3_BUCKET/config.json /opt/aws/amazon-cloudwatch-agent/bin/
    sudo sed -i 's/{instance_id}/stream_manager_{instance_id}/g' /opt/aws/amazon-cloudwatch-agent/bin/config.json    
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
################# ec3 termination logs export to s3 ############
sudo tee -a /tmp/ec2-termination.sh <<EOF
#!/bin/bash
/usr/local/bin/aws s3api put-object --bucket $LOGS_S3_BUCKET --key stream_manager_$(ec2metadata --instance-id)/
/usr/local/bin/aws s3 sync /usr/local/red5pro/log/ s3://$LOGS_S3_BUCKET/stream_manager_$(ec2metadata --instance-id)/
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

install_sm
install_red5pro_service
config_sm_applicationContext
config_sm_cors
smart_config_sm_properties_main
smart_config_sm_properties_terra
config_sm_extra
mysql_config
start_red5pro
red5pro_logs_config_extra