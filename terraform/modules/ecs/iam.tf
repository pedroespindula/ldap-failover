resource "aws_iam_role" "this" {
  name               = "${var.name}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.aws_tags, {
    Name = "${var.name}-iam-role"
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
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

