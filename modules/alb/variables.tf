variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "app_port" {
  description = "Port on which the app runs"
  type        = number
  default     = 3000
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}

variable "log_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
  default     = ""
}

variable "api_domain_name" {
  description = "API domain name for listener rules (e.g., dev-api.example.com)"
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Enable HTTPS listener and rules"
  type        = bool
  default     = false
}

variable "enable_api_rules" {
  description = "Enable API specific routing rules"
  type        = bool
  default     = false
}