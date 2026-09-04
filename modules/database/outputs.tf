output "db_instance_id" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.main.id
}

output "db_endpoint" {
  description = "Connection endpoint for the database"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Hostname of the database instance"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Port the database listens on"
  value       = aws_db_instance.main.port
}
