terraform {
  cloud {
    organization = "PPBOTT"
    hostname = "app.terraform.io"
    workspaces {
      tags = ["ppb"]
    }
  }

}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
}
module "west1" {
  source = ".//ppb"
  access_key_aws = var.access_key_aws
  secret_key_aws = var.secret_key_aws
  windows_ami_name = var.windows_ami_name
  red5pro_image_name = var.red5pro_image_name_eu-west-1
  red5pro_terraform_image_name = var.red5pro_terraform_image_name_eu-west-1
  red5pro_api_token = var.red5pro_api_token_for_eu-west-1
  mysql_password = var.mysql_password
  retailott_red5pro_pl = var.retailott_red5pro_pl_eu-west-1
  retailott_support_pl = var.retailott_support_pl_eu-west-1
  retail_shops_pl = var.retail_shops_pl_eu-west-1
  Cinegy_Air_Version = var.Cinegy_Air_Version
}
module "west2" {
  source = ".//ppb"
  providers = {
    aws = aws.eu-west-2
  }
  access_key_aws = var.access_key_aws
  secret_key_aws = var.secret_key_aws
  windows_ami_name = var.windows_ami_name
  red5pro_image_name = var.red5pro_image_name_eu-west-2
  red5pro_terraform_image_name = var.red5pro_terraform_image_name_eu-west-2
  red5pro_api_token = var.red5pro_api_token_for_eu-west-2
  mysql_password = var.mysql_password
  retailott_red5pro_pl = var.retailott_red5pro_pl_eu-west-2
  retailott_support_pl = var.retailott_support_pl_eu-west-2
  retail_shops_pl = var.retail_shops_pl_eu-west-2
  Cinegy_Air_Version = var.Cinegy_Air_Version
}
