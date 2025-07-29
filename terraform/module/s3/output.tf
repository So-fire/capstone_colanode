output "S3_BUCKET_NAME" {
  value = aws_s3_bucket.s3_bucket.id
}
output "S3_BUCKET_ARN" {
  value = aws_s3_bucket.s3_bucket.arn
}