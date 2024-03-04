data "aws_ami" "windows_ami" {
  filter {
    name   = "name"
    values = [var.windows_ami_name]
  }
}

resource "aws_launch_template" "cinegy_air_lt" {
  name     = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-lt"
  image_id        = data.aws_ami.windows_ami.id #var.windows_ami 
  key_name        = var.key_name      
  instance_type   = var.cinegy_air_instance_type
  vpc_security_group_ids = var.cinegy_sg_ids
  iam_instance_profile {
    name = var.instance_profile
  }
  lifecycle {
    create_before_destroy = true
  }
  ebs_optimized = true
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 100
    }
  }

  user_data = base64encode(
  <<EOF
  <powershell>
  #Requires -RunAsAdministrator
  New-Item -ItemType Directory -Force -Path C:\UserData
  $env_name = "${var.env_name}"
  $licenseaddress = "${var.cinegy_license_address}"
  $domainsecretname = "${var.domain_secret_name}"
  $domainadminuser="${var.domain_admin_user}"
  $ADdomain = "${var.ADdomain}"
  $ADOU  = "${var.ADOU}"
  $R53Domain = "${var.R53Domain}"
  $Recordsetsubdomainprefix = "${var.air_Recordset_subdomain_prefix}"
  $bucket = "${var.bucket_name}" 
  $Cinegy_AEMain_Config_0_S3path = "${var.Cinegy_AEMain_Config_0_S3path}"
  $Cinegy_AEMain_Config_1_S3path = "${var.Cinegy_AEMain_Config_1_S3path}"
  $Cinegy_AEBackup_Config_0_S3path = "${var.Cinegy_AEBackup_Config_0_S3path}"
  $Cinegy_AEBackup_Config_1_S3path = "${var.Cinegy_AEBackup_Config_1_S3path}"
  $Cinegy_AudioMatrix_Config_S3path = "${var.Cinegy_AudioMatrix_Config_S3path}"
  $AirengineName = "${var.AirengineName}"
  $Cinegy_Air_Version = "${var.Cinegy_Air_Version}"
  $files = Get-S3Object -BucketName $bucket -Key air-userdata.ps1
  foreach($file in $files) {
    Copy-S3Object -SourceBucket $bucket -SourceKey $($file.Key) -LocalFolder 'C:\UserData'
  }
  C:\UserData\air-userdata.ps1
  </powershell>
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-${var.environment}-${var.service}-${var.cinegy_ae_name}"
    })

  }
}

resource "aws_autoscaling_group" "cinegy_air_asg" {
  name                 = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-asg"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete = true

  launch_template {
    id      = aws_launch_template.cinegy_air_lt.id
    version = aws_launch_template.cinegy_air_lt.latest_version
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
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  vpc_zone_identifier  = var.cinegy_private_subnet_ids
  lifecycle {
    ignore_changes = []
  }
}

resource "aws_autoscaling_policy" "cinegy_air_scale_down" {
  name                   = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-asg-scale-down"
  autoscaling_group_name = "${aws_autoscaling_group.cinegy_air_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120

}

resource "aws_cloudwatch_metric_alarm" "cinegy_air_scale_down" {
  alarm_description   = "Monitors CPU utilization for cinegy air ASG"
  alarm_actions       = ["${aws_autoscaling_policy.cinegy_air_scale_down.arn}"]
  alarm_name          = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-asg-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.cinegy_air_asg.name}"
  }
  tags = merge(var.common_tags,{
      Name = "${var.project}-${var.environment}-${var.service}-${var.cinegy_ae_name}-asg-scale-down"
  })
}

resource "aws_autoscaling_policy" "cinegy_air_scale_up" {
  name                   = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-asg-scale-up"
  autoscaling_group_name = "${aws_autoscaling_group.cinegy_air_asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "cinegy_air_scale_up" {
  alarm_description   = "Monitors CPU utilization for cinegy air ASG"
  alarm_actions       = ["${aws_autoscaling_policy.cinegy_air_scale_up.arn}"]
  alarm_name          = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-asg-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "95"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.cinegy_air_asg.name}"
  }
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-${var.cinegy_ae_name}-scale-up"
  })
}

resource "aws_autoscaling_notification" "cinegy_air_notification" {
  group_names = [
    aws_autoscaling_group.cinegy_air_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.cinegy_air.arn
}

resource "aws_sns_topic" "cinegy_air" {
  name = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-failure"
  display_name = "${var.project}-${var.env_name}-${var.service}-${var.cinegy_ae_name}-failure"

  # arn is an exported attribute
}
resource "aws_sns_topic_subscription" "cinegy_air_topic" {
  topic_arn = aws_sns_topic.cinegy_air.arn
  protocol  = "email"
  endpoint  = "samuel.okuneye@tyrellcct.com"
}
