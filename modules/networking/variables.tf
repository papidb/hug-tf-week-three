variable "vpc_id" {
  type        = string
  description = "The vpc id for the network to be created"
}

variable "public_cidr_block" {
  type        = string
  description = "The cidr block for the public subnet"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for the private subnets (one per AZ, minimum two for RDS)"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
