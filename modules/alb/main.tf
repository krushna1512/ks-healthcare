resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "${var.environment}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "insurance" {
  name        = "${var.environment}-insurance-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/insurance"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "patients" {
  name        = "${var.environment}-patients-tg"
  port        = 3002
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/patients"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "pricing" {
  name        = "${var.environment}-pricing-tg"
  port        = 3003
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/pricing"
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener_rule" "insurance" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.insurance.arn
  }

  condition {
    path_pattern {
      values = ["/insurance*"]
    }
  }
}

resource "aws_lb_listener_rule" "patients" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patients.arn
  }

  condition {
    path_pattern {
      values = ["/patients*"]
    }
  }
}

resource "aws_lb_listener_rule" "pricing" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pricing.arn
  }

  condition {
    path_pattern {
      values = ["/pricing*"]
    }
  }
}
