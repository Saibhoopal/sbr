
###################### AWS authetification variables
variable "access_key_aws" {
  description = "AWS IAM access key (VPC full access EC2 full access, RDS full access)"
  type = string
}
variable "secret_key_aws" {
  description = "AWS IAM secret key"
  type = string
}

#################################### AWS general variables
variable "aws_region" {
  description = "AWS region for your deployment"
  type = string  
}
variable "project" {
  type = string
  description = "name of the project"
}
variable "service" {
  description = "Name of your deployment, it will be using for services namings"
  type = string 
}
variable "environment" {
  description = "Environment name of your deployment, it will be using for services namings and tags"
  type = string 
}
variable "vpc_id" {
  description = "VPC ID, this VPC should have minimum 2 public subnets."
  type = string 
}
variable "ssl_certificate_domain" {
  description = "SSL Certificate name, this certificate will be using for the Load Balancer."
  type        = string 
}
variable "red5pro_ssh_key_name" {
  description = "SSH key pair name, this SSH key will be using in all instances."
  type        = string 
}

#################### DB MySQL variables #############################

variable "mysql_instance_type" {
  description = "AWS RDS instance type for MySQL DataBase"
  type        = string 
}
variable "mysql_user_name" {
  description = "MySQL username"
  type        = string 
}
variable "mysql_password" {
  description = "MySQL password"
  type        = string 
}

################### Red5Pro Stream Manager variables ##############################

variable "red5pro_image_name" {
  description = "Red5Pro image name created by AWS image builder"
  type        = string 
}
variable "red5pro_sm_instance_type" {
  description = "Stream Managers instance type"
  type        = string 
}
variable "red5pro_sm_volume_size" {
  description = "Stream Managers volume size"
  type        = string 
}
variable "red5pro_sm_api_token" {
  description = "Stream Manager API token"
  type        = string  
}

################ Terraform service variables  ##########################

variable "red5pro_terraform_image_name" {
  description = "Red5Pro Terraform service image name created by AWS image builder"
  type        = string  
}
variable "red5pro_terraform_instance_type" {
  description = "Red5Pro Terraform service instance type"
  type        = string   
}
variable "red5pro_terraform_volume_size" {
  description = "Red5Pro Terraform service volume size"
  type        = string 
}
variable "red5pro_terraform_port" {
  description = "Red5Pro Terraform service comunication port"
  type        = string 
}
variable "red5pro_terraform_api_token" {
  description = "Red5Pro Terraform service API token"
  type        = string 
}
variable "red5pro_terraform_parallelism" {
  description = "Red5Pro Terraform service parallelism (-parallelism=n)"
  type        = string  
}

############### Red5Pro node general variables (Origin, Edge, Transcoder)

variable "red5pro_node_volume_size" {
  description = "Red5Pro node volume size"
  type        = string  
}
variable "red5pro_node_cluster_token" {
  description = "Red5Pro node cluster comunication token"
  type        = string  
}
variable "red5pro_node_api_token" {
  description = "Red5Pro node API token"
  type        = string 
}

################ Red5Pro node round-trip authentication variables (round-trip auth plugin)

variable "red5pro_node_round_trip_auth" {
  description = "Red5Pro node round-trip authentication enable (true/false)"
  default     = false
}
variable "red5pro_node_round_trip_auth_host" {
  description = "Red5Pro node round-trip authentication server host"
  default     = "159.65.112.201"
}
variable "red5pro_node_round_trip_auth_port" {
  description = "Red5Pro node round-trip authentication server port"
  default     = "3000"
}
variable "red5pro_node_round_trip_auth_protocol" {
  description = "Red5Pro node round-trip authentication server protocol (http/https)"
  default     = "http"
}
variable "red5pro_node_round_trip_auth_endpoint_valid" {
  description = "Red5Pro node round-trip authentication server validate credentials endpoint. https://www.red5pro.com/docs/special/round-trip-auth/enabling-security/"
  default     = "/validateCredentials"
}
variable "red5pro_node_round_trip_auth_endpoint_invalid" {
  description = "Red5Pro node round-trip authentication server invalidate credentials endpoint. https://www.red5pro.com/docs/special/round-trip-auth/enabling-security/"
  default     = "/invalidateCredentials"
}

