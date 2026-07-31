variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "postgres_ami" {
  description = "AMI ID for PostgreSQL instance (Ubuntu recommended)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for PostgreSQL"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 30
}

variable "ecs_cidr" {
  description = "CIDR range of ECS tasks"
  type        = string
}