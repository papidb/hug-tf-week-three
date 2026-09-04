variable "vpc_id" {
  type        = string
  description = "The vpc id for the network to be created"
}

variable "public_cidr_block" {
  type        = string
  description = "The cidr block for the public subnet"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
