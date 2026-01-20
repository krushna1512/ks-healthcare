output "cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}

output "cluster_id" {
  value = aws_ecs_cluster.app_cluster.id
}
