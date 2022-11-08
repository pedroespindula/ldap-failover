output "elb_url" {
  value       = aws_lb.this.dns_name
  description = "DNS name for the ELB that was created"
}

output "iam_role_execution" {
  value       = aws_iam_role.execution
  description = "IAM Role that is used for ECS execution"
}

output "iam_role_task" {
  value       = aws_iam_role.task
  description = "IAM Role that is used for ECS tasks"
}
