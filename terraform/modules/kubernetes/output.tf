output "eks_cluster_name" {
  value = aws_eks_node_group.eks_worker_nodes_group.cluster_name
} 
