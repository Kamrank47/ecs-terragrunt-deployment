terraform {
  backend "s3" {}
}

module "networking" {
  source = "./networking"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  app_port             = var.app_port
  admin_cidr_blocks    = var.admin_cidr_blocks
}

module "ecr" {
  source = "./ecr"

  environment = var.environment
}

module "acm" {
  source      = "./acm"
  domain_name = var.acm_domain_name
}

module "alb" {
  source = "./alb"

  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  app_port              = var.app_port
  certificate_arn       = module.acm.certificate_arn
  log_bucket            = var.log_bucket
  api_domain_name       = var.api_domain_name
  enable_https          = var.enable_https
  enable_api_rules      = var.enable_api_rules
}

module "ec2_postgres" {
  source = "./ec2-postgres"

  environment       = var.environment
  postgres_ami      = var.postgres_ami
  instance_type     = var.db_instance_type
  subnet_id         = module.networking.public_subnet_ids[0]
  security_group_id = module.networking.postgres_security_group_id
  key_name          = var.key_name
  volume_size       = var.db_volume_size
  ecs_cidr          = var.public_subnet_cidrs[0]
}

module "ssm" {
  source = "./ssm"

  environment        = var.environment
  backend_env_values = { "1" = "value_for_part_1", "2" = "value_for_part_2", "3" = "value_for_part_3" } # Provide a valid map
}

module "ecs_data_bucket" {
  source = "./s3-data"

  environment = var.environment
}

module "ecs" {
  source = "./ecs"

  environment           = var.environment
  region                = var.region
  ecr_repository_url    = module.ecr.repository_url
  app_port              = var.app_port
  public_subnet_ids     = module.networking.public_subnet_ids
  ecs_security_group_id = module.networking.ecs_security_group_id
  alb_security_group_id = module.networking.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  lb_listener           = var.certificate_arn != "" ? module.alb.https_listener : module.alb.http_listener
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  desired_count         = var.desired_count
  min_count             = var.min_count
  max_count             = var.max_count
  ssm_param_name        = module.ssm.ssm_param_names[0]
  ssm_param_arn         = module.ssm.ssm_param_arns[0]
  s3_bucket_name        = module.ecs_data_bucket.bucket_name
}

module "cicd" {
  source = "./cicd"

  environment             = var.environment
  ecr_repository_url      = module.ecr.repository_url
  ecs_cluster_name        = module.ecs.cluster_id
  ecs_service_name        = module.ecs.service_name
  ecs_service_arn         = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:service/${module.ecs.cluster_id}/${module.ecs.service_name}"
  codestar_connection_arn = var.codestar_connection_arn
  repository_id           = var.repository_id
  branch_name             = var.branch_name
  slack_channel_id        = var.slack_channel_id
  slack_team_id           = var.slack_team_id
}

data "aws_caller_identity" "current" {}