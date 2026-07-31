resource "aws_ssm_parameter" "backend_env" {
  for_each = toset(["1", "2", "3"])

  name        = "/${var.environment}/be/${each.value}/env"
  description = "Backend environment variables for NestJS app (part ${each.value})"
  type        = "SecureString"
  value       = var.backend_env_values[each.value]

  lifecycle {
    ignore_changes = [
      value, # Ignore changes to the value so you can update it manually
    ]
  }
}