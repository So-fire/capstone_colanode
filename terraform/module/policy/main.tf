#################################################################
#  policy for private ec2
###################################################################

resource "aws_iam_policy" "private_ec2_policy" {
  name        = "${var.project_name}_private_ec2_policy"
  description = "Private EC2 policy for backend components"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Optional: CloudWatch Logging
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      # Access Secrets Manager
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      },

      # View RDS info
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ]
        Resource = "*"
      },

      # Access S3 (MinIO mimic)
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-bucket-*",
          "arn:aws:s3:::${var.project_name}-bucket-*/*"
        ]
      },

      # Optional: EFS
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess"
        ]
        Resource = "*"
      }
    ]
  })
}


#################################################################
#  policy for public ec2
###################################################################

resource "aws_iam_policy" "public_ec2_policy" {
  name        = "${var.project_name}_public_ec2_policy"
  description = "Public EC2 policy: basic logging and optional S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      #   {
      #     Effect = "Allow"
      #     Action = [
      #       "s3:GetObject",
      #       "s3:ListBucket"
      #     ]
      #     Resource = [
      #       "arn:aws:s3:::${var.project_name}-bucket-*",
      #       "arn:aws:s3:::${var.project_name}-bucket-*/*"
      #     ]
      #   }
    ]
  })
}




# Attach policies
resource "aws_iam_role_policy_attachment" "public_attach" {
  role       = var.PUBLIC_EC2_ROLE_NAME
  policy_arn = aws_iam_policy.public_ec2_policy.arn
}



resource "aws_iam_role_policy_attachment" "private_attach" {
  role       = var.PRIVATE_EC2_ROLE_NAME
  policy_arn = aws_iam_policy.private_ec2_policy.arn
}
