locals {
  common_tags = {
    Project     = "healthcare-app"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
  aws_region  = var.aws_region
}

module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
}

module "alb" {
  source = "../../modules/alb"

  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.security.alb_security_group_id]
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"

  environment = var.environment
}
