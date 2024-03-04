
variable "vpc_id" {
  description = "vpc for security group"
  type = string
}

variable "project" {
  type = string
  description = "Name of the project, it will be using for services namings and tags" 
}

variable "environment" {
  type = string
  description = "Environment name of deployment, it will be using for services namings and tags"
}
variable "common_tags" {
  type = map(string)
  description = "common tages for aws resources"
}

variable "vpc_cidr_range" {
 type = list(string)
 description = "vpc cider range for security groups"  
}

variable "public_subnet_cidr_range" {
  type = list(string)
  description = "public sunbet cidr range"
}

############ red5pro env variables ###############

variable "ppb_internet_access_pl" {
  type = list(string)
  description = "prifixlist for internet access"
}

variable "ppb_cloudflare_pl" {
  type = list(string)
  description = "cloudfalre prefixlist"
}

variable "ppb_network_pl" {
  type = list(string)
  description = "network prefixlist to access the windows and linux servers" 
}

variable "retailott_red5pro_pl" {
  type = list(string)
  description = "prefixlist contains list of eip for red5pro autoscalling nodes"
}
variable "retailott_support_pl" {
  type = list(string)
  description = "prefixlist contains list of ips of ppb support teams"
}
variable "retail_shops_pl" {
  type = list(string)
  description = "prefixlist contains list of ips of Retail shops"
}
variable "shared_account_cidr_range" {
  type = list(string)
  description = "shared accout cidr ranges for access shared account resources"
}
variable "monitoring_subnet_range" {
  type = list(string)
  description = "subnet cidr range of monitoring vpc" 
}
