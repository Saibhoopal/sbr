
data "aws_iam_policy_document" "default_ec2_policy" {
  statement {
    actions = [
      "ssm:*",
      "ec2:*",
      "secretsmanager:*",
      "mediaconnect:*",
      "s3:*",
      "mediaconnect:UpdateFlowOutput",
      "mediaconnect:UpdateFlow",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "route53:ListHostedZonesByName",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZones",
      "route53:ChangeResourceRecordSets",
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "kms:DescribeKey",
      "kms:ListAliases",
      "kms:ListKeys",
      "tag:GetResources",
      "ds:CreateComputer",
      "ds:DescribeDirectories",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "s3:GetBucketLocation",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
      "s3:GetObject",      
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "dynamodb:DeleteItem",
      "ecs:UpdateContainerInstancesState",
      "ecs:RegisterContainerInstance",
      "ecs:Submit*",
      "ecs:Poll",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "ecs:DeregisterContainerInstance",
      "ecr:BatchCheckLayerAvailability",
      "ecs:DiscoverPollEndpoint",
      "dynamodb:PutItem",
      "ecs:CreateCluster",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecs:StartTelemetrySession",
      "ecr:BatchGetImage",
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "cloudwatch:*",
      "sts:*",
      "sts:DecodeAuthorizationMessage",
      "sts:GetCallerIdentity",
      "ec2:ModifyInstanceAttribute",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AssociateAddress",
      "autoscaling:PutLifecycleHook"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role" "iam_role_default_ec2_instance" {
  name = "3ptyrell_${var.project}-${var.environment}-ec2-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": "VisualEditor0"
        }
    ]
}
EOF
  tags = merge(var.common_tags, {
    Name = "3ptyrell_${var.project}-${var.environment}-ec2-instance-role"
  })
}

resource "aws_iam_role_policy" "default_policy_for_ec2_instance" {
  name = "${var.project}-${var.environment}-ec2-instance-policy"
  role = aws_iam_role.iam_role_default_ec2_instance.id
  policy = data.aws_iam_policy_document.default_ec2_policy.json
}

resource "aws_iam_instance_profile" "instance_profile_default_ec2_instance" {
  name = "3ptyrell_${var.project}-${var.environment}-ec2-instance-profile"
  role = aws_iam_role.iam_role_default_ec2_instance.name
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-ec2-instance-profile"
  })
}
