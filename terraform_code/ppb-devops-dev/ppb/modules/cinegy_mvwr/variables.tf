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
variable "cinegy_mvwr_name" {
  type = string
}
variable "common_tags" {
  type = map(string)
}
variable "cinegy_private_subnet_ids" {
  type = list(string)
}
variable "cinegy_sg_ids" {
  type = list(string)
}
variable "windows_ami_name" {
  type = string
}
variable "cinegy_multiviewer_instance_type" {
  type = string
}
 
variable "instance_profile" {
  type = string
}
variable "key_name" { 
  type = string
}
variable "bucket_name" {
  type = string
}
variable "cinegy_license_address" {
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
variable "R53Domain" {
  type = string
}

variable "multiviewer_Recordset_subdomain_prefix" {
  type = string
}
variable "Cinegy_Mainmvwr_Layout_S3path" {
  type = string
}
variable "Cinegy_Mainmvwr_Config_S3path" {
  type = string
}
variable "Cinegy_Backupmvwr_Layout_S3path" {
  type = string
}
variable "Cinegy_Backupmvwr_Config_S3path" {
  type = string
}
variable "AirengineName" {
  type = string
}
