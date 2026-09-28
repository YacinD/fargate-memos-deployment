variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "memos"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "domain_name" {
  type    = string
  default = "ecsv1.online"
}

variable "state_bucket_name" {
  type    = string
  default = "ecsv1-terraform-state"
}
