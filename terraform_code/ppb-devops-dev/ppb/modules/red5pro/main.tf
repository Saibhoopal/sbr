
data "aws_vpc" "red5pro_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "all_subnets" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

data "aws_ami" "red5pro_image" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.red5pro_image_name]
  }
}

data "aws_ami" "red5pro_terraform_image" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.red5pro_terraform_image_name]
  }
}

#####################################################################################
# MySQL DataBase subnet group (AWS RDS)
resource "aws_db_subnet_group" "red5pro_mysql_subnet_group" {
  name       = "${var.project}-${var.environment}-${var.service}-mysql-subnet-group"
  subnet_ids = var.public_subnets
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-mysql-subnet-group"
  })
}

##### MySQL DataBase parameter group (AWS RDS)
resource "aws_db_parameter_group" "red5pro_mysql_pg" {
  name   = "${var.project}-${var.environment}-${var.service}-mysql-pg"
  family = "mysql8.0"

  parameter {
    name  = "max_connections"
    value = "100000"
  }
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-mysql-pg"
  })
}

###### MySQL DataBase (AWS RDS)
resource "aws_db_instance" "red5pro_mysql" {
  #db_name                = "red5proautoscalingmysql"
  identifier             = "${var.project}-${var.environment}-${var.service}-mysql"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.mysql_instance_type
  username               = var.mysql_user_name
  password               = var.mysql_password
  parameter_group_name   = aws_db_parameter_group.red5pro_mysql_pg.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.red5pro_mysql_subnet_group.name
  vpc_security_group_ids = var.red5pro_mysql_sg_id
  multi_az               = true
  backup_retention_period = 3
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-mysql"
  })
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "${var.project}-${var.environment}-${var.service}-terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

####################################################################################
# Autoscaling Stream Managers (AWS EC2)
####################################################################################

