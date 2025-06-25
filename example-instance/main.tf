provider "aws" {
  region = var.region
}

module "example_instance" {
  source         = "./modules/instance"  # Adjust path if needed
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
}

module "clahan_vpc" {
  source               = "./modules/vpc"
  vpc_name             = "Clahan-VPC"
  vpc_cidr             = "10.0.0.0/16"
  tenancy              = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


