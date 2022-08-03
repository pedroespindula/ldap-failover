output "backup_policy_arn" {
  value       = aws_iam_policy.allow-lsd-ldap-backup-bucket-access.arn
  description = "ARN of the bucket backup access policy"
}

output "read_policy_arn" {
  value       = aws_iam_policy.allow-lsd-ldap-read-bucket-access.arn
  description = "ARN of the bucket read access policy"
}

output "serviceaccount" {
  value     = module.serviceaccount
  sensitive = true
}
