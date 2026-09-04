output "instance_id" {
  description = "ID of the ec2 instance"
  value       = aws_instance.main_instance.id
}


output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.main_instance.public_ip
}

output "key_name" {
  description = "Name of the attached EC2 key pair, if any"
  value       = var.public_key != "" ? aws_key_pair.main[0].key_name : null
}
