output "github_access_key" {
  value       = module.iam-serviceaccount-github.access_key_id
  description = "AWS_ACCESS_KEY to manage AWS resources"
}

output "github_secret_key" {
  value       = module.iam-serviceaccount-github.secret_access_key
  description = "AWS_SECRET_ACCESS_KEY to manage AWS resources"
  sensitive   = true
}
