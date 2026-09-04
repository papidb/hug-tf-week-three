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
  description = "AMI ID for the instance. Leave empty to use the latest Ubuntu 22.04 LTS."
  default     = ""
}

variable "public_key" {
  type        = string
  description = "SSH public key material. Leave empty to launch without a key pair."
  default     = ""
}

variable "user_data" {
  type        = string
  description = "Cloud-init/user_data script to run at instance launch."
  default     = null
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
