output "vpc_id" {
  value = module.networking.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "postgres_private_ip" {
  value = module.ec2_postgres.postgres_private_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ssm_param_prefix" {
  value = module.ssm.ssm_param_prefix
}

output "ssm_param_name" {
  value = module.ssm.ssm_param_names[0]
}

output "ssm_param_arn" {
  value = module.ssm.ssm_param_arns[0]
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "codepipeline_name" {
  value = module.cicd.codepipeline_name
}

output "ecs_data_bucket_name" {
  value = module.ecs_data_bucket.bucket_name
}