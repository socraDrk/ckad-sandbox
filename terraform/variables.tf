variable "region" {
  description = "eu-central-1"
}

variable "environment" {
  description = "The Deployment environment"
}

variable "team" {
  description = "The Deployment team"
}

variable "project" {
  description = "The Deployment project"
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}

variable "allowed_cidr_blocks" {
  type        = list
  description = "Allowed CIDR blocks for the default Security Group of the VPC"
}

//Kubernetes
variable "eks_instances_types" {
  description = "The types of the eks instances"
}

variable "eks_max_size" {
  description = "The maximum number of workers"
  type = number
}

variable "eks_min_size" {
  description = "The minimum number of workers"
  type = number
}

variable "eks_desired_size" {
  description = "The desired number of workers"
  type = number
}

variable "eks_version" {
  description = "The desired version of EKS"
  type = string
}