variable "vpc_cidr" {
  type        = string
  description = "The vpc's cidr block"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}
