
resource "aws_directory_service_directory" "ad" {
  name     = var.domain_name
  password = var.domain_admin_password
  edition  = var.directory_edition
  type     = var.directory_type
  count    = var.enable_ad ? 1 : 0
  vpc_settings {
    vpc_id = var.vpc_id
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name      = "ppb-ott-${var.env_name}-ad"
    Terraform = true
  }
}
