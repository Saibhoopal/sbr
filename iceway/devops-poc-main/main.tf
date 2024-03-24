
module "lambda_function" {
  source = ".//modules/lambda_function"
  aws_region = data.aws_region.current.name
  aws_role_name = var.aws_role_name
  aws_git_secret_name = var.aws_git_secret_name
}

module "step_function" {
  source = ".//modules/step_function"
  aws_role_name = var.aws_role_name
  lambda_function_arn = module.lambda_function.lambda_function_arn

}

data "aws_region" "current" {}
