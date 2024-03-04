variable "sis_config_ami" {
    description = "This is the snapshot image of the SIS-config server manually deployed to prod at build stage" #supply in ppb/var.tf
    type = string
}
variable "env_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "project" {
  type = string
}
variable "service" {
  type = string
}
variable "sis_config_name" {
  type = string
}
variable "key_name" { 
  type = string
}
variable "sis_config_instance_type" {
  type = string
}
variable "sis_config_sg_ids" {
  type = list(string)
}
variable "instance_profile" {
  type = string
}
variable "common_tags" {
  type = map(string)
}
variable "sis_config_subnet_ids" {
  type = list(string)
  description = "public subnet ids for the SIS-Config instances to deploy"
}
variable "aws_region" {
  description = "AWS region for your deployment"
  type = string 
}

variable "domain_secret_name" {
  type = string
}
variable "domain_admin_user" {
  type = string
}
variable "ADdomain" {
  type = string
}
variable "ADOU" { 
  type = string
}