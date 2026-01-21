output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arns" {
  value = {
    frontend  = aws_lb_target_group.frontend.arn
    insurance = aws_lb_target_group.insurance.arn
    patients  = aws_lb_target_group.patients.arn
    pricing   = aws_lb_target_group.pricing.arn
  }
}
