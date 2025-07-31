######################################################################
#  security group for public ec2
##########################################################################
resource "aws_security_group" "public_ec2" {
  name        = "${var.project_name}-public-ec2-sg"
  description = "Allow HTTP/HTTPS and SSH from internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #make sure it is your ip/32 , for tutorial i will use 0.0.0.0 SSH (lock this down!)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-ec2-sg"
  }
}

######################################################################
#  security group for private ec2
##########################################################################

resource "aws_security_group" "private_ec2" {
  name        = "${var.project_name}-private-ec2-sg"
  description = "Allow app communication from public EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000 #Allow traffic on port 3000 from your public ec2
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS
  }

  ingress {
    from_port       = 6379 #Allow redis traffic on port 6379 from your public ec2
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  ingress {
    from_port       = 9000 ##Allow traffic on port 9000 from your public ec2 (MinIO or S3 mimic.)
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22 # Allow SSH to the private EC2, but only through the public EC2 (bastion style).
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-private-ec2-sg"
  }
}

######################################################################
#  security group for database postgresql
######################################################################
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow DB access from backend EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}


######################################################################
#  security group for database valkey (Redis cace)
######################################################################
resource "aws_security_group" "valkey" {
  name        = "${var.project_name}-valkey-sg"
  description = "Allow Redis access from backend EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2.id]
  }

  tags = {
    Name = "${var.project_name}-valkey-sg"
  }
}

######################################################################
#  security group for database MINIO (S3)
######################################################################
resource "aws_security_group" "minio" {
  name        = "${var.project_name}-minio-sg"
  description = "MinIO S3-compatible access from backend EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2.id]
  }

  ingress {
    from_port       = 9001
    to_port         = 9001
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2.id]
  }

  tags = {
    Name = "${var.project_name}-minio-sg"
  }
}

######################################################################
#  security group for NAT needed if private EC2 pulls from the internet (e.g., to apt update or DockerHub).
######################################################################
resource "aws_security_group" "nat" {
  name   = "${var.project_name}-nat-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-nat-sg"
  }
}
