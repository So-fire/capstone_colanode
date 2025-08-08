resource "aws_key_pair" "colanode" {
  key_name   = "colanode-key"
  public_key = file("${path.module}/keys/colanode-key.pub")
}


data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_caller_identity" "current" {}

#######################################################
# EC2  for public interface
#####################################################
resource "aws_instance" "public_instance" {
  ami = data.aws_ami.amazon_linux_2023.id

  instance_type = var.ec2_instance_type

  iam_instance_profile = var.PUBLIC_EC2_INSTANCE_PROFILE_NAME

  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = var.PUBLIC_EC2_SG_ID
  associate_public_ip_address = true

  key_name = aws_key_pair.colanode.key_name


  tags = {
    Name        = "${var.project_name}-public_ec2"
    Environment = var.environment
  }
}


#######################################################
# EC2  for private interface
###################################################
resource "aws_instance" "private_instance" {
  ami = data.aws_ami.amazon_linux_2023.id

  instance_type = var.ec2_instance_type

  iam_instance_profile = var.PRIVATE_EC2_INSTANCE_PROFILE_NAME
  #tis will run te script on te private instance to fetc db credentials from secret manager also it will Pass DB_HOST and DB_PORT from Terraform
  user_data = templatefile("${path.module}/script/secret_script.sh", {
    DB_HOST = var.rds_endpoint
    DB_PORT = var.rds_port
    SECRET_NAME = var.shared_db_secret_name

  })


  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = var.PRIVATE_EC2_SG_ID
  associate_public_ip_address = false

  key_name = aws_key_pair.colanode.key_name


  tags = {
    Name        = "${var.project_name}-private_ec2"
    Environment = var.environment
  }
}