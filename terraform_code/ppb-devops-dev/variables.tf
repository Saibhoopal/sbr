
variable "access_key_aws" {
  type = string
}
variable "secret_key_aws" {
  type = string
}
variable "windows_ami_name" {
  type = string
}

variable "red5pro_image_name_eu-west-1" {
  type = string
}
variable "red5pro_image_name_eu-west-2" {
  type = string
}
variable "red5pro_terraform_image_name_eu-west-1" {
  type = string
}
variable "red5pro_terraform_image_name_eu-west-2" {
  type = string
}
variable "mysql_password" {
  type = string
}
variable "red5pro_api_token_for_eu-west-1" {
  type = string
}
variable "red5pro_api_token_for_eu-west-2" {
  type = string
}

variable "retailott_red5pro_pl_eu-west-1" {
  type = list(string)
}
variable "retailott_red5pro_pl_eu-west-2" {
  type = list(string)
}
variable "retailott_support_pl_eu-west-1" {
  type = list(string)
}
variable "retailott_support_pl_eu-west-2" {
  type = list(string)
}
variable "retail_shops_pl_eu-west-1" {
  type = list(string)
}
variable "retail_shops_pl_eu-west-2" {
  type = list(string)
}
variable "Cinegy_Air_Version" {
  type = string
}
