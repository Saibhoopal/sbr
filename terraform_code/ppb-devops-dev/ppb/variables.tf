
variable "access_key_aws" {
  type = string
}
variable "secret_key_aws" {
  type = string
}
variable "windows_ami_name" {
  type = string
}
variable "red5pro_image_name" {
  type = string
}
variable "red5pro_terraform_image_name" {
  type = string
}
variable "red5pro_api_token" {
  type = string
}
variable "mysql_password" {
  type = string
}
variable "retailott_red5pro_pl" {
  type = list(string)
}
variable "retailott_support_pl" {
  type = list(string)
}
variable "retail_shops_pl" {
  type = list(string)
}
variable "Cinegy_Air_Version" {
  type = string
}
