output "access_key_id" {
  value       = aws_iam_access_key.this.id
  description = "AWS_ACCESS_KEY to manage AWS resources"
}

output "secret_access_key" {
  value       = aws_iam_access_key.this.secret
  description = "AWS_SECRET_ACCESS_KEY to manage AWS resources"
  sensitive   = true
}
