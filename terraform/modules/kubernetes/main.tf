data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "eks_iam_role" {
 name = "${var.environment}-eks-iam-role"
 path = "/"

 assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
 managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

resource "aws_eks_cluster" "eks_cluster" {
 name = "${var.environment}-eks-cluster"
 role_arn = aws_iam_role.eks_iam_role.arn
 version = var.eks_version

 vpc_config {
  subnet_ids = var.private_subnets_ids
 }
}

resource "aws_iam_role" "eks_worker_nodes_iam_role" {
  name = "${var.environment}-eks-node-group-iam-role"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
   "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
 }

  resource "aws_eks_node_group" "eks_worker_nodes_group" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.environment}-eks-worker-node-group"
  node_role_arn  = aws_iam_role.eks_worker_nodes_iam_role.arn
  subnet_ids   = var.private_subnets_ids
  instance_types = ["${var.eks_instances_types}"]
 
  scaling_config {
   desired_size = var.eks_desired_size
   max_size   = var.eks_max_size
   min_size   = var.eks_min_size
  }
 }