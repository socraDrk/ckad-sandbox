variable "environment" {
  description = "The Deployment environment"
}

variable "private_subnets_ids" {
  description = "The ids of the private subnets"
}

variable "eks_instances_types" {
  description = "The types of the eks instances"
  default = "t3.small"
}

variable "eks_max_size" {
  description = "The maximum number of workers"
  type = number
  default = 1
}

variable "eks_min_size" {
  description = "The minimum number of workers"
  type = number
  default = 1
}

variable "eks_desired_size" {
  description = "The desired number of workers"
  type = number
  default = 1
}

variable "eks_version" {
  description = "The desired version of EKS"
  default = "1.24"
}