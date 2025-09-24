resource "aws_ecs_cluster" "this" {
  name = "${var.org}-${var.env}-gateway"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.org}-${var.env}-gateway"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  enable_execute_command = true

  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "gateway"
    container_port   = var.container_port
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.org}-${var.env}-gateway"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.execute.arn

  cpu    = 1024
  memory = 2048

  container_definitions = jsonencode([
    {
      name      = "gateway"
      image     = "${aws_ecr_repository.this.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = tonumber(var.container_port)
          hostPort      = tonumber(var.container_port)
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      }
      mount_points = [
        {
          sourceVolume  = "efs-volume"
          containerPath = "/data"
          readOnly      = false
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.this.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.this.id
        iam             = "ENABLED"
      }
    }
  }

}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.org}-${var.env}-gateway"
}