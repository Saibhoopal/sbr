
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${var.environment}-bastion-sg"
  description = "Security group for bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_network_pl 
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl 
  }

  egress {
    from_port   = 0
    to_port     = 0   
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl 
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 135
    to_port          = 135
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 139
    to_port          = 139
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 1024
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 50
    to_port          = 1023
    protocol         = "tcp"
    cidr_blocks      = var.public_subnet_cidr_range 
  }
  egress {
    from_port = 1024
    to_port   = 65535
    protocol = "tcp"
    cidr_blocks = var.public_subnet_cidr_range 
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 137
    to_port          = 138
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    prefix_list_ids  = var.ppb_network_pl 
  }
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-bastion-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "adclient_sg" {
  name        = "${var.project}-${var.environment}-adclient-sg"
  description = "Security group for adclient"
  vpc_id      = var.vpc_id

  ingress {
    description      = "RDP 3389"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = var.public_subnet_cidr_range
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 135
    to_port          = 135
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 139
    to_port          = 139
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 1024
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 137
    to_port          = 138
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    prefix_list_ids  = var.ppb_network_pl 
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-adclient-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "internetaccess_sg" {
  name        = "${var.project}-${var.environment}-internetaccess-sg"
  description = "Security group for internet access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.ppb_cloudflare_pl
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_internet_access_pl  
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_internet_access_pl 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.ppb_cloudflare_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-internetaccess-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "cinegy_sg" {
  name        = "${var.project}-${var.environment}-cinegy-sg"
  description = "Security group for cinegy engines"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 6000
    to_port          = 6100
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  ingress {
    from_port        = 50000
    to_port          = 55999
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  ingress {
    from_port        = 5437
    to_port          = 5437
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  ingress {
    description      = "RDP 3389"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = var.public_subnet_cidr_range
  }
  ingress {
    description      = "RDP 3389"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_network_pl    
  }
  ingress {
    from_port        = 5521
    to_port          = 5522
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
    description      = "access to cinegy air engine" 
  }
  ingress {
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
    description      = "acccess to cinegy Multiviewer"	
  }

  egress {
    from_port        = 50000
    to_port          = 55999
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 5437
    to_port          = 5437
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 135
    to_port          = 135
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 139
    to_port          = 139
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 1024
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 137
    to_port          = 138
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    prefix_list_ids  = var.ppb_network_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-cinegy-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}

##################### Security Groups for  Red5pro service ##################

###### Security group for Stream Manager (AWS VPC)
resource "aws_security_group" "red5pro_sm_sg" {
  name        = "${var.project}-${var.environment}-red5pro-sm-sg"
  description = "Allow inbound traffic for Stream Manager"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.vpc_cidr_range
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.ppb_cloudflare_pl
  }

  egress {
    from_port = 50
    to_port   = 1024
    protocol  = "tcp"
    description = "allows send logs to cw & SSM access" 
    cidr_blocks = var.shared_account_cidr_range
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.vpc_cidr_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.ppb_cloudflare_pl
  }
  egress {
    from_port   = 368
    to_port     = 368
    protocol    = "tcp"
    description = "LDAP access"
    prefix_list_ids  = var.ppb_network_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-red5pro-sm-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Security group for autoscaling nodes (AWS VPC)
resource "aws_security_group" "red5pro_node_sg" {
  name        = "${var.project}-${var.environment}-red5pro-node-sg"
  description = "Allow inbound traffic for Stream Manager Nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = var.vpc_cidr_range
  }

  egress {
    from_port = 50
    to_port   = 1024
    protocol  = "tcp"
    description = "allows send logs to cw & SSM access"
    cidr_blocks = var.shared_account_cidr_range
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    prefix_list_ids  = var.ppb_internet_access_pl
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    prefix_list_ids  = var.ppb_internet_access_pl
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = var.vpc_cidr_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.ppb_cloudflare_pl
  }
  egress {
    from_port   = 368
    to_port     = 368
    protocol    = "tcp"
    description = "LDAP access"
    prefix_list_ids  = var.ppb_network_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-red5pro-node-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}
######################################################################################
# Security group for MySQL DataBase (AWS VPC)
resource "aws_security_group" "red5pro_mysql_sg" {
  name        = "${var.project}-${var.environment}-red5pro-mysql-sg"
  description = "Allow inbound traffic for Stream Manager MySQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_range
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_cidr_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-red5pro-mysql-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}

# Security group for Terraform service (AWS VPC)
resource "aws_security_group" "red5pro_terraform_sg" {
  name        = "${var.project}-${var.environment}-red5pro-terraform-sg"
  description = "Allow inbound traffic for Terraform-service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids  = var.ppb_network_pl 
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = 8083 
    to_port     = 8083  
    protocol    = "tcp"
    prefix_list_ids  = var.retailott_red5pro_pl
  }
  ingress {
    from_port = 8083
    to_port   = 8083
    protocol  = "tcp"
    cidr_blocks = var.vpc_cidr_range
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.vpc_cidr_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl
  }

  egress {
    from_port = 50
    to_port   = 1024
    protocol  = "tcp"
    description = "allows send logs to cw SSM access"
    cidr_blocks = var.shared_account_cidr_range
  }
  egress {
    from_port   = 368
    to_port     = 368
    protocol    = "tcp"
    description = "LDAP access"
    prefix_list_ids  = var.ppb_network_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-red5pro-terraform-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

##### Security group for Retailott support team
resource "aws_security_group" "retailott_support_sg" {
  name        = "${var.project}-${var.environment}-retailott-support-sg"
  description = "Security group for retail support teasm to access red5pro service and streams"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5080
    to_port   = 5080
    protocol  = "tcp"
    description = "allow support team to access the red5pro service"
    prefix_list_ids  = var.retailott_support_pl
  }
  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "udp"
    description = "allow support team to access the streams"
    prefix_list_ids  = var.retailott_support_pl
  }

  egress {
    from_port = 1024
    to_port   = 65535
    protocol  = "udp"
    description = "allow support team to access the streams"
    prefix_list_ids  = var.retailott_support_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-retailott-support-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

##### Security group for Retail Shops 
resource "aws_security_group" "retail_shops_sg" {
  name        = "${var.project}-${var.environment}-retail-shops-sg"
  description = "Security group for retail shops to access red5pro service and streams"
  vpc_id      = var.vpc_id

  egress {
    from_port = 1024
    to_port   = 65535
    protocol  = "udp"
    description = "allow shops to access the streams"
    prefix_list_ids  = var.retail_shops_pl
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-retail-shops-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

##### Security group for Monitoring Access
resource "aws_security_group" "monitoring_access_sg" {
  name        = "${var.project}-${var.environment}-monitoring-access-sg"
  description = "Monitoring Access"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5521
    to_port   = 5522
    protocol  = "tcp"
    description = "monitoring-access to cinegy air engines"
    cidr_blocks = var.monitoring_subnet_range
  }
  ingress {
    from_port = 8090
    to_port   = 8090
    protocol  = "tcp"
    description = "monitoring-access to cinegy multiviewer"
    cidr_blocks = var.monitoring_subnet_range
  }
  ingress {
    from_port = 5080
    to_port   = 5080
    protocol  = "tcp"
    description = "monitoring-access to red5pro service"
    cidr_blocks = var.monitoring_subnet_range
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    description = "allow support team to access the streams"
    cidr_blocks = var.monitoring_subnet_range
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-monitoring-access-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

########### SIS_Confog's SG to be confirmed. Cuurently duplicating Bastion's SG ################

resource "aws_security_group" "sis_config_sg" {
  name        = "${var.project}-${var.environment}-sis_config-sg"
  description = "Security group for sis_config"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_network_pl 
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    prefix_list_ids  = var.ppb_network_pl
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl 
  }

  egress {
    from_port   = 0
    to_port     = 0   
    protocol    = "-1"
    prefix_list_ids  = var.retailott_red5pro_pl 
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 135
    to_port          = 135
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 139
    to_port          = 139
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 1024
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 50
    to_port          = 1023
    protocol         = "tcp"
    cidr_blocks      = var.public_subnet_cidr_range 
  }
  egress {
    from_port = 1024
    to_port   = 65535
    protocol = "tcp"
    cidr_blocks = var.public_subnet_cidr_range 
  }
  egress {
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 88
    to_port          = 88
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 137
    to_port          = 138
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 389
    to_port          = 389
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 123
    to_port          = 123
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 445
    to_port          = 445
    protocol         = "udp"
    cidr_blocks      = var.vpc_cidr_range
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    prefix_list_ids  = var.ppb_network_pl 
  }
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-sis_config-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

}
