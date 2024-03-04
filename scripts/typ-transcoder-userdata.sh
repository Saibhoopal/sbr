#!/bin/bash
sudo apt-get update -y
sudo apt  install awscli -y
sudo apt  install jq -y 
# Extract information about the Instance
Instance_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
Availability_Zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/) # for private /local-ipv4
Hosted_Zone=$(aws route53 list-hosted-zones-by-name | jq --arg name "dev-tyrellcct.com." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id' | awk 'BEGIN {FS = "/" } ; {print $3}') #Z0250290JVEI9OXRC1IL
HZ=$(echo ${Hosted_Zone} | awk '{print $1}')

############ Recordset Creation ###############################

if [ $Availability_Zone = "eu-west-1a" ]
then
# Update Route 53 Record Set based on the Name tag to the current Public IP address of the Instance
      aws route53 change-resource-record-sets --hosted-zone-id $HZ --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"typ-transcoder1a.dev-tyrellcct.com","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
else
      aws route53 change-resource-record-sets --hosted-zone-id $HZ --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"typ-transcoder1b.dev-tyrellcct.com","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
fi

################ Domain Join ###################################

Computer_Object=Computer-transc
Domain_Admin=Admin
Passwd=$(aws secretsmanager get-secret-value --secret-id domain_admin_password --region eu-west-1 --query SecretString --output text | jq -r .domain_admin_password)
apt install -y sssd-ad sssd-tools realmd adcli
echo "[libdefaults]\n\tdefault_realm = TYRELLCCT.LOCAL\n\trdns = false" > /etc/krb5.conf
apt install -y krb5-user sssd-krb5
hostnamectl set-hostname $Computer_Object.tyrellcct.local
echo $Passwd | realm join -v -U $Domain_Admin tyrellcct.local

########### Install CloudWatch Agent #######################

wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
apt-get update && apt-get install collectd -y

##########security group modification ########

transcoder_sg_id_1=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-transcoder-sg-1 --output json | jq -r .SecurityGroups[].GroupId)

transcoder_sg_id_2=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-transcoder-sg-2 --output json | jq -r .SecurityGroups[].GroupId)

aws ec2 modify-instance-attribute --instance-id $Instance_ID --region eu-west-1 --groups $transcoder_sg_id_1 $transcoder_sg_id_2 


########## extra #########
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)

sm_sg_id_1=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-sm-sg --output json | jq -r .SecurityGroups[].GroupId)

edge_sg_id_1=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-edge-sg-1 --output json | jq -r .SecurityGroups[].GroupId)

origin_sg_id_1=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-origin-sg-1 --output json | jq -r .SecurityGroups[].GroupId)

for sg_id in $edge_sg_id_1 $origin_sg_id_1 $sm_sg_id_1
do
    for port in 1935 5080 8554
    do
        aws ec2 authorize-security-group-ingress --region eu-west-1 --group-id $i --protocol tcp --port $j --cidr $MY_IP/32
        aws ec2 authorize-security-group-egress --region eu-west-1 --group-id $i --protocol tcp --port $j --cidr $MY_IP/32
    done
done    

######### for ad-ports ######
sm_sg_id_2=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-sm-sg --output json | jq -r .SecurityGroups[].GroupId)

edge_sg_id_2=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-edge-sg-1 --output json | jq -r .SecurityGroups[].GroupId)

origin_sg_id_2=$(aws ec2 describe-security-groups --region eu-west-1 --filter Name=group-name,Values=typ-red5-dev-pri-origin-sg-1 --output json | jq -r .SecurityGroups[].GroupId)

for sg_id in $edge_sg_id_2 $origin_sg_id_2 $sm_sg_id_2
do
   ######## for tcp ports ############
    for port in 53 88 135 139 389 445 1024-65535
    do
        aws ec2 authorize-security-group-ingress --region eu-west-1 --group-id $sg_id --protocol tcp --port $port --cidr $MY_IP/32
        aws ec2 authorize-security-group-egress --region eu-west-1 --group-id $sh_id --protocol tcp --port $port --cidr $MY_IP/32
    done
  ####### for udp ports #############  
    for port in 53 88 123 137 138 289 445 	
    do
        aws ec2 authorize-security-group-ingress --region eu-west-1 --group-id $sg_id --protocol udp --port $port --cidr $MY_IP/32
        aws ec2 authorize-security-group-egress --region eu-west-1 --group-id $sg_id --protocol udp --port $port --cidr $MY_IP/32
    done
done 

sleep 100

#for i in 10.1.101.0/24 10.1.102.0/24
#do  	
#    for j in 1935 5080 8554
#    do 
#        aws ec2 authorize-security-group-ingress --region eu-west-1 --group-id $transcoder_sg_id --protocol tcp --port $j --cidr $i
#        aws ec2 authorize-security-group-egress --region eu-west-1 --group-id $transcoder_sg_id --protocol tcp --port $j --cidr $i
#    done 
#done



