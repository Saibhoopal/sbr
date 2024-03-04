#!/bin/bash
# These variables will be changed by terraform configuration script: terraform-deploy-full-aws-env/config_scripts/config_red5pro_terraform.sh  #
# NODE_SM_IP
# NODE_SM_API_TOKEN
# NODE_API_TOKEN
# NODE_CLUSTER_TOKEN
# NODE_ROUND_TRIP_AUTH_ENABLE
# NODE_ROUND_TRIP_AUTH_HOST
# NODE_ROUND_TRIP_AUTH_PORT
# NODE_ROUND_TRIP_AUTH_PROTOCOL
# NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID
# NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID
# NODE_SRT_RESTREAMER_ENABLE

RED5_HOME="/usr/local/red5pro"
LOGS_S3_BUCKET=""

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

config_api(){   # ADDED TO API --> debug.logaccess=true
    log_i "Config API"
    if [ -z "$NODE_API_TOKEN" ]; then
        log_e "Parameter NODE_API_TOKEN is empty. EXIT."
        exit 1
    fi
    local token_pattern='security.accessToken='
    local debug_logaccess_pattern='debug.logaccess=false'
    local token_new="security.accessToken=${NODE_API_TOKEN}"
    local debug_logaccess='debug.logaccess=true'
    sudo sed -i -e "s|$token_pattern|$token_new|" -e "s|$debug_logaccess_pattern|$debug_logaccess|" "$RED5_HOME/webapps/api/WEB-INF/red5-web.properties"
    echo " " >> $RED5_HOME/webapps/api/WEB-INF/security/hosts.txt
    echo "*" >> $RED5_HOME/webapps/api/WEB-INF/security/hosts.txt
}

config_node(){
    log_i "Config NODE"

    if [ -z "$NODE_SM_IP" ]; then
        log_w "Parameter NODE_SM_IP is empty, EXIT"
        exit 1
    fi
    if [ -z "$NODE_CLUSTER_TOKEN" ]; then
        log_e "Parameter NODE_CLUSTER_TOKEN is empty. EXIT."
        exit 1
    fi

    local ip_pattern='http://0.0.0.0:5080/streammanager/cloudwatch'
    local ip_new="http://${NODE_SM_IP}:5080/streammanager/cloudwatch"
    local autoscale_pattern='<property name="active" value="false"/>'
    local autoscale_true='<property name="active" value="true"/>'

    sudo sed -i -e "s|$ip_pattern|$ip_new|" -e "s|$autoscale_pattern|$autoscale_true|" "$RED5_HOME/conf/autoscale.xml"

    local sm_pass_pattern='<property name="password" value="changeme" />'
    local sm_pass_new='<property name="password" value="'${NODE_CLUSTER_TOKEN}'" />'

    sudo sed -i -e "s|$sm_pass_pattern|$sm_pass_new|" "$RED5_HOME/conf/cluster.xml"

    local cw_reporting='<property name="reportingSpeed" value="10000"/>'
    local cw_reporting_new='<property name="reportingSpeed" value="20000"/>'
    sudo sed -i -e "s|$cw_reporting|$cw_reporting_new|"  "$RED5_HOME/conf/autoscale.xml"
    sudo sed -i -e '225 i \\t<property name="maximumDryTime" value="300000"/>' "$RED5_HOME/conf/red5-common.xml"

    log_i "Delete unnecessary folders:"
    rm -r $RED5_HOME/webapps/api $RED5_HOME/webapps/bandwidthdetection $RED5_HOME/webapps/inspector $RED5_HOME/webapps/streammanager $RED5_HOME/webapps/template $RED5_HOME/webapps/videobandwidth

    log_i "Delete unnecessary plugins"
    rm $RED5_HOME/plugins/red5pro-mpegts-plugin-*.jar
    rm $RED5_HOME/plugins/red5pro-socialpusher-plugin-*.jar
    rm $RED5_HOME/plugins/inspector.jar
}

