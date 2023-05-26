variable "environment" {
  description = "The Deployment environment"
}

variable "team" {
  description = "The Deployment team"
}

variable "project" {
  description = "The Deployment project"
}

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

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}
