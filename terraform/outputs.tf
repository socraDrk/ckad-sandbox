output "eks_cluster_name" {
  value = module.kubernetes.eks_cluster_name
}

output "ecs_backend_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecs_frontend_url" {
  value = aws_ecr_repository.frontend.repository_url
}