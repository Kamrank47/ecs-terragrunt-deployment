variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "app_port" {
  description = "Port on which the app runs"
  type        = number
  default     = 3000
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "lb_listener" {
  description = "Load balancer listener"
  type        = any
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired count of tasks"
  type        = number
  default     = 2
}

variable "min_count" {
  description = "Minimum count of tasks"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum count of tasks"
  type        = number
  default     = 5
}

variable "ssm_param_name" {
  description = "SSM parameter name for backend env"
  type        = string
}

variable "ssm_param_arn" {
  description = "SSM parameter ARN"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for ECS data"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}