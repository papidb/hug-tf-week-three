output "public_subnet_id" {
  description = "The id of the public subnet created"
  value       = aws_subnet.public_subnet.id
}
