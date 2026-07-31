variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "app_port" {
  description = "Port on which the app runs"
  type        = number
  default     = 3000
}

# Networking
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks for admin access"
  type        = list(string)
}

# EC2 PostgreSQL
variable "postgres_ami" {
  description = "AMI ID for PostgreSQL instance"
  type        = string
}

variable "db_instance_type" {
  description = "EC2 instance type for PostgreSQL"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "db_volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
}

# ECS
variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
}

variable "task_memory" {
  description = "Memory for the task in MiB"
  type        = number
}

variable "desired_count" {
  description = "Desired count of tasks"
  type        = number
}

variable "min_count" {
  description = "Minimum count of tasks"
  type        = number
}

variable "max_count" {
  description = "Maximum count of tasks"
  type        = number
}

# ALB
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
  description = "API domain name for ALB listener rules (e.g., dev-api.example.com)"
  type        = string
  default     = ""
}

variable "acm_domain_name" {
  description = "Domain name for ACM certificate (e.g., *.example.com)"
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

# CI/CD
variable "codestar_connection_arn" {
  description = "CodeStar connection ARN"
  type        = string
}

variable "repository_id" {
  description = "Repository ID (e.g., owner/repo)"
  type        = string
}

variable "branch_name" {
  description = "Branch name"
  type        = string
}

# AWS Chatbot
variable "slack_team_id" {
  description = "Slack team ID for AWS Chatbot"
  type        = string
  default     = ""
}

variable "slack_channel_id" {
  description = "Slack channel ID for AWS Chatbot"
  type        = string
  default     = ""
}