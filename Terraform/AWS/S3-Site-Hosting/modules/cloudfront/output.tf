## WWW domain - CDN Name and Zone ID
output "root_s3_distribution-domain_name" {
  value = aws_cloudfront_distribution.root_s3_distribution.domain_name
}

output "root_s3_distribution-hosted_zone_id" {
  value = aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id  
}

## WWW domain - CDN Name and Zone ID
output "www_s3_distribution-domain_name" {
  value = aws_cloudfront_distribution.www_s3_distribution.domain_name
}

output "www_s3_distribution-hosted_zone_id" {
  value = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
}

