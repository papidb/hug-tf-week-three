variable "vpc_id" {
  type        = string
  description = "The vpc id for the security group to be created"
}

variable "ssh_cidr" {
  type        = string
  description = "Public IPv4 CIDR permitted to connect over SSH"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
