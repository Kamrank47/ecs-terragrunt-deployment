variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "ecs_service_arn" {
  description = "ECS service ARN"
  type        = string
}

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
  default     = "main"
}

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

data "aws_caller_identity" "current" {}