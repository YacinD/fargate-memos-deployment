data "aws_ecr_repository" "this" {
  name = var.repository_name
}

locals {
  repository_url  = data.aws_ecr_repository.this.repository_url
  repository_arn  = data.aws_ecr_repository.this.arn
  repository_name = data.aws_ecr_repository.this.name
}