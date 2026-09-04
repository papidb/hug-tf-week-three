output "public_subnet_id" {
  description = "The id of the public subnet created"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_ids" {
  description = "The ids of the private subnets created"
  value       = aws_subnet.private_subnet[*].id
}
