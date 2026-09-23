output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "state_bucket_arn" {
  value = aws_s3_bucket.tf_state.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.memos.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.memos.name
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}