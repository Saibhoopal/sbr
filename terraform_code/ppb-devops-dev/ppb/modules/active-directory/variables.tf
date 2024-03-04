
variable "domain_name" {
  type = string
}
variable "domain_admin_password" {
  type = string
}
variable "directory_type" {
  type = string
}
variable "directory_edition" {
  type = string
}
variable "enable_ad" {
  type = bool
}
variable "vpc_id" {
  type = string
}
variable "windows_ami" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ad_sg" {
  type = list(string)
}
variable "key_name" {
  type = string
}
variable "env_name" {
  type = string
}
variable "instance_profile" {
  type = string
}
variable "primary_domain_controller" {
  type = string
}
variable "secondary_domain_controller" {
  type = string
}
variable "ADdomain" {
  type = string
}
variable "domain_secret_name" {
  type = string
}
