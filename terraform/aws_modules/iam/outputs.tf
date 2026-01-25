output "role_arn" {
  value = {
    cluster_role_arn = aws_iam_role.cluster_role.arn
    node_role_arn = aws_iam_role.node_role.arn
  }
}
