output "policy_arn" {
  value       = aws_iam_policy.allow-lsd-ldap-backup-bucket-access.arn
  description = "ARN of the bucket access policy"
}
