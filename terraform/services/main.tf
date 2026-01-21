data "aws_vpc" "main" {
  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
}

data "aws_security_group" "ecs_tasks" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-ecs-tasks-sg"]
  }
  vpc_id = data.aws_vpc.main.id
}

data "aws_ecs_cluster" "main" {
  cluster_name = "${var.environment}-cluster"
}

data "aws_iam_role" "execution_role" {
  name = "${var.environment}-ecs-task-execution-role"
}

data "aws_lb_target_group" "frontend" {
  name = "${var.environment}-frontend-tg"
}
data "aws_lb_target_group" "insurance" {
  name = "${var.environment}-insurance-tg"
}
data "aws_lb_target_group" "patients" {
  name = "${var.environment}-patients-tg"
}
data "aws_lb_target_group" "pricing" {
  name = "${var.environment}-pricing-tg"
}

data "aws_ecr_repository" "frontend" {
  name = "healthcare-frontend"
}
data "aws_ecr_repository" "insurance" {
  name = "healthcare-insurance"
}
data "aws_ecr_repository" "patients" {
  name = "healthcare-patients"
}
data "aws_ecr_repository" "pricing" {
  name = "healthcare-pricing"
}


resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.environment}-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${data.aws_ecr_repository.frontend.repository_url}:${var.image_tags["frontend"]}"
      essential = true
      portMappings = [{ containerPort = 80 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/frontend"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name            = "${var.environment}-frontend"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  force_new_deployment = true

  lifecycle {
    ignore_changes = [desired_count] 
  }
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "insurance" {
  family                   = "${var.environment}-insurance"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "insurance"
      image     = "${data.aws_ecr_repository.insurance.repository_url}:${var.image_tags["insurance"]}"
      essential = true
      portMappings = [{ containerPort = 3001 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/insurance"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "insurance" {
  name            = "${var.environment}-insurance"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.insurance.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  force_new_deployment = true

  lifecycle {
    ignore_changes = [desired_count] 
  }

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.insurance.arn
    container_name   = "insurance"
    container_port   = 3001
  }
}

resource "aws_ecs_task_definition" "patients" {
  family                   = "${var.environment}-patients"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "patients"
      image     = "${data.aws_ecr_repository.patients.repository_url}:${var.image_tags["patients"]}"
      essential = true
      portMappings = [{ containerPort = 3002 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/patients"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "patients" {
  name            = "${var.environment}-patients"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.patients.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  force_new_deployment = true

  lifecycle {
    ignore_changes = [desired_count] 
  }

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.patients.arn
    container_name   = "patients"
    container_port   = 3002
  }
}


resource "aws_ecs_task_definition" "pricing" {
  family                   = "${var.environment}-pricing"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "pricing"
      image     = "${data.aws_ecr_repository.pricing.repository_url}:${var.image_tags["pricing"]}"
      essential = true
      portMappings = [{ containerPort = 3003 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.environment}/pricing"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "pricing" {
  name            = "${var.environment}-pricing"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.pricing.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [data.aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.pricing.arn
    container_name   = "pricing"
    container_port   = 3003
  }
}
