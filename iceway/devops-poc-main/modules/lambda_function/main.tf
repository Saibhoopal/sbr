data "archive_file" "code" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/code.zip"
}

resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = "${sha256(file("${path.module}/requirements.txt"))}"
  }

  provisioner "local-exec" {
    command = "python3 -m pip install -r ${path.module}/requirements.txt -t ${path.module}/layer"
  }
}

data "aws_iam_role" "existing_instance_role" {
  name = var.aws_role_name
}

resource "aws_lambda_function" "lambda"{
  filename      = data.archive_file.code.output_path
  function_name = "iceway-app-configure-and-restart-lambda"
  role          = data.aws_iam_role.existing_instance_role.arn
  handler       = "code.main"
  runtime = "python3.10"
  source_code_hash = data.archive_file.code.output_base64sha256
  timeout = 600
  layers = [
    "arn:aws:lambda:us-east-1:553035198032:layer:git:14"
  ]
  environment {
    variables = {
      REGION = var.aws_region
      AWS_GIT_SECRET_NAME = var.aws_git_secret_name 
    }
  }
}