resource "aws_launch_template" "red5pro_sm_lt" {
  name                   = "${var.project}-${var.environment}-${var.service}-sm-lt"
  image_id               = data.aws_ami.red5pro_image.id
  instance_type          = var.red5pro_sm_instance_type
  key_name               = var.red5pro_ssh_key_name
  iam_instance_profile {
    name = var.instance_profile
  }
  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.red5pro_sm_sg_id  
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.red5pro_sm_volume_size
      volume_type = "gp3"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-${var.environment}-${var.service}-streammanager"
    })
  }

  user_data = base64encode(<<EOT
#!/bin/bash
mkdir /home/ubuntu/config_scripts
cd /home/ubuntu/config_scripts
sudo apt-get update -y
sudo apt-get install awscli -y
Region=${var.aws_region}
INSTANCE_ID=$(ec2metadata --instance-id)
Allocation_id_a=${var.red5pro_sm_eip_allocation_id_a}
Allocation_id_b=${var.red5pro_sm_eip_allocation_id_b}
AZ=$(ec2metadata --availability)
if [[ $Region == "eu-west-1" ]]
then
  if [[ $AZ == "eu-west-1a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
else
  if [[ $AZ == "eu-west-2a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
fi
sudo aws s3 cp s3://${var.bucket_name}/config_red5pro_sm.sh .
export DB_HOST=${aws_db_instance.red5pro_mysql.address}
export DB_PORT=${aws_db_instance.red5pro_mysql.port}
export DB_USER=${aws_db_instance.red5pro_mysql.username}
export DB_PASSWORD=${aws_db_instance.red5pro_mysql.password}
export RED5PRO_NODE_PREFIX_NAME=${var.red5pro_node_prefix_name}
export RED5PRO_NODE_CLUSTER_TOKEN=${var.red5pro_node_cluster_token}
export RED5PRO_NODE_API_TOKEN=${var.red5pro_node_api_token}
export RED5PRO_SM_API_TOKEN=${var.red5pro_sm_api_token}
export TERRA_HOST=${aws_lb.red5pro_ts_nlb.dns_name}
export TERRA_PORT=${var.red5pro_terraform_port}
export TERRA_API_TOKEN=${var.red5pro_terraform_api_token}
export LOGS_S3_BUCKET=${var.s3_bucket_for_red5pro_logs}
sudo chmod +x /home/ubuntu/config_scripts/config_red5pro_sm.sh
sudo -E bash /home/ubuntu/config_scripts/config_red5pro_sm.sh
EOT
  )
}

resource "aws_placement_group" "red5pro_sm_pg" {
  name     = "${var.project}-${var.environment}-${var.service}-sm-pg"
  strategy = "partition" 
}

resource "aws_autoscaling_group" "red5pro_sm_ag" {
  name                = "${var.project}-${var.environment}-${var.service}-sm-asg"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  placement_group     = aws_placement_group.red5pro_sm_pg.id
  vpc_zone_identifier = var.public_subnets
  launch_template {
    id      = aws_launch_template.red5pro_sm_lt.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key = "Platform:Environment"
    value = var.environment
    propagate_at_launch = true
  }
  tag {
    key = "Platform:BusinessVertical"
    value = "Retail"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:TLA"
    value = "OTT"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:CostCode"
    value = "61997"
    propagate_at_launch = true
  }
  tag {
    key = "aws-inspector"
    value = "bypass"
    propagate_at_launch = true
  }
  tag {
    key = "service"
    value = var.service
    propagate_at_launch = true
  }
  tag {
    key="monitoring"
    value= "true"
    propagate_at_launch=true
  }

}

data "aws_acm_certificate" "red5pro_sm_cert" {
  domain   = var.ssl_certificate_domain
  statuses = ["ISSUED"]
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-acm-cert"
  })
}

############## SM ###########################################
# Autoscaling Stream Managers (AWS EC2) SNS
#############################################################

resource "aws_autoscaling_notification" "red5pro_sm_notification" {
  group_names = [
    aws_autoscaling_group.red5pro_sm_ag.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.red5pro_sm.arn
}

resource "aws_sns_topic" "red5pro_sm" {
  name = "${var.project}-${var.environment}-${var.service}-sm-failure"
  display_name = "${var.project}-${var.environment}-${var.service}-sm-failure"

  # arn is an exported attribute
}
resource "aws_sns_topic_subscription" "red5pro_sm_topic" {
  topic_arn = aws_sns_topic.red5pro_sm.arn
  protocol  = "email"
  endpoint  = "teamsupport@tyrellcct.com"
}

###################  NLB FOR Stream Manager ##############

resource "aws_lb" "red5pro_sm_nlb" {
  name               = "${var.project}-${var.environment}-${var.service}-sm-nlb"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = true
  access_logs {
    enabled = true
    bucket= var.s3_bucket_for_lb_logs
    prefix = var.s3_bucket_prefix
  }

  subnet_mapping {
    subnet_id            = var.public_subnet_a
    allocation_id = var.sm_nlb_eip_allocation_id_a
  }

  subnet_mapping {
    subnet_id            = var.public_subnet_b
    allocation_id = var.sm_nlb_eip_allocation_id_b
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-sm-nlb"
  })
}

resource "aws_lb_target_group" "red5pro_sm_nlb_tg" {
  name        = "${var.project}-${var.environment}-${var.service}-sm-nlb-tg"
  target_type = "instance"
  port        = 5080
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
    port = 5080
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-sm-nlb-tg"
  })
}

resource "aws_lb_listener" "red5pro_sm_tcp" {
  load_balancer_arn = aws_lb.red5pro_sm_nlb.arn
  port              = "5080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red5pro_sm_nlb_tg.arn
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-sm-nlb-listener"
  })
}

resource "aws_lb_listener" "red5pro_sm_tls" {
  load_balancer_arn = aws_lb.red5pro_sm_nlb.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = data.aws_acm_certificate.red5pro_sm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red5pro_sm_nlb_tg.arn
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-sm-nlb-listener"
  })
}

