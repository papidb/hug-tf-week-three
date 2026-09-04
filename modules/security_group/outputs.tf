output "compute_security_group_id" {
  description = "The id of the compute security group"
  value       = aws_security_group.compute.id
}

output "database_security_group_id" {
  description = "The id of the database security group"
  value       = aws_security_group.database.id
}
