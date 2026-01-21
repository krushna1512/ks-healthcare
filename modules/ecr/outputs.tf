output "repository_urls" {
  value = { for r in aws_ecr_repository.main : r.name => r.repository_url }
}
