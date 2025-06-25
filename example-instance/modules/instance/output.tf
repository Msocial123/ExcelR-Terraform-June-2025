output "instance_id" {
  value       = aws_instance.web.id
  description = "Instance ID"
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP"
}

output "instance_private_ip" {
  value       = aws_instance.web.private_ip
  description = "Instance Private IP"
}
