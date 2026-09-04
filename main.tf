provider "aws" {
  region = "us-east-1"
}

# vpc
module "main_aws_vpc" {
  source = "./modules/vpc"

  vpc_cidr    = "10.0.0.0/16"
  environment = var.environment
}


# networking
module "networking" {
  source = "./modules/networking"

  vpc_id            = module.main_aws_vpc.vpc_id
  public_cidr_block = "10.0.0.0/24"
  environment       = var.environment
}


# rules
module "security_group" {
  source = "./modules/security_group"

  vpc_id      = module.main_aws_vpc.vpc_id
  ssh_cidr    = var.ssh_cidr
  environment = var.environment
}


# instance
module "instance" {
  source = "./modules/instance"

  public_subnet_id  = module.networking.public_subnet_id
  security_group_id = module.security_group.security_group_id
  instance_type     = "t3.micro"
  instance_name     = "main_instance"
  environment       = var.environment
}


# variables
variable "ssh_cidr" {
  description = "Public IPv4 CIDR permitted to connect over SSH"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, production)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

# outputs
output "instance_public_ip" {
  value = module.instance.instance_public_ip
}
