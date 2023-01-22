output "repository_url" {
  value = { for index, resource in module.ecr : resource.repository.name => resource.repository.repository_url }
}
