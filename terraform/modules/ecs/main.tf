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
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn
  container_definitions = jsonencode([
    {
      "name" : var.name,
      "image" : var.repository_url,
      "memory" : var.memory,
      "cpu" : var.cpu,
      "essential" : true,
      "portMappings" : [for i, port in var.ports : { "containerPort" : port, "hostPort" : port }]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${var.name}-container",
          "awslogs-region" : "us-east-1",
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : "${var.name}"
        }
      }
    },
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

  dynamic "load_balancer" {
    for_each = var.ports
    iterator = port
    content {
      target_group_arn = aws_lb_target_group.this[port.value].arn
      container_name   = var.name
      container_port   = port.value
    }
  }

  desired_count = 1

  tags = merge(var.aws_tags, {
    Name = "${var.name}-service"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.name}-security-group"
  description = "Allow ${join(",", var.ports)} inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
