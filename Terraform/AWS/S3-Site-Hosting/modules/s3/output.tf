#  Output of S3 Website Bucket endpoint.
output "dom-bucket-endpoint" {
  value = aws_s3_bucket.www_bucket.website_endpoint
}

output "www-dom-bucket-endpoint" {
  value = aws_s3_bucket.root_bucket.website_endpoint 
} 