resource "aws_autoscaling_attachment" "red5pro_sm_aa" {
  autoscaling_group_name = aws_autoscaling_group.red5pro_sm_ag.id
  lb_target_group_arn    = aws_lb_target_group.red5pro_sm_nlb_tg.arn
}

####################################################################################
# Autoscaling Node Managers (AWS EC2)
####################################################################################
resource "aws_launch_template" "red5pro_nm_lt" {
  name                   = "${var.project}-${var.environment}-${var.service}-nm-lt"
  image_id               = data.aws_ami.red5pro_image.id
  instance_type          = var.red5pro_sm_instance_type
  key_name               = var.red5pro_ssh_key_name
  iam_instance_profile {
    name = var.instance_profile
  }
  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.red5pro_sm_sg_id
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.red5pro_sm_volume_size
      volume_type = "gp3"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-${var.environment}-${var.service}-nodemanager"
    })
  }

  user_data = base64encode(<<EOT
#!/bin/bash
mkdir /home/ubuntu/config_scripts
cd /home/ubuntu/config_scripts
sudo apt-get update -y
sudo apt-get install awscli -y
Region=${var.aws_region}
INSTANCE_ID=$(ec2metadata --instance-id)
Allocation_id_a=${var.red5pro_nm_eip_allocation_id_a}
Allocation_id_b=${var.red5pro_nm_eip_allocation_id_b}
AZ=$(ec2metadata --availability)
if [[ $Region == "eu-west-1" ]]
then
  if [[ $AZ == "eu-west-1a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
else
  if [[ $AZ == "eu-west-2a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
fi
sudo aws s3 cp s3://${var.bucket_name}/config_red5pro_nm.sh .
export DB_HOST=${aws_db_instance.red5pro_mysql.address}
export DB_PORT=${aws_db_instance.red5pro_mysql.port}
export DB_USER=${aws_db_instance.red5pro_mysql.username}
export DB_PASSWORD=${aws_db_instance.red5pro_mysql.password}
export RED5PRO_NODE_PREFIX_NAME=${var.red5pro_node_prefix_name}
export RED5PRO_NODE_CLUSTER_TOKEN=${var.red5pro_node_cluster_token}
export RED5PRO_NODE_API_TOKEN=${var.red5pro_node_api_token}
export RED5PRO_SM_API_TOKEN=${var.red5pro_sm_api_token}
export TERRA_HOST=${aws_lb.red5pro_ts_nlb.dns_name}
export TERRA_PORT=${var.red5pro_terraform_port}
export TERRA_API_TOKEN=${var.red5pro_terraform_api_token}
export LOGS_S3_BUCKET=${var.s3_bucket_for_red5pro_logs}
sudo chmod +x /home/ubuntu/config_scripts/config_red5pro_nm.sh
sudo -E bash /home/ubuntu/config_scripts/config_red5pro_nm.sh
EOT
  )
}

resource "aws_placement_group" "red5pro_nm_pg" {
  name     = "${var.project}-${var.environment}-${var.service}-nm-pg"
  strategy = "partition" # cluster
}

resource "aws_autoscaling_group" "red5pro_nm_ag" {
  name                = "${var.project}-${var.environment}-${var.service}-nm-asg"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  placement_group     = aws_placement_group.red5pro_nm_pg.id
  vpc_zone_identifier = var.public_subnets
  launch_template {
    id      = aws_launch_template.red5pro_nm_lt.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key = "Platform:Environment"
    value = var.environment
    propagate_at_launch = true
  }
  tag {
    key = "Platform:BusinessVertical"
    value = "Retail"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:TLA"
    value = "OTT"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:CostCode"
    value = "61997"
    propagate_at_launch = true
  }
  tag {
    key = "aws-inspector"
    value = "bypass"
    propagate_at_launch = true
  }
  tag {
    key = "service"
    value = var.service
    propagate_at_launch = true
  }
  #tag {
   # key="Monitoring"
   # value= "true"
    #propagate_at_launch=true
  #}
}

############## NM ###########################################
# Autoscaling Node Managers (AWS EC2) SNS
################################################################

resource "aws_autoscaling_notification" "red5pro_nm_notification" {
  group_names = [
    aws_autoscaling_group.red5pro_nm_ag.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.red5pro_nm.arn
}

resource "aws_sns_topic" "red5pro_nm" {
  name = "${var.project}-${var.environment}-${var.service}-nm-failure"
  display_name = "${var.project}-${var.environment}-${var.service}-nm-failure"

  # arn is an exported attribute
}
resource "aws_sns_topic_subscription" "red5pro_nm_topic" {
  topic_arn = aws_sns_topic.red5pro_nm.arn
  protocol  = "email"
  endpoint  = "teamsupport@tyrellcct.com"
}

################## NLB for Node Manager ##########################
resource "aws_lb_target_group" "red5pro_nm_nlb_tg" {
  name        = "${var.project}-${var.environment}-${var.service}-nm-nlb-tg"
  target_type = "instance"
  port        = 5080
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
    port = 5080
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-nm-nlb-tg"
  })
}

resource "aws_lb" "red5pro_nm_nlb" {
  name               = "${var.project}-${var.environment}-${var.service}-nm-nlb"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = true
  access_logs {
    enabled = true
    bucket= var.s3_bucket_for_lb_logs
    prefix = var.s3_bucket_prefix
  }
  subnet_mapping {
    subnet_id            = var.public_subnet_a  
    allocation_id = var.nm_nlb_eip_allocation_id_a
  }

  subnet_mapping {
    subnet_id            = var.public_subnet_b
    allocation_id = var.nm_nlb_eip_allocation_id_b
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-nm-nlb"
  })
}

resource "aws_lb_listener" "red5pro_nm_tcp" {
  load_balancer_arn = aws_lb.red5pro_nm_nlb.arn
  port              = "5080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red5pro_nm_nlb_tg.arn
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-nm-nlb-listener"
  })
}

