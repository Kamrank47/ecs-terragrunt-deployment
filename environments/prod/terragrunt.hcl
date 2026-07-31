include {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  environment = "prod"
}

terraform {
  source = "../../modules"
}

inputs = {
  environment = local.environment
  region      = "us-east-1"
  
  # Networking
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  admin_cidr_blocks    = ["10.1.0.0/16"]  # Should be replaced with actual admin IP range
  
  # EC2 PostgreSQL
  postgres_ami         = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  db_instance_type     = "t3.large"
  key_name             = "prod-key"  # SSH key for accessing the EC2 instance
  db_volume_size       = 100
  db_name              = "nestjs_prod"
  db_username          = "nestjs_user"
  # db_password will be set manually in the SSM Parameter Store
  
  # ECS
  task_cpu             = 1024
  task_memory          = 2048
  desired_count        = 3
  min_count            = 2
  max_count            = 10
  
  # ALB
  certificate_arn      = "arn:aws:acm:us-east-1:123456789012:certificate/abcdef12-3456-7890-abcd-ef1234567890"
  log_bucket           = "nestjs-app-alb-logs"
  api_domain_name      = "api.example.com"
  acm_domain_name      = "*.example.com"
  enable_https         = true
  enable_api_rules     = true
  
  # CI/CD
  codestar_connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/abcdef12-3456-7890-abcd-ef1234567890"
  repository_id           = "your-organization/nestjs-app"
  branch_name             = "main"

  backend_env_values = {
    "1" = "value_for_part_1"
    "2" = "value_for_part_2"
    "3" = "value_for_part_3"
  }

  slack_team_id        = "T00000000"
  slack_channel_id     = "C00000000"
}
