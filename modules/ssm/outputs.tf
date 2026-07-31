output "ssm_param_prefix" {
  value = "/${var.environment}/nestjs-app"
}

output "ssm_param_names" {
  value = [for param in aws_ssm_parameter.backend_env : param.name]
}

output "ssm_param_arns" {
  value = [for param in aws_ssm_parameter.backend_env : param.arn]
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}