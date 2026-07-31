include {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  environment = "dev"
}

terraform {
  source = "../../modules"
}

inputs = {
  environment = local.environment
  region      = "us-east-1"
  
  # Networking
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  admin_cidr_blocks    = ["10.0.0.0/16"]  # Should be replaced with actual admin IP range
  
  # ALB Configuration
  enable_https      = true
  enable_api_rules  = true
  api_domain_name   = "dev-api.example.com"
  acm_domain_name   = "*.example.com"
  
  # EC2 PostgreSQL
  postgres_ami         = "ami-084568db4383264d4"  # Ubuntu AMI
  db_instance_type     = "t3.micro"
  key_name             = "dev-key"  # SSH key for accessing the EC2 instance
  db_volume_size       = 20
  #db_name              = "dev_nestjs-app_be_db"
  #db_username          = "devs_nestjs-app_be_user"
  # db_password will be set manually in the SSM Parameter Store
  
  # ECS
  task_cpu             = 512
  task_memory          = 1024
  desired_count        = 1
  min_count            = 1
  max_count            = 2
  
  # CI/CD
  codestar_connection_arn = "arn:aws:codeconnections:us-east-1:123456789012:connection/abcdef12-3456-7890-abcd-ef1234567890"
  repository_id           = "your-organization/nestjs-app"
  branch_name             = "develop"

  # Domain Names
  api_domain_name  = "dev-api.example.com"
  acm_domain_name  = "*.example.com"

  backend_env_values = {
    "1" = "value_for_part_1"
    "2" = "value_for_part_2"
    "3" = "value_for_part_3"
  }

  slack_team_id        = "T00000000"
  slack_channel_id     = "C00000000"
}
