variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "backend_env_values" {
  description = "Map of backend environment variables (split into parts)"
  type        = map(string)
  default     = {}
}