resource "aws_autoscaling_attachment" "red5pro_nm_aa" {
  autoscaling_group_name = aws_autoscaling_group.red5pro_nm_ag.id
  lb_target_group_arn    = aws_lb_target_group.red5pro_nm_nlb_tg.arn
}
####################################################################################
# Autoscaling terraform-service (AWS EC2)
####################################################################################

####### SSH key pair generation
resource "tls_private_key" "temp_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

###### Add SSH key pair to AWS
resource "aws_key_pair" "temp_ssh_key" {
  key_name   = "${var.project}-${var.environment}-${var.service}-temp-ssh-key-${formatdate("YYMMDDhhmmss", timestamp())}"
  public_key = tls_private_key.temp_ssh_key.public_key_openssh

  lifecycle {
    ignore_changes = all
  }
}

data "aws_key_pair" "red5pro_ssh_key" {
  key_name           = var.red5pro_ssh_key_name
  include_public_key = true
}

resource "aws_launch_template" "red5pro_ts_lt" {
  name                   = "${var.project}-${var.environment}-${var.service}-ts-lt"
  image_id               = data.aws_ami.red5pro_terraform_image.id
  instance_type          = var.red5pro_terraform_instance_type
  key_name               = aws_key_pair.temp_ssh_key.key_name
  iam_instance_profile {
    name = var.instance_profile
  }
  update_default_version = true

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.red5pro_terraform_sg_id 
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.red5pro_terraform_volume_size
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-${var.environment}-${var.service}-terraform-service"
    })
  }

  user_data = base64encode(<<EOT
#!/bin/bash
echo '${data.aws_key_pair.red5pro_ssh_key.public_key}' >> /home/ubuntu/.ssh/authorized_keys
mkdir /home/ubuntu/config_scripts
cd /home/ubuntu/config_scripts
sudo apt-get update -y
sudo apt-get install awscli -y
Region=${var.aws_region}
INSTANCE_ID=$(ec2metadata --instance-id)
Allocation_id_a=${var.red5pro_ts_eip_allocation_id_a}
Allocation_id_b=${var.red5pro_ts_eip_allocation_id_b}
AZ=$(ec2metadata --availability)
if [[ $Region == "eu-west-1" ]]
then
  if [[ $AZ == "eu-west-1a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
else
  if [[ $AZ == "eu-west-2a" ]]
  then
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_a --allow-reassociation --region $Region
  else
    aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $Allocation_id_b --allow-reassociation --region $Region
  fi
fi
sudo aws s3 cp s3://${var.bucket_name}/config_red5pro_node.sh .
sudo aws s3 cp s3://${var.bucket_name}/config_red5pro_terraform.sh .
export TERRA_PORT='${var.red5pro_terraform_port}'
export TERRA_API_TOKEN='${var.red5pro_terraform_api_token}'
export TERRA_PARALLELISM='${var.red5pro_terraform_parallelism}'
export DB_HOST='${aws_db_instance.red5pro_mysql.address}'
export DB_PORT='${aws_db_instance.red5pro_mysql.port}'
export DB_USER='${aws_db_instance.red5pro_mysql.username}'
export DB_PASSWORD='${aws_db_instance.red5pro_mysql.password}'
export AWS_ACCESS_KEY='${var.access_key_aws}'
export AWS_SECRET_KEY='${var.secret_key_aws}'
export AWS_VPC_ID='${var.vpc_id}'
export AWS_SECURITY_GROUP_NAME='${var.red5pro_node_sg_id}'
export AWS_SSH_KEY='${var.red5pro_ssh_key_name}'
export AWS_VOLUME_SIZE='${var.red5pro_node_volume_size}'
export AWS_ENVIRONMENT='${var.environment}'
export NODE_TAG_ORGANISATION='${var.tag_organisation}'
export NODE_TAG_BUSINESS_VERTICAL='${var.tag_business_vertical}'
export NODE_TAG_TLA='${var.tag_tla}'
export NODE_TAG_COST_CODE='${var.tag_cost_code}'
export NODE_TAG_CREATEDBY='${var.tag_createdby}'
export NODE_TAG_AWS_INSPECTOR='${var.tag_aws_inspector}'
export NODE_TAG_SERVICE='${var.tag_service}'
export NODE_INSTANCE_PROFILE='${var.instance_profile}'
export NODE_SM_IP='${aws_lb.red5pro_nm_nlb.dns_name}'
export NODE_SM_API_TOKEN='${var.red5pro_sm_api_token}'
export NODE_API_TOKEN='${var.red5pro_node_api_token}'
export NODE_CLUSTER_TOKEN='${var.red5pro_node_cluster_token}'
export NODE_ROUND_TRIP_AUTH_ENABLE='${var.red5pro_node_round_trip_auth}'
export NODE_ROUND_TRIP_AUTH_HOST='${var.red5pro_node_round_trip_auth_host}'
export NODE_ROUND_TRIP_AUTH_PORT='${var.red5pro_node_round_trip_auth_port}'
export NODE_ROUND_TRIP_AUTH_PROTOCOL='${var.red5pro_node_round_trip_auth_protocol}'
export NODE_ROUND_TRIP_AUTH_ENDPOINT_VALID='${var.red5pro_node_round_trip_auth_endpoint_valid}'
export NODE_ROUND_TRIP_AUTH_ENDPOINT_INVALID='${var.red5pro_node_round_trip_auth_endpoint_invalid}'
export NODE_SRT_RESTREAMER_ENABLE='${var.red5pro_node_srt_restreamer}'
export bucket_name_for_statefile='${var.bucket_name_for_statefile}'
export bucket_folder_path_for_statefile='${var.bucket_folder_path_for_statefile}'
export terraform_state_lock_dynamodb_name='${var.terraform_state_lock_dynamodb_name}'
export bucket_region_for_statefile='${var.bucket_region_for_statefile}'
export LOGS_S3_BUCKET='${var.s3_bucket_for_red5pro_logs}'
export NODES_LOGS_S3_BUCKET='${var.s3_bucket_for_red5pro_nodes_logs}'
sudo chmod +x /home/ubuntu/config_scripts/config_red5pro_terraform.sh
sudo -E bash /home/ubuntu/config_scripts/config_red5pro_terraform.sh
EOT
  )
}

resource "aws_placement_group" "red5pro_ts_pg" {
  name     = "${var.project}-${var.environment}-${var.service}-terraform-pg"
  strategy = "partition" 
}

resource "aws_autoscaling_group" "red5pro_ts_asg" {
  name                = "${var.project}-${var.environment}-${var.service}-ts-asg"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  placement_group     = aws_placement_group.red5pro_ts_pg.id
  vpc_zone_identifier = var.public_subnets
  launch_template {
    id      = aws_launch_template.red5pro_ts_lt.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key = "Platform:Environment"
    value = var.environment
    propagate_at_launch = true
  }
  tag {
    key = "Platform:BusinessVertical"
    value = "Retail"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:TLA"
    value = "OTT"
    propagate_at_launch = true
  }
  tag {
    key = "Platform:CostCode"
    value = "61997"
    propagate_at_launch = true
  }
  tag {
    key = "aws-inspector"
    value = "bypass"
    propagate_at_launch = true
  }
  tag {
    key = "service"
    value = var.service
    propagate_at_launch = true
  }
  tag {
    key="monitoring"
    value= "true"
    propagate_at_launch=true
  }
}

resource "aws_lb" "red5pro_ts_nlb" {
  name               = "${var.project}-${var.environment}-${var.service}-ts-nlb"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = true
  access_logs {
    enabled = true
    bucket= var.s3_bucket_for_lb_logs
    prefix = var.s3_bucket_prefix
  }
  subnet_mapping {
    subnet_id            = var.public_subnet_a
    allocation_id = var.ts_nlb_eip_allocation_id_a
  }

  subnet_mapping {
    subnet_id            = var.public_subnet_b
    allocation_id = var.ts_nlb_eip_allocation_id_b
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-ts-nlb"
  })
}

