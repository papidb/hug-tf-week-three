variable "public_subnet_id" {
  type        = string
  description = "The id of the public subnet"
}

variable "security_group_id" {
  type        = string
  description = "The id of the security group needed for instance"
}

variable "ami" {
  type        = string
  description = "ami of the instance"
}

variable "instance_type" {
  type        = string
  description = "instance type of the instance"
}

variable "instance_name" {
  type        = string
  description = "instance name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
