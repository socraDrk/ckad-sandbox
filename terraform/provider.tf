provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
      bucket = "ckad-training"
      key    = "terraform/terraform.tfstate"
      region = "eu-central-1"
    }
}
