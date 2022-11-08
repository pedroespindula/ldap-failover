resource "aws_iam_policy" "allow-log-creation" {
  name        = "allow-log-creation"
  path        = "/"
  description = "Allow log creation on CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:*:*:*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-role-allow-lsd-ldap-backup-bucket-access" {
  role       = module.ecs.iam_role_task.name
  policy_arn = data.terraform_remote_state.backup-bucket.outputs.policy_arn
}

resource "aws_iam_role_policy_attachment" "ecs-role-allow-logs" {
  role       = module.ecs.iam_role_execution.name
  policy_arn = aws_iam_policy.allow-log-creation.arn
}
