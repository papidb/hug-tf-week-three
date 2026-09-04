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
  description = "instance type of the instance (must be x86_64; the AMI is AMD64)"

  validation {
    # Reject ARM/Graviton families (e.g. a1, t4g, m6g, c7gn, r6gd, im4gn): they
    # need an ARM64 AMI, but this module looks up an AMD64 (x86_64) image.
    condition     = !can(regex("^(a1|[a-z]+[0-9]+g[a-z]*)\\.", var.instance_type))
    error_message = "instance_type must be an x86_64 type. ARM/Graviton types (a1, *g, e.g. t4g.micro) require an ARM64 AMI."
  }
}

variable "instance_name" {
  type        = string
  description = "instance name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
