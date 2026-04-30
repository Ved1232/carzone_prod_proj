output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.carzone_ec2.public_ip
}

output "app_url" {
  description = "Application URL"
  value       = "http://${aws_instance.carzone_ec2.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to EC2"
  value       = "ssh -i your-key.pem ubuntu@${aws_instance.carzone_ec2.public_ip}"
}

output "private_key_file" {
  value = "${path.module}/carzone-key-pair.pem"
}