# Red5Pro node SRT variables (restreamer plugin)
variable "red5pro_node_srt_restreamer" {
  description = "Red5Pro node SRT restreamer enable (true/false). https://www.red5pro.com/docs/special/restreamer/overview/"
  default     = true
}

variable "instance_profile" {
  type = string
  description = "IAM role for the ec2 instances to access the resources in AWS"
}
variable "public_subnets" {
  type = list(string)
  description = "public subnet ids for the red5pro instances to deploy"
}
variable "red5pro_mysql_sg_id" {
  type = list(string)
  description = "security group for mysql db instance"
}
variable "red5pro_sm_sg_id" {
  type = list(string)
  description = "security group for Red5pro stream manager and stream manager nlb"
}
variable "red5pro_terraform_sg_id" {
  type = list(string)
  description = "security group for red5pro terraform service"
}
variable "red5pro_node_sg_id" {
  type = string
  description = "security group fo rthe autoscalling red5pro nodes"
}
variable "bucket_name" {
  type =string
  description = "s3 bucket name for red5pro services/instances to get userdata"  
}
variable "common_tags" { 
  type = map(string)
  description = "comman tags for all aws resources"
}
variable "public_subnet_a" {
  type = string
  description = "public subnet id of az-a for nlbs to use fixed eips from that az"
}
variable "public_subnet_b" {
  type = string
  description = "public subent id of az-b for nlbs to use fixed eips from that az"
}
variable "red5pro_sm_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for stream manager to have fixed eip for az-a"
}
variable "red5pro_sm_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for stream manager to have fixed eip for az-b"
}
variable "red5pro_nm_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for node manager to have fixed eip for az-a"
}
variable "red5pro_nm_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for node manager to have fixed eip for az-b"
}
variable "red5pro_ts_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for terraform server to have fixed eip for az-a"
}
variable "red5pro_ts_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for terraform server to have fixed eip for az-b"
}
variable "sm_nlb_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for stream manager NLB to have fixed eip for az-a"
}
variable "sm_nlb_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for stream manager NLB to have fixed eip for az-b"
}
variable "nm_nlb_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for stream manager NLB to have fixed eip for az-a"
}
variable "nm_nlb_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for stream manager NLB to have fixed eip for az-b"
}
variable "ts_nlb_eip_allocation_id_a" {
  type = string
  description = "eip allocation id for terraform server NLB to have fixed eip for az-a"
}
variable "ts_nlb_eip_allocation_id_b" {
  type = string
  description = "eip allocation id for terraform server NLB to have fixed eip for az-b"
}
variable "red5pro_node_prefix_name" {
  type = string
  description = "Red5pro autoscalling nodes prefix name (nodes identifier)"
}
variable "s3_bucket_for_lb_logs" {
  type =string
  description = "s3 bucket to store the stream manager/terraform server NLB logs" 
}
variable "s3_bucket_prefix" {
  type = string
  description = "s3 bucket prefix / folder name to store NLB logs"
}
variable "bucket_name_for_statefile" {
  type = string
  description = "bucket to store the nodes terraform statefile remotely"
}
variable "bucket_folder_path_for_statefile" {
  type = string
  description = "s3 bucket folder to store the nodes the terraform statefile"
}
variable "terraform_state_lock_dynamodb_name" {
  type = string
  description = "dynamodb for lock the red5pro terraform service state file"
}
variable "bucket_region_for_statefile" {
  type = string
  description = "aws region of the s3 bucket"
}
variable "s3_bucket_for_red5pro_logs" {
  type = string
  description = "s3 bucket to store the  red5pro components logs"
}
variable "s3_bucket_for_red5pro_nodes_logs" {
  type = string
  description = "s3 bucket to store the  red5pro nodes logs"
}
variable "tag_organisation" {
  type = string
}
variable "tag_business_vertical" {
  type = string
}
variable "tag_tla" {
  type = string
}
variable "tag_cost_code" {
  type = string
}
variable "tag_createdby" {
  type = string
}
variable "tag_aws_inspector" {
  type = string
}
variable "tag_service" {
  type = string
}
