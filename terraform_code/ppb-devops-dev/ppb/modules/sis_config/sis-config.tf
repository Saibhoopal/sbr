
resource "aws_launch_template" "sis_config_lt" {
  name     = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-lt"
  image_id        = var.sis_config_ami
  key_name        = var.key_name
  instance_type   = var.sis_config_instance_type
  vpc_security_group_ids = var.sis_config_sg_ids
  iam_instance_profile {
    name = var.instance_profile
  }
  lifecycle {
    create_before_destroy = true
  }
  ebs_optimized = false

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 60
    }
  }

  user_data = base64encode(
  <<EOF
  <powershell>
  #Requires -RunAsAdministrator
  Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -UseBasicParsing
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet
  $ADdomain="${var.ADdomain}"
  $ADOU="${var.ADOU}"
  $domainadminuser="${var.domain_admin_user}"
  $domainuser1=Get-SECSecretValue -SecretId $domainadminuser -Select SecretString
  $domainuser2=$domainuser1.split(":")
  $domainuser3=$domainuser2[1].trim('}')
  $AdminUser=$domainuser3.trim('"')
  $domainsecretname="${var.domain_secret_name}"
  $password1=Get-SECSecretValue -SecretId $domainsecretname -Select SecretString
  $splitsecret=$password1.split(":")
  $password2=$splitsecret[1].trim('}')
  $password3=$password2.trim('"')
  $password=ConvertTo-SecureString -String $password3 -AsPlainText -Force
  $credential=New-Object System.Management.Automation.PSCredential($AdminUser,$password)
  write-host("Domain Joined")
  Add-Computer -DomainName $ADdomain -OUPath $ADOU -Credential $credential -Restart -Force
  </powershell>
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-${var.environment}-${var.service}-${var.sis_config_name}"
    })
  }
}

resource "aws_autoscaling_group" "sis_config_asg" {
  name                 = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-asg"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete = true

  launch_template {
    id      = aws_launch_template.sis_config_lt.id
    version = aws_launch_template.sis_config_lt.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  vpc_zone_identifier  = var.sis_config_subnet_ids
  lifecycle {
    ignore_changes = []
  }

   tag {
    key = "Platform:Environment"
    value = var.environment
    propagate_at_launch = true
  }
  tag {  
    key = "Platform:BusinessVertical" 
    value = "Retail"
    propagate_at_launch = true
  }
  tag {  
    key = "Platform:TLA"
    value = "OTT"
    propagate_at_launch = true
  }
  tag {  
    key = "Platform:CostCode" 
    value = "61997"
    propagate_at_launch = true
  }
  tag {  
    key = "aws-inspector" 
    value = "bypass"
    propagate_at_launch = true
  }
  tag {
    key="service"
    value=var.service
    propagate_at_launch=true
  }
  tag {
    key="monitoring"
    value= "true"
    propagate_at_launch=true
  }

}

resource "aws_autoscaling_policy" "sis_config_scale_down" {
  name                   = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-asg-scale-down"
  autoscaling_group_name = "${aws_autoscaling_group.sis_config_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120

}

resource "aws_cloudwatch_metric_alarm" "sis_config_scale_down" {
  alarm_description   = "Monitors CPU utilization for SIS Config ASG"
  alarm_actions       = ["${aws_autoscaling_policy.sis_config_scale_down.arn}"]
  alarm_name          = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-asg-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.sis_config_asg.name}"
  }
  tags = merge(var.common_tags,{
      Name = "${var.project}-${var.environment}-${var.service}-${var.sis_config_name}-asg-scale-down"
  })
}

resource "aws_autoscaling_policy" "sis_config_scale_up" {
  name                   = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-asg-scale-up"
  autoscaling_group_name = "${aws_autoscaling_group.sis_config_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "sis_config_scale_up" {
  alarm_description   = "Monitors CPU utilization for SIS Config ASG"
  alarm_actions       = ["${aws_autoscaling_policy.sis_config_scale_up.arn}"]
  alarm_name          = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-asg-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "95"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.sis_config_asg.name}"
  }
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-${var.sis_config_name}-scale-up"
  })
}

resource "aws_autoscaling_notification" "sis_config_notification" {
  group_names = [
    aws_autoscaling_group.sis_config_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.sis_config.arn
}

resource "aws_sns_topic" "sis_config" {
  name = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-failure"
  display_name = "${var.project}-${var.env_name}-${var.service}-${var.sis_config_name}-failure"

}
resource "aws_sns_topic_subscription" "sis_config_topic" {
  topic_arn = aws_sns_topic.sis_config.arn
  protocol  = "email"
  endpoint  = "samuel.okuneye@tyrellcct.com"
}