rpro_app_live_auth_config(){
    log_i "Red5pro Round Trip Authentication configuration ..."
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
    if [[ "$var_error" == "1" ]]; then
        log_e "One or more variables are empty. EXIT!"
        exit 1
    fi

    log_i "Configuration Live App red5-web.properties with MOCK Round trip server ..."
    {
        echo "server.validateCredentialsEndPoint=${NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID}"
        echo "server.invalidateCredentialsEndPoint=${NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID}"
        echo "server.host=${NODE_ROUND_TRIP_AUTH_HOST}"
        echo "server.port=${NODE_ROUND_TRIP_AUTH_PORT}"
        echo "server.protocol=${NODE_ROUND_TRIP_AUTH_PROTOCOL}://"
    } >> $RED5_HOME/webapps/live/WEB-INF/red5-web.properties

    log_i "Uncomment Round trip auth in the Live app: red5-web.xml"
    sudo sed -i '/uncomment below for Round Trip Authentication/{n;d;}' "$RED5_HOME/webapps/live/WEB-INF/red5-web.xml"
    sudo sed -i '$!N;/\n.*uncomment above for Round Trip Authentication/!P;D' "$RED5_HOME/webapps/live/WEB-INF/red5-web.xml"
}

rpro_app_live_srt_config(){
    log_i "Red5Pro SRT Restreaming configuration ..."

    local STR1="<servlet>\n<servlet-name>RestreamerServlet</servlet-name>\n<servlet-class>com.red5pro.restreamer.servlet.RestreamerServlet</servlet-class>\n</servlet>\n<servlet-mapping>\n<servlet-name>RestreamerServlet</servlet-name>\n<url-pattern>/restream</url-pattern>\n</servlet-mapping>"

    sudo sed -i "/<\/web-app>/i $STR1" "$RED5_HOME/webapps/live/WEB-INF/web.xml"

    local enable_srtingest_pattern='enable.srtingest=.*'
    local enable_srtingest_new="enable.srtingest=true"

    sudo sed -i -e "s|$enable_srtingest_pattern|$enable_srtingest_new|" "$RED5_HOME/conf/restreamer-plugin.properties"
}


test_set_mem(){

    local phymem=$(free -m|awk '/^Mem:/{print $2}') # Value in Mb
    local mem=$((phymem/1024)); # Value in Gb

    if [[ "$mem" -le 2 ]]; then
        MEMORY=1;
        elif [[ "$mem" -gt 2 && "$mem" -le 4 ]]; then
        MEMORY=2;
    else
        MEMORY=$((mem-2));
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

check_node_type(){
    log_i "Check node type role..."

    for i in {1..30}
    do
        log_i "Cycle $i from 30 "
    my_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)
    log_i "Node public IP: $my_ip"

    node_group_name=$(curl -s "http://${NODE_SM_IP}:5080/streammanager/api/4.0/admin/nodegroup?accessToken=${NODE_SM_API_TOKEN}" |jq -r '.[].name')
    curl -s "http://${NODE_SM_IP}:5080/streammanager/api/4.0/admin/nodegroup/${node_group_name}/node?accessToken=${NODE_SM_API_TOKEN}" | jq -r '.[] | [.address, .role] | join(" ")' > node_roles_temp.txt

    while read line; do
        ip=$(echo "$line" | awk '{print $1}')
        if [ "$ip" == "$my_ip" ]; then
            role=$(echo "$line" | awk '{print $2}')
            log_i "Node IP: $ip, Node role: $role"
        fi
    done < node_roles_temp.txt

        if [ -n "$role" ]; then
            log_i "Node IP: $ip, Node role: $role"
            break
        fi

        if [[ "$i" == "30" ]]; then
            log_e "Can't get correct Node role type. Exit!!!"
            exit 1
        fi
        sleep 30
    done
}

