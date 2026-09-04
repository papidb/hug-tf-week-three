output "instance_id" {
  description = "ID of the ec2 instance"
  value       = aws_instance.main_instance.id
}


output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.main_instance.public_ip
}
