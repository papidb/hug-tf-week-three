variable "vpc_id" {
  type        = string
  description = "The vpc id for the security groups to be created"
}

variable "ssh_cidr" {
  type        = string
  description = "Public IPv4 CIDR permitted to connect over SSH"
}

variable "db_port" {
  type        = number
  description = "Port the database listens on"
  default     = 5432
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
