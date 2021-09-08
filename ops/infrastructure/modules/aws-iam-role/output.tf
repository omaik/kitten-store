output "arn" {
  value = aws_iam_role.role.arn
  
  # Wait on all policies attachments before providing output
  depends_on = [
    aws_iam_role_policy_attachment.attached_policy,
    aws_iam_role_policy.inline_policy
  ]
}

output "name" {
  value = aws_iam_role.role.name
}