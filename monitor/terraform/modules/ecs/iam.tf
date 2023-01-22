resource "aws_iam_role" "execution" {
  name               = "${var.name}-execution-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.aws_tags, {
    Name = "${var.name}-execution-iam-role"
  })
}

resource "aws_iam_role" "task" {
  name               = "${var.name}-task-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.aws_tags, {
    Name = "${var.name}-task-iam-role"
  })
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

