# resource "aws_scheduler_schedule" "this" {
#   name = "${local.context[terraform.workspace].name}-schedule"

#   flexible_time_window {
#     mode = "OFF"
#   }

#   schedule_expression = "rate(5 minutes)"

#   target {
#     arn      = aws_lambda_function.this.arn
#     role_arn = aws_iam_role.this.arn
#   }
# }

resource "aws_lambda_function" "this" {
  function_name = local.context[terraform.workspace].name
  role          = aws_iam_role.this.arn
  package_type  = "Image"

  image_uri = "${data.terraform_remote_state.repository.outputs.repository_url}:latest"

  memory_size = 1024
  timeout     = 600

  ephemeral_storage {
    size = 1024
  }

  environment {
    variables = {
      "LDAP_HOST" : "0.tcp.sa.ngrok.io",
      "LDAP_PORT" : "17752"
      "LDAP_QUERY" : "ou=users,dc=lsd,dc=ufcg,dc=edu,dc=br"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.this,
  ]
  # lifecycle {
  #   ignore_changes = [
  #     environment
  #   ]
  # }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.context[terraform.workspace].name}"
  retention_in_days = 7
}

