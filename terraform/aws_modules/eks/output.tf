output "eks_cluster_oidc_issuer" {
  value = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}