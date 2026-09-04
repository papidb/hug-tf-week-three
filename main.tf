provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "hug-tf-week-three"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# vpc
module "main_aws_vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}


# networking
module "networking" {
  source = "./modules/networking"

  vpc_id              = module.main_aws_vpc.vpc_id
  public_cidr_block   = var.public_cidr_block
  private_cidr_blocks = var.private_cidr_blocks
  environment         = var.environment
}


# security groups
module "security_group" {
  source = "./modules/security_group"

  vpc_id      = module.main_aws_vpc.vpc_id
  ssh_cidr    = var.ssh_cidr
  db_port     = var.db_port
  environment = var.environment
}


# instance
module "instance" {
  source = "./modules/instance"

  public_subnet_id  = module.networking.public_subnet_id
  security_group_id = module.security_group.compute_security_group_id
  instance_type     = var.instance_type
  instance_name     = "${var.environment}-web"
  public_key        = var.public_key
  environment       = var.environment

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    html_content = file("${path.module}/assets/index.html")
  })
}


# database
module "database" {
  source = "./modules/database"

  private_subnet_ids         = module.networking.private_subnet_ids
  database_security_group_id = module.security_group.database_security_group_id
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  db_password                = var.db_password
  db_port                    = var.db_port
  environment                = var.environment
}


# variables
variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_cidr_blocks" {
  description = "CIDR blocks for the private subnets (one per AZ, minimum two for RDS)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database in GiB"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "Port the database listens on"
  type        = number
  default     = 5432
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "ssh_cidr" {
  description = "Public IPv4 CIDR permitted to connect over SSH"
  type        = string
}

variable "public_key" {
  description = "SSH public key material for the web server. Leave empty to launch without a key pair."
  type        = string
  default     = ""
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
  description = "Public IP of the web server"
  value       = module.instance.instance_public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.main_aws_vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

output "db_endpoint" {
  description = "Connection endpoint for the database"
  value       = module.database.db_endpoint
}
