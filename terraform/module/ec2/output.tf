output "public_instance_id" {
  value = aws_instance.public_instance.id
}
output "private_instance_id" {
  value = aws_instance.private_instance.id
}


output "public_ec2_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public_instance.public_ip
}

output "private_ec2_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private_instance.private_ip
}

output "account_id" {
  description = "Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "ami_id" {
  description = "AMI ID"
  value       = data.aws_ami.amazon_linux_2023.id
}

