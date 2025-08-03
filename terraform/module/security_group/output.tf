####################################################################
# OUTPUT FOR PUBLIC EC2 SG
#######################################################################
output "PUBLIC_EC2_SG_ID" {
  value = aws_security_group.public_ec2.id
}
output "PUBLIC_EC2_SG_NAME" {
  value = aws_security_group.public_ec2.name
}

####################################################################
# output for private ec2 sg
#######################################################################
output "PRIVATE_EC2_SG_ID" {
  value = aws_security_group.private_ec2.id
}
output "PRIVATE_EC2_SG_NAME" {
  value = aws_security_group.private_ec2.name
}

####################################################################
# output for postgresql  sg
#######################################################################
output "POSTGRESQL_SG_ID" {
  value = aws_security_group.rds.id
}
output "POSTGRESQL_SG_NAME" {
  value = aws_security_group.rds.name
}

####################################################################
# output for valkey sg
#######################################################################
output "VALKEY_SG_ID" {
  value = aws_security_group.valkey.id
}
output "VALKEY_SG_NAME" {
  value = aws_security_group.valkey.name
}

####################################################################
# output for minio sg
#######################################################################
output "MINIO_SG_ID" {
  value = aws_security_group.minio.id
}
output "MINIO_SG_NAME" {
  value = aws_security_group.minio.name
}

####################################################################
# output for nat sg
#######################################################################
output "NAT_SG_ID" {
  value = aws_security_group.nat.id
}
output "NAT_SG_NAME" {
  value = aws_security_group.nat.name
}
