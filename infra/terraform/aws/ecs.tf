resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
  tags = { Project = var.project_name }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.project_name}-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = "api",
      image = "${aws_ecr_repository.api.repository_url}:${var.image_tag}",
      essential = true,
      portMappings = [
        { containerPort = var.app_port, hostPort = var.app_port, protocol = "tcp" }
      ],
      environment = [
        { name = "OPENAI_MODEL", value = var.openai_model },
        { name = "OPENAI_EMBEDDING_MODEL", value = var.openai_embedding_model },
        { name = "CHUNK_SIZE", value = "800" },
        { name = "CHUNK_OVERLAP", value = "120" }
      ],
      secrets = [
        # You can add OPENAI_API_KEY as a secret later if desired.
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name,
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = "api"
        }
      },
      healthCheck = {
        command     = ["CMD-SHELL", "python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8011/health').read(); print('ok')""],
        interval    = 30,
        timeout     = 5,
        retries     = 3,
        startPeriod = 30
      }
    }
  ])
}

resource "aws_ecs_service" "api" {
  name            = "${var.project_name}-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [for s in aws_subnet.private : s.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.http]
}
