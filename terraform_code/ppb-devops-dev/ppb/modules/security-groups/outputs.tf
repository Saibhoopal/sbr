
output "bastion-sg" {
  description = "sg for bastion"
  value = aws_security_group.bastion_sg.id
}

output "adclient-sg" {
  description = "sg for ad-client"
  value = aws_security_group.adclient_sg.id
}

output "cinegy-sg" {
  value = aws_security_group.cinegy_sg.id
}

output "internetaccess-sg" {
  value = aws_security_group.internetaccess_sg.id
}

output "sis_config-sg" {
  description = "sg for Sis-Config"
  value = aws_security_group.sis_config_sg.id
}

################ red5pro sg ################

output "red5pro_sm_sg" {
  value = aws_security_group.red5pro_sm_sg.id
}

output "red5pro_node_sg" {
  value = aws_security_group.red5pro_node_sg.id
}

output "red5pro_mysql_sg" {
  value = aws_security_group.red5pro_mysql_sg.id
}

output "red5pro_terraform_sg" {
  value = aws_security_group.red5pro_terraform_sg.id
}

output "retail_shops_sg" {
  value = aws_security_group.retail_shops_sg.id
}

output "retailott_support_sg" {
  value = aws_security_group.retailott_support_sg.id
}
output "monitoring_access_sg" {
  value = aws_security_group.monitoring_access_sg.id
}
