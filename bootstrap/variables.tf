variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "state_bucket_name" {
  type    = string
  default = "ecsv1-terraform-state"
}

variable "ecr_repository_name" {
  type    = string
  default = "ecs-memos"
}

variable "github_repo" {
  type    = string
  default = "YacinD/fargate-memos-deployment"
}