config_origin_node(){
    log_i "Run Origin node configuration"
    INSTANCE_ID=$(ec2metadata --instance-id)
    region=$(ec2metadata --availability-zone | sed 's/.$//')
    CURRENT_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
    NEW_NAME="$CURRENT_NAME-origin"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$NEW_NAME"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Node_Type,Value=origin   
    sudo aws s3 cp s3://$LOGS_S3_BUCKET/config.json /opt/aws/amazon-cloudwatch-agent/bin/
    sudo sed -i 's/{instance_id}/origin_{instance_id}/g' /opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo tee -a /tmp/ec2-termination.sh <<EOF
#!/bin/bash
/usr/local/bin/aws s3api put-object --bucket $LOGS_S3_BUCKET --key origin_$(ec2metadata --instance-id)/
/usr/local/bin/aws s3 sync /usr/local/red5pro/log/ s3://$LOGS_S3_BUCKET/origin_$(ec2metadata --instance-id)/
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

    rm $RED5_HOME/plugins/red5pro-restreamer-plugin-*.jar
}

config_edge_node(){
    log_i "Run Edge node configuration"
    INSTANCE_ID=$(ec2metadata --instance-id)
    region=$(ec2metadata --availability-zone | sed 's/.$//')
    CURRENT_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
    NEW_NAME="$CURRENT_NAME-edge"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$NEW_NAME"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Node_Type,Value=edge   
    sudo aws s3 cp s3://$LOGS_S3_BUCKET/config.json /opt/aws/amazon-cloudwatch-agent/bin/
    sudo sed -i 's/{instance_id}/edge_{instance_id}/g' /opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo tee -a /tmp/ec2-termination.sh <<EOF
#!/bin/bash
/usr/local/bin/aws s3api put-object --bucket $LOGS_S3_BUCKET --key edge_$(ec2metadata --instance-id)/
/usr/local/bin/aws s3 sync /usr/local/red5pro/log/ s3://$LOGS_S3_BUCKET/edge_$(ec2metadata --instance-id)/
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

    rm $RED5_HOME/plugins/red5pro-restreamer-plugin-*.jar
}

config_transcoder_node(){
    log_i "Run Transcoder node configuration"
    INSTANCE_ID=$(ec2metadata --instance-id)
    region=$(ec2metadata --availability-zone | sed 's/.$//')
    CURRENT_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
    NEW_NAME="$CURRENT_NAME-transcoder"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$NEW_NAME"
    aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Node_Type,Value=transcoder    
    sudo aws s3 cp s3://$LOGS_S3_BUCKET/config.json /opt/aws/amazon-cloudwatch-agent/bin/
    sudo sed -i 's/{instance_id}/transcoder_{instance_id}/g' /opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo systemctl enable amazon-cloudwatch-agent.service
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo tee -a /tmp/ec2-termination.sh <<EOF
#!/bin/bash
/usr/local/bin/aws s3api put-object --bucket $LOGS_S3_BUCKET --key transcoder_$(ec2metadata --instance-id)/
/usr/local/bin/aws s3 sync /usr/local/red5pro/log/ s3://$LOGS_S3_BUCKET/transcoder_$(ec2metadata --instance-id)/
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
sudo sed -i '65d;69d;70d;71d;72d;74d' $RED5_HOME/webapps/live/WEB-INF/red5-web.xml
}

config_relay_node(){
    log_i "Run Relay node configuration"
}

config_node
install_red5pro_service

if [[ $NODE_ROUND_TRIP_AUTH_ENABLE == "true" || $NODE_ROUND_TRIP_AUTH_ENABLE == "1" ]]; then
    rpro_app_live_auth_config
else
    log_i "Round trip auth disable. Skip Auth configuration."
fi

if [[ $NODE_SRT_RESTREAMER_ENABLE == "true" || $NODE_SRT_RESTREAMER_ENABLE == "1" ]]; then
    rpro_app_live_srt_config
else
    log_i "Red5Pro SRT Restreaming disable. Skip configuration."
fi

check_node_type

case $role in
    origin) config_origin_node ;;
    edge) config_edge_node ;;
    transcoder) config_transcoder_node ;;
    relay) config_relay_node ;;
    *) log_w "Wrong Node role type: $role" ;;
esac

start_red5pro
