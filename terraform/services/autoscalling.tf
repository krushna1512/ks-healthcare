resource "aws_appautoscaling_target" "frontend" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${data.aws_ecs_cluster.main.cluster_name}/${aws_ecs_service.frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "frontend_cpu" {
  name               = "frontend-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_target" "insurance" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${data.aws_ecs_cluster.main.cluster_name}/${aws_ecs_service.insurance.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "insurance_cpu" {
  name               = "insurance-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.insurance.resource_id
  scalable_dimension = aws_appautoscaling_target.insurance.scalable_dimension
  service_namespace  = aws_appautoscaling_target.insurance.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}


resource "aws_appautoscaling_target" "patients" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${data.aws_ecs_cluster.main.cluster_name}/${aws_ecs_service.patients.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "patients_cpu" {
  name               = "patients-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.patients.resource_id
  scalable_dimension = aws_appautoscaling_target.patients.scalable_dimension
  service_namespace  = aws_appautoscaling_target.patients.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_target" "pricing" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${data.aws_ecs_cluster.main.cluster_name}/${aws_ecs_service.pricing.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "pricing_cpu" {
  name               = "pricing-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.pricing.resource_id
  scalable_dimension = aws_appautoscaling_target.pricing.scalable_dimension
  service_namespace  = aws_appautoscaling_target.pricing.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
