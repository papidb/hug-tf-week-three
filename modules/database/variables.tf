variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, production)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet ids for the DB subnet group (minimum two AZs)"
}

variable "database_security_group_id" {
  type        = string
  description = "Security group id that governs access to the database"
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL major engine version. RDS selects the latest matching minor."
  default     = "16"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GiB"
  default     = 20
}

variable "storage_type" {
  type        = string
  description = "Storage type for the DB instance"
  default     = "gp3"
}

variable "db_name" {
  type        = string
  description = "Name of the initial database"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Master username for the database"
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}

variable "db_port" {
  type        = number
  description = "Port the database listens on"
  default     = 5432
}
