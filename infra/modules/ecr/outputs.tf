output "repository_url" {
  value = data.aws_ecr_repository.this.repository_url
}

output "repository_name" {
  value = data.aws_ecr_repository.this.name
}

output "repository_arn" {
  value = data.aws_ecr_repository.this.arn
}