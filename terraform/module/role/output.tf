# =================================================================
#  IAM OUTPUT FOR PUBLIC EC2 ROLE
# =================================================================
output "PUBLIC_EC2_ROLE_ARN" {
  value = aws_iam_role.public_ec2_role.arn
}
output "PUBLIC_EC2_ROLE_NAME" {
  value = aws_iam_role.public_ec2_role.name
}

# =================================================================
#  IAM OUTPUT FOR PRIVATE EC2 ROLE
# =================================================================
output "PRIVATE_EC2_ROLE_ARN" {
  value = aws_iam_role.private_ec2_role.arn
}
output "PRIVATE_EC2_ROLE_NAME" {
  value = aws_iam_role.private_ec2_role.name
}

# =================================================================
#  OUTPUT FOR PUBLIC EC2 PROFILE NAME
# =================================================================
output "PUBLIC_EC2_INSTANCE_PROFILE_NAME" {
  value = aws_iam_instance_profile.public_profile.name
}

# =================================================================
#  OUTPUT FOR PRIVATE EC2 PROFILE NAME
# =================================================================
output "PRIVATE_EC2_INSTANCE_PROFILE_NAME" {
  value = aws_iam_instance_profile.private_profile.name
}

