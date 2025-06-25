output "instance_id" {
  value       = module.example_instance.instance_id
  description = "Instance ID"
}

output "instance_public_ip" {
  value       = module.example_instance.instance_public_ip
  description = "Public IP"
}

output "instance_private_ip" {
  value       = module.example_instance.instance_private_ip
  description = "Private IP"
}
