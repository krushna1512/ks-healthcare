output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "alb_target_group_arns" {
  value = module.alb.target_group_arns
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_task_execution_role_arn" {
  value = module.security.ecs_task_execution_role_arn
}

output "ecs_task_role_arn" {
  value = module.security.ecs_task_role_arn
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ecs_tasks_security_group_id" {
  value = module.security.ecs_tasks_security_group_id
}
