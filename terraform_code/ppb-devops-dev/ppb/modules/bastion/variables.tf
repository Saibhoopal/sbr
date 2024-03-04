variable "environment" {
  type = string
}
variable "key_name" {
  type = string
}
variable "project" {
  type = string
}
variable "common_tags" {
  type = map(string)
}
variable "bastion_windows_ami" {
  type = string 
}
variable "bastion_instance_type" {
  type = string
}
variable "bastion_subnet_ids" {
  type = list(string)
}
variable "bastion_sg_ids" {
  type = list(string)
}
variable "instance_profile" {
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
variable "bastion_eip_assoc_ids" {
  type = list(string)
}
