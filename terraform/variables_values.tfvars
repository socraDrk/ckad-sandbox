region = "eu-central-1"

//Tags
environment = "sandbox"
team = "k8s"
project = "ckad-sandbox"

//Networking
vpc_cidr = "172.10.0.0/16"
public_subnets_cidr = ["172.10.0.0/20", "172.10.16.0/20", "172.10.32.0/20"]
private_subnets_cidr = ["172.10.112.0/20", "172.10.128.0/20", "172.10.144.0/20"]
allowed_cidr_blocks = ["0.0.0.0/0"]


//Kubernetes
eks_max_size = 1
eks_min_size = 1
eks_desired_size = 1
eks_instances_types = "t3.small"
eks_version = "1.26"