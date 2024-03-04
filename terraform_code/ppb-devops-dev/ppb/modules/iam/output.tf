
output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile_default_ec2_instance.name
}

output "ec2_instance_role_name" {
  value = aws_iam_role.iam_role_default_ec2_instance.name
}
