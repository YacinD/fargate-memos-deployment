variable "project_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "container_name" {
  type    = string
  default = "memos"
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 5230
}

variable "task_cpu" {
  type    = string
  default = "512"
}

variable "task_memory" {
  type    = string
  default = "1024"
}

variable "ephemeral_storage_gib" {
  type    = number
  default = 21
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "aws_region" {
  type = string
}

variable "db_secret_arn" {
  type = string
}