resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  tags = merge(var.aws_tags, {
    Name = "${var.name}-cluster"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = aws_iam_role.this.arn
  container_definitions = jsonencode([
    {
      "name" : var.name,
      "image" : aws_ecr_repository.this.repository_url,
      "memory" : var.memory,
      "cpu" : var.cpu,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : var.port,
          "hostPort" : var.port
        }
      ]
    }
  ])

  tags = merge(var.aws_tags, {
    Name = "${var.name}-task-definition"
  })
}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.this.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.name
    container_port   = var.port
  }

  desired_count = 1

  tags = merge(var.aws_tags, {
    Name = "${var.name}-service"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.name}-security-group"
  description = "Allow ${var.port} inbound traffic"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.aws_tags, {
    Name = "${var.name}-security-group"
  })
}
