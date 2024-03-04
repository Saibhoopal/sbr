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
variable "cinegy_ae_name" {
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
variable "cinegy_air_instance_type" {
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

variable "air_Recordset_subdomain_prefix" {
  type = string
}

variable "Cinegy_AEMain_Config_0_S3path" {
  type = string
}
variable "Cinegy_AEMain_Config_1_S3path" {
  type = string
}
variable "Cinegy_AEBackup_Config_0_S3path" {
  type = string
}
variable "Cinegy_AEBackup_Config_1_S3path" {
  type = string
}
variable "AirengineName" {
  type = string
}
variable "Cinegy_AudioMatrix_Config_S3path" {
  type = string
}
variable "Cinegy_Air_Version" {
  type = string
}
