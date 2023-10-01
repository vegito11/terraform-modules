locals {
  create_origin_access_control = var.create_origin_access_control && length(keys(var.origin_access_control)) > 0
}

resource "aws_s3_bucket" "bucket" {
  count = var.create_s3 ? 1 : 0

  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      dept = "storage"
    }
  )
}

### S3 Bucket Policy

resource "aws_s3_bucket_policy" "cdn_bkt_policy" {
  bucket = aws_s3_bucket.bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid"    = "AllowCloudFrontServicePrincipalReadOnly"
        "Effect" = "Allow"
        "Principal" = {
          "Service" = "cloudfront.amazonaws.com"
        },
        "Action"   = "s3:GetObject"
        "Resource" = "arn:aws:s3:::${aws_s3_bucket.bucket[0].id}/*"
        "Condition" = {
          "StringEquals" = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.frontend_distribution.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_control" "default" {
  count = var.create_origin_access_control ? 1 : 0

  name = var.origin_access_control.s3.name

  description                       = var.origin_access_control.s3.description
  origin_access_control_origin_type = var.origin_access_control.s3.origin_type
  signing_behavior                  = var.origin_access_control.s3.signing_behavior
  signing_protocol                  = var.origin_access_control.s3.signing_protocol
}

resource "aws_cloudfront_distribution" "frontend_distribution" {

  aliases             = var.aliases
  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id
  tags                = var.tags

  origin {
    domain_name              = var.create_s3 ? aws_s3_bucket.bucket[0].bucket_regional_domain_name : var.bucket_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default[0].id
    origin_id                = var.s3_origin_id != "" ? var.s3_origin_id : var.bucket_name
  }

  default_cache_behavior {

    target_origin_id       = var.s3_origin_id != "" ? var.s3_origin_id : var.bucket_name
    viewer_protocol_policy = var.default_cache.viewer_protocol_policy

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = var.default_cache.min_ttl
    default_ttl = var.default_cache.default_ttl
    max_ttl     = var.default_cache.max_ttl

    cached_methods = var.default_cache.cached_methods

    allowed_methods = var.default_cache.allowed_methods
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
