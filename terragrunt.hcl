remote_state {
  backend = "s3"
  config = {
    bucket         = "nestjs-app-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "${local.environment}"
      Project     = "nestjs-app"
      ManagedBy   = "Terraform"
    }
  }
}
EOF
}

locals {
  environment = basename(get_terragrunt_dir())
  module_dir  = "${get_terragrunt_dir()}/modules"
  region      = "us-east-1"
}

inputs = {
  environment = local.environment
  region      = local.region
}
