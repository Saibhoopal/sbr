
variable "aws_role_name" {
  type = string
  default = "CLIENT_IAM_ROLE_NAME" #iceway-ec2-insance-role
}

variable "aws_git_secret_name" {
  type= string
  default = "github-ssh-key"
}