############## TS ###########################################
# Autoscaling Terraform server (AWS EC2) SNS
################################################################

resource "aws_autoscaling_notification" "red5pro_ts_notification" {
  group_names = [
    aws_autoscaling_group.red5pro_ts_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.red5pro_ts.arn
}

resource "aws_sns_topic" "red5pro_ts" {
  name = "${var.project}-${var.environment}-${var.service}-ts-failure"
  display_name = "${var.project}-${var.environment}-${var.service}-ts-failure"

  # arn is an exported attribute
}
resource "aws_sns_topic_subscription" "red5pro_ts_topic" {
  topic_arn = aws_sns_topic.red5pro_ts.arn
  protocol  = "email"
  endpoint  = "teamsupport@tyrellcct.com"
}

################## NLB for Terraform server ##########################

resource "aws_lb_target_group" "red5pro_ts_nlb_tg" {
  name        = "${var.project}-${var.environment}-${var.service}-ts-nlb-tg"
  target_type = "instance"
  port        = 8083
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port = 8083
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-ts-nlb-tg"
  })
}

resource "aws_lb_listener" "red5pro_ts_tcp" {
  load_balancer_arn = aws_lb.red5pro_ts_nlb.arn
  port              = "8083"
  protocol          = "TCP" 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red5pro_ts_nlb_tg.arn
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.service}-ts-lb-listener"
  })
}

resource "aws_autoscaling_attachment" "red5pro_terraform_aa" {
  autoscaling_group_name = aws_autoscaling_group.red5pro_ts_asg.id
  lb_target_group_arn    = aws_lb_target_group.red5pro_ts_nlb_tg.arn
}
