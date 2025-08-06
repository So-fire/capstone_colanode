resource "aws_iam_role" "public_ec2_role" {
  name = "${var.project_name}_public_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "private_ec2_role" {
  name = "${var.project_name}_private_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#########################################################################
# Instance Profiles
#####################################################################
resource "aws_iam_instance_profile" "public_profile" {
  name = "${var.project_name}_public_profile"
  role = aws_iam_role.public_ec2_role.name
}

resource "aws_iam_instance_profile" "private_profile" {
  name = "${var.project_name}_private_profile"
  role = aws_iam_role.private_ec2_role.name
}