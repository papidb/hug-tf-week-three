output "security_group_id" {
  description = "The id of the created security group"
  value       = aws_security_group.allow_default_ssh_and_http_ports_security_group.id